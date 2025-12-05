import os
import time
import markdown
import json
import base64
from flask import Flask, render_template, request, Response, stream_with_context
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.common.exceptions import TimeoutException, NoSuchElementException

app = Flask(__name__)

# Configuration
STORIES_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'estorias'))
DATA_FILE = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'arquivos', 'data.md'))
CREDENTIALS_FILE = os.path.abspath(os.path.join(os.path.dirname(__file__), 'credentials.json'))

def load_credentials():
    if os.path.exists(CREDENTIALS_FILE):
        try:
            with open(CREDENTIALS_FILE, 'r') as f:
                data = json.load(f)
                if isinstance(data, dict):
                    return [data]
                return data
        except:
            pass
    return []

def save_credentials_to_file(username, password):
    try:
        creds = load_credentials()
        updated = False
        for c in creds:
            if c['username'] == username:
                c['password'] = password
                updated = True
                break
        
        if not updated:
            creds.append({"username": username, "password": password})

        with open(CREDENTIALS_FILE, 'w') as f:
            json.dump(creds, f, indent=4)
    except Exception as e:
        print(f"Erro ao salvar credenciais: {e}")

def get_stories():
    stories = []
    if not os.path.exists(STORIES_DIR):
        return stories
    for filename in os.listdir(STORIES_DIR):
        if filename.endswith(".md"):
            stories.append(filename)
    return stories

def send_event(event_type, payload):
    """Helper to format SSE messages with JSON data"""
    data = json.dumps({"type": event_type, "payload": payload})
    return f"data: {data}\n\n"

def capture_screenshot(driver):
    """Captures screenshot and returns base64 string"""
    try:
        return driver.get_screenshot_as_base64()
    except:
        return None

def find_field_by_label_or_id(driver, field_id, label_text):
    """Encontra campo usando Deep Search (Shadow DOM) e estratégias padrão"""
    
    # 1. Deep Search via JS (Shadow DOM support) - Abordagem recursiva
    js_search = """
        function findElementDeep(root, id_pattern, label_pattern) {
            if (!root) return null;
            
            // Verifica o elemento atual
            if (root.id === id_pattern) return root;
            
            // Verifica atributos comuns de input
            if ((root.tagName === 'INPUT' || root.tagName === 'SELECT' || root.tagName === 'TEXTAREA') && label_pattern) {
                if (root.getAttribute('aria-label') && root.getAttribute('aria-label').includes(label_pattern)) return root;
                if (root.getAttribute('title') && root.getAttribute('title').includes(label_pattern)) return root;
                if (root.getAttribute('placeholder') && root.getAttribute('placeholder').includes(label_pattern)) return root;
            }

            // Shadow Root
            if (root.shadowRoot) {
                var res = findElementDeep(root.shadowRoot, id_pattern, label_pattern);
                if (res) return res;
            }

            // Children
            if (root.children) {
                for (var i = 0; i < root.children.length; i++) {
                    var res = findElementDeep(root.children[i], id_pattern, label_pattern);
                    if (res) return res;
                }
            }
            return null;
        }
        return findElementDeep(document.body, arguments[0], arguments[1]);
    """
    
    try:
        el = driver.execute_script(js_search, field_id, label_text)
        if el:
            # Garante visibilidade
            driver.execute_script("arguments[0].scrollIntoView({behavior: 'auto', block: 'center'});", el)
            time.sleep(0.5)
            return el
    except:
        pass

    # 2. Estratégias Selenium Padrão (Fallback)
    strategies = [
        (By.ID, field_id),
        (By.XPATH, f"//input[contains(@aria-label, '{label_text}')]"),
        (By.XPATH, f"//select[contains(@aria-label, '{label_text}')]"),
        (By.XPATH, f"//textarea[contains(@aria-label, '{label_text}')]"),
        (By.XPATH, f"//label[contains(text(), '{label_text}')]/following::input[1]"),
        (By.XPATH, f"//label[contains(text(), '{label_text}')]/following::select[1]"),
        (By.XPATH, f"//*[@title='{label_text}']"),
        (By.XPATH, f"//*[@placeholder='{label_text}']")
    ]

    for by_type, selector in strategies:
        try:
            els = driver.find_elements(by_type, selector)
            for el in els:
                if el.is_displayed():
                    driver.execute_script("arguments[0].scrollIntoView({behavior: 'auto', block: 'center'});", el)
                    time.sleep(0.5)
                    return el
        except:
            pass
    
    return None

def automation_process(username, password, module, assigned_to):
    yield send_event("log", "Iniciando processo de automação...")
    yield send_event("log", f"Responsável selecionado: {assigned_to}")
    
    stories = get_stories()
    if not stories:
        yield send_event("log", "Nenhum arquivo de estória encontrado.")
        return

    yield send_event("log", f"Encontrados {len(stories)} arquivos de estória.")

    # Determine Parent STRY based on Module
    parent_stry = ""
    if module == "ANIMAL":
        parent_stry = "STRY0086405"
    elif module == "MIGRAÇÃO":
        parent_stry = "STRY0088413"
    else:
        yield send_event("log", f"Módulo desconhecido: {module}")
        return

    yield send_event("log", f"Módulo selecionado: {module}. Parent STRY: {parent_stry}")

    driver = None
    try:
        yield send_event("log", "Inicializando WebDriver...")
        
        chrome_options = Options()
        # chrome_options.add_argument("--headless") # Optional: Uncomment to hide browser window
        chrome_options.add_argument("--window-size=1920,1080")
        
        service = Service(ChromeDriverManager().install())
        driver = webdriver.Chrome(service=service, options=chrome_options)
        driver.maximize_window()

        # 1. Login
        login_url = "https://mti.service-now.com/now/nav/ui/classic/params/target/%24agile_board.do%23%2Fsprint_planning"
        yield send_event("log", f"Acessando {login_url}...")
        driver.get(login_url)
        yield send_event("image", capture_screenshot(driver))

        wait = WebDriverWait(driver, 20)
        
        yield send_event("log", "Realizando login...")
        try:
            user_field = wait.until(EC.presence_of_element_located((By.ID, "username")))
            user_field.send_keys(username)
            
            pass_field = driver.find_element(By.ID, "password")
            pass_field.send_keys(password)
            yield send_event("image", capture_screenshot(driver))
            
            try:
                login_btn = driver.find_element(By.ID, "login_button")
                login_btn.click()
            except:
                pass_field.submit()
                
            yield send_event("log", "Login enviado.")
            time.sleep(5) # Wait for login to process
            yield send_event("image", capture_screenshot(driver))
        except Exception as e:
            yield send_event("log", f"Erro no login: {str(e)}")
            return

        # Loop through stories
        for i, filename in enumerate(stories):
            yield send_event("log", f"Processando estória {i+1}/{len(stories)}: {filename}")
            
            file_path = os.path.join(STORIES_DIR, filename)
            with open(file_path, 'r', encoding='utf-8') as f:
                content_md = f.read()
                
            lines = content_md.split('\n')
            title = filename
            for line in lines:
                if line.startswith("# "):
                    title = line.replace("# ", "").strip()
                    break
            
            content_html = markdown.markdown(content_md)
            
            # If not first iteration, return to board
            if i > 0:
                yield send_event("log", "Retornando para a página inicial...")
                driver.get("https://mti.service-now.com/now/nav/ui/classic/params/target/%24agile_board.do%23%2Fsprint_planning")
                time.sleep(3)
                yield send_event("image", capture_screenshot(driver))

            # 2. Handle Popup
            try:
                close_btn = driver.find_element(By.ID, "close-messages-btn")
                if close_btn.is_displayed():
                    close_btn.click()
                    yield send_event("log", "Popup fechado.")
                    time.sleep(1)
                    yield send_event("image", capture_screenshot(driver))
            except:
                pass

            # 3. Search (Direct Link Approach)
            yield send_event("log", f"Navegando diretamente para a Story {parent_stry}...")
            try:
                # URL fornecida pelo usuário, substituindo o termo de busca
                search_url = f"https://mti.service-now.com/now/nav/ui/search/0f8b85d0c7922010099a308dc7c2606a/params/search-term/{parent_stry}/global-search-data-config-id/c861cea2c7022010099a308dc7c26041/back-button-label/MTI-%20Planejamento%20de%20sprint/search-context/now%2Fnav%2Fui"
                
                driver.get(search_url)
                time.sleep(5)
                yield send_event("image", capture_screenshot(driver))
                
                yield send_event("log", "Página de busca carregada. Procurando resultado na lista...")
                
                # Busca profunda via JS para encontrar o LI específico (Shadow DOM support)
                found_deep = False
                start_search = time.time()
                while time.time() - start_search < 10:
                    found_deep = driver.execute_script("""
                        function findAndClick(root, text) {
                            if (!root) return false;
                            
                            // Procura por LI com a classe específica e o texto da Story
                            if (root.tagName === 'LI' && root.classList.contains('focus-record')) {
                                if (root.textContent.includes(text)) {
                                    root.scrollIntoView();
                                    root.click();
                                    return true;
                                }
                            }
                            
                            // Shadow Root
                            if (root.shadowRoot) {
                                if (findAndClick(root.shadowRoot, text)) return true;
                            }

                            // Children
                            if (root.children) {
                                for (let i = 0; i < root.children.length; i++) {
                                    if (findAndClick(root.children[i], text)) return true;
                                }
                            }
                            return false;
                        }
                        return findAndClick(document.body, arguments[0]);
                    """, parent_stry)
                    
                    if found_deep:
                        yield send_event("log", "Item da lista encontrado e clicado.")
                        break
                    time.sleep(1)
                
                if not found_deep:
                    # Fallback genérico para qualquer link/texto contendo a Story
                    yield send_event("log", "Item específico não encontrado. Tentando clique genérico...")
                    found_generic = driver.execute_script("""
                        function findAndClickGeneric(root, text) {
                            if (!root) return false;
                            // Tenta clicar em qualquer elemento que pareça ser o container do resultado
                            if ((root.tagName === 'A' || root.tagName === 'LI' || root.getAttribute('role') === 'button') && root.textContent.includes(text)) {
                                root.click();
                                return true;
                            }
                            if (root.shadowRoot) { if (findAndClickGeneric(root.shadowRoot, text)) return true; }
                            if (root.children) { for (let i=0; i<root.children.length; i++) { if (findAndClickGeneric(root.children[i], text)) return true; } }
                            return false;
                        }
                        return findAndClickGeneric(document.body, arguments[0]);
                    """, parent_stry)
                    
                    if not found_generic:
                        raise Exception(f"Não foi possível clicar no resultado para {parent_stry}")

                time.sleep(5)
                yield send_event("image", capture_screenshot(driver))

            except Exception as e:
                yield send_event("log", f"Erro na navegação/busca: {str(e)}")
                continue

            # 5. Click "New" in Scrum Tasks tab (Polaris/Shadow DOM Support)
            yield send_event("log", "Buscando contexto do formulário (Iframe/Shadow DOM)...")
            
            # Script para encontrar o iframe gsft_main mesmo dentro de Shadow DOM
            found_iframe = driver.execute_script("""
                function findIframe(root) {
                    if (!root) return null;
                    if (root.querySelector) {
                        var iframe = root.querySelector('iframe[name="gsft_main"], iframe#gsft_main');
                        if (iframe) return iframe;
                    }
                    if (root.shadowRoot) {
                        var res = findIframe(root.shadowRoot);
                        if (res) return res;
                    }
                    if (root.children) {
                        for(var i=0; i<root.children.length; i++) {
                            var res = findIframe(root.children[i]);
                            if (res) return res;
                        }
                    }
                    return null;
                }
                return findIframe(document.body);
            """)

            if found_iframe:
                yield send_event("log", "Iframe principal encontrado! Entrando...")
                driver.switch_to.frame(found_iframe)
            else:
                yield send_event("log", "Iframe não encontrado via JS. Tentando switch padrão...")
                try:
                    driver.switch_to.default_content()
                    driver.switch_to.frame("gsft_main")
                except:
                    pass

            # Agora dentro do contexto (espera-se), tenta interagir
            found_btn = False
            
            # 1. Garante que as listas relacionadas estão visíveis (Scroll)
            driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
            time.sleep(2)

            # 2. Tenta clicar na aba "Tarefas de Scrum" / "Scrum Tasks" se houver abas
            try:
                tabs = driver.find_elements(By.CSS_SELECTOR, ".tab_caption_text")
                for tab in tabs:
                    if "scrum" in tab.text.lower() or "tarefa" in tab.text.lower():
                        tab.click()
                        yield send_event("log", f"Aba clicada: {tab.text}")
                        time.sleep(2)
                        break
            except:
                pass

            # 3. Busca o botão "Novo"
            start_time = time.time()
            while time.time() - start_time < 15:
                try:
                    # Estratégias de busca baseadas na imagem fornecida (Texto "Novo(a)")
                    strategies = [
                        (By.XPATH, "//button[normalize-space()='Novo(a)']"), # Texto exato da imagem
                        (By.XPATH, "//button[contains(text(), 'Novo(a)')]"), # Contém texto
                        (By.ID, "sysverb_new"), # ID padrão
                        (By.CSS_SELECTOR, "button[data-action-name='sysverb_new']"), # Atributo de ação
                        (By.CSS_SELECTOR, ".list_action_button[data-action-name='sysverb_new']") # Classe comum
                    ]
                    
                    for by_type, selector in strategies:
                        btns = driver.find_elements(by_type, selector)
                        for btn in btns:
                            if btn.is_displayed():
                                # Verifica se pertence à lista de Scrum Tasks
                                driver.execute_script("arguments[0].scrollIntoView({behavior: 'auto', block: 'center'});", btn)
                                time.sleep(0.5)
                                btn.click()
                                found_btn = True
                                yield send_event("log", f"Botão 'Novo' clicado via {selector}!")
                                break
                        if found_btn: break
                    
                    if found_btn: break
                    
                    # Fallback API GlideList2
                    result = driver.execute_script("""
                        if (typeof GlideList2 !== 'undefined') {
                            for (var key in GlideList2.listsMap) {
                                if (key.indexOf('rm_scrum_task') !== -1 || key.indexOf('scrum') !== -1) {
                                    GlideList2.get(key).action('sysverb_new');
                                    return true;
                                }
                            }
                        }
                        return false;
                    """)
                    if result:
                        found_btn = True
                        yield send_event("log", "Botão acionado via GlideList2 API!")
                        break

                except Exception as e:
                    pass
                
                time.sleep(1)

            if not found_btn:
                 raise Exception("Botão 'Novo' não encontrado após varredura completa.")

            time.sleep(3)
            yield send_event("image", capture_screenshot(driver))

            # 7. Fill fields
            yield send_event("log", "Aguardando carregamento do formulário (5s)...")
            time.sleep(5)
            
            yield send_event("log", "Preenchendo formulário de Nova Tarefa...")
            try:
                # Garante iframe (Deep Search novamente para garantir contexto)
                yield send_event("log", "Re-verificando contexto do iframe para preenchimento...")
                
                # CRITICAL FIX: Always reset to top-level before searching for the iframe
                driver.switch_to.default_content()
                
                found_iframe_form = driver.execute_script("""
                    function findIframe(root) {
                        if (!root) return null;
                        if (root.querySelector) {
                            var iframe = root.querySelector('iframe[name="gsft_main"], iframe#gsft_main');
                            if (iframe) return iframe;
                        }
                        if (root.shadowRoot) {
                            var res = findIframe(root.shadowRoot);
                            if (res) return res;
                        }
                        if (root.children) {
                            for(var i=0; i<root.children.length; i++) {
                                var res = findIframe(root.children[i]);
                                if (res) return res;
                            }
                        }
                        return null;
                    }
                    return findIframe(document.body);
                """)
                
                if found_iframe_form:
                    yield send_event("log", "Iframe do formulário encontrado via JS! Entrando...")
                    driver.switch_to.frame(found_iframe_form)
                else:
                    # Fallback
                    yield send_event("log", "Iframe não encontrado via JS. Tentando switch padrão 'gsft_main'...")
                    try:
                        driver.switch_to.frame("gsft_main")
                    except:
                        pass

                # DEBUG: Check where we are
                try:
                    current_url = driver.current_url
                    page_title = driver.title
                    yield send_event("log", f"Contexto atual - URL: {current_url}, Título: {page_title}")
                    
                    # Check for a known element to confirm we are in the form
                    try:
                        WebDriverWait(driver, 10).until(
                            EC.presence_of_element_located((By.ID, "sysverb_insert"))
                        )
                        yield send_event("log", "Botão 'Submit' detectado. Formulário carregado.")
                    except:
                        yield send_event("log", "ALERTA: Botão 'Submit' não encontrado. O formulário pode não ter carregado corretamente.")
                        # Dump HTML for analysis
                        html_dump = driver.page_source[:2000] # First 2000 chars
                        yield send_event("log", f"HTML Dump (início): {html_dump}")
                except Exception as e:
                    yield send_event("log", f"Erro ao verificar contexto: {e}")

                # Define o valor do campo Primário (Parent) baseado no módulo
                # Normaliza para comparação
                module_upper = module.upper() if module else ""
                primary_value = "STRY0086405" if "ANIMAL" in module_upper else "STRY0088413"
                
                yield send_event("log", f"Preenchendo Parent com: {primary_value} (Módulo: {module})")

                # 1. Primário (Parent)
                try:
                    parent_field = find_field_by_label_or_id(driver, "sys_display.rm_scrum_task.parent", "Primário")
                    if not parent_field: raise Exception("Campo não encontrado")
                    
                    parent_field.clear()
                    parent_field.send_keys(primary_value)
                    time.sleep(2) # Wait for autocomplete
                    parent_field.send_keys(Keys.TAB)
                    yield send_event("log", "Campo 'Primário' preenchido.")
                except Exception as e:
                    yield send_event("log", f"Erro no campo Primário: {e}")

                # 2. Serviço
                try:
                    service_field = find_field_by_label_or_id(driver, "sys_display.rm_scrum_task.business_service", "Serviço")
                    if service_field:
                        service_field.clear()
                        service_field.send_keys("C3SW - Solução de Software v1.2")
                        time.sleep(1)
                        service_field.send_keys(Keys.TAB)
                        yield send_event("log", "Campo 'Serviço' preenchido.")
                    else:
                        yield send_event("log", "Campo 'Serviço' não encontrado.")
                except Exception as e:
                    yield send_event("log", f"Erro no campo Serviço: {e}")

                # 3. Oferta de serviço
                try:
                    offering_field = find_field_by_label_or_id(driver, "sys_display.rm_scrum_task.service_offering", "Oferta de serviço")
                    if offering_field:
                        offering_field.clear()
                        offering_field.send_keys("[Média] Manter especificação de operação")
                        time.sleep(1)
                        offering_field.send_keys(Keys.TAB)
                        yield send_event("log", "Campo 'Oferta de serviço' preenchido.")
                    else:
                        yield send_event("log", "Campo 'Oferta de serviço' não encontrado.")
                except Exception as e:
                    yield send_event("log", f"Erro no campo Oferta de serviço: {e}")

                # 4. Tipo (Select)
                try:
                    from selenium.webdriver.support.ui import Select
                    # Tenta achar o select pelo ID ou Label
                    type_el = find_field_by_label_or_id(driver, "rm_scrum_task.type", "Tipo")
                    if not type_el:
                        # Fallback específico para Select se a função genérica falhar (pois ela foca em input)
                        type_el = driver.find_element(By.XPATH, "//select[contains(@aria-labelledby, 'type')]")
                    
                    if type_el:
                        type_select = Select(type_el)
                        type_select.select_by_visible_text("Documentação")
                        yield send_event("log", "Campo 'Tipo' selecionado.")
                    else:
                         yield send_event("log", "Campo 'Tipo' não encontrado.")
                except Exception as e:
                    yield send_event("log", f"Erro no campo Tipo: {e}")

                # 5. Estado (Select)
                try:
                    state_el = find_field_by_label_or_id(driver, "rm_scrum_task.state", "Estado")
                    if not state_el:
                         state_el = driver.find_element(By.XPATH, "//select[contains(@aria-labelledby, 'state')]")

                    if state_el:
                        state_select = Select(state_el)
                        state_select.select_by_visible_text("Cadastrado")
                        yield send_event("log", "Campo 'Estado' selecionado.")
                    else:
                        yield send_event("log", "Campo 'Estado' não encontrado.")
                except Exception as e:
                    yield send_event("log", f"Erro no campo Estado: {e}")

                # 6. Atribuição a
                try:
                    assigned_field = find_field_by_label_or_id(driver, "sys_display.rm_scrum_task.assigned_to", "Atribuição a")
                    if assigned_field:
                        assigned_field.clear()
                        assigned_field.send_keys(assigned_to)
                        time.sleep(1)
                        assigned_field.send_keys(Keys.TAB)
                        yield send_event("log", f"Campo 'Atribuição a' preenchido com: {assigned_to}")
                    else:
                        yield send_event("log", "Campo 'Atribuição a' não encontrado.")
                except Exception as e:
                    yield send_event("log", f"Erro no campo Atribuição a: {e}")

                # 7. Descrição resumida
                try:
                    short_desc_field = find_field_by_label_or_id(driver, "rm_scrum_task.short_description", "Descrição resumida")
                    if short_desc_field:
                        short_desc_field.clear()
                        short_desc_val = f"[Especificar US] {title}"
                        short_desc_field.send_keys(short_desc_val)
                        yield send_event("log", "Campo 'Descrição resumida' preenchido.")
                    else:
                        yield send_event("log", "Campo 'Descrição resumida' não encontrado.")
                except Exception as e:
                    yield send_event("log", f"Erro no campo Descrição resumida: {e}")

                # 8. Descrição HTML
                try:
                    yield send_event("log", "Tentando preencher Descrição HTML via JS (g_form)...")
                    safe_html = json.dumps(content_html)
                    driver.execute_script(f"g_form.setValue('html_description', {safe_html});")
                    yield send_event("log", "Descrição HTML preenchida via JS.")
                except:
                    yield send_event("log", "JS falhou. Tentando injeção direta no TinyMCE...")
                    try:
                        # Tenta encontrar o iframe do editor
                        editor_iframe = driver.find_element(By.CSS_SELECTOR, "iframe[id*='html_description']")
                        driver.switch_to.frame(editor_iframe)
                        body = driver.find_element(By.ID, "tinymce")
                        driver.execute_script("arguments[0].innerHTML = arguments[1];", body, content_html)
                        driver.switch_to.parent_frame()
                        yield send_event("log", "Descrição HTML preenchida via Iframe.")
                    except Exception as e:
                        yield send_event("log", f"Erro no campo Descrição HTML: {e}")

                yield send_event("image", capture_screenshot(driver))

                yield send_event("log", "Enviando formulário...")
                try:
                    submit_btn = find_field_by_label_or_id(driver, "sysverb_insert", "Submit")
                    if not submit_btn:
                        submit_btn = driver.find_element(By.ID, "sysverb_insert")
                    submit_btn.click()
                    yield send_event("log", "Formulário enviado com sucesso!")
                except Exception as e:
                    yield send_event("log", f"Erro ao enviar formulário: {e}")
                    # Tenta via JS direto como último recurso
                    driver.execute_script("if(typeof gsftSubmit === 'function') gsftSubmit(document.getElementById('sysverb_insert'));")

                time.sleep(5)
                yield send_event("image", capture_screenshot(driver))
                yield send_event("log", "Tarefa criada com sucesso!")

            except Exception as e:
                yield send_event("log", f"Erro ao preencher formulário: {str(e)}")
                continue

            except Exception as e:
                yield send_event("log", f"Erro ao preencher formulário: {str(e)}")
                continue

        yield send_event("log", "Processo finalizado.")

    except Exception as e:
        yield send_event("log", f"Erro fatal: {str(e)}")
    finally:
        if driver:
            driver.quit()

@app.route('/')
def index():
    credentials = load_credentials()
    return render_template('index.html', saved_users=credentials)

@app.route('/start', methods=['POST'])
def start():
    username = request.form.get('username')
    password = request.form.get('password')
    module = request.form.get('module')
    assigned_to = request.form.get('assigned_to')
    save_creds = request.form.get('save_credentials')
    
    if save_creds == 'true':
        save_credentials_to_file(username, password)
    
    return Response(stream_with_context(automation_process(username, password, module, assigned_to)), mimetype='text/event-stream')

if __name__ == '__main__':
    print("Iniciando servidor Flask na porta 5000...")
    app.run(host='0.0.0.0', debug=False, port=5000)
