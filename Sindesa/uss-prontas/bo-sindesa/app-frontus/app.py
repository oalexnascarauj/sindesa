from flask import Flask, render_template, request, jsonify, send_from_directory
import os
import json
import glob
from openai import OpenAI

app = Flask(__name__)

# Configuration file path
CONFIG_FILE = 'config.json'

# Global session storage (in-memory for simplicity)
# Structure: { 'session_id': { 'history': [], 'trained': False } }
sessions = {}

def load_config():
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'r', encoding='utf-8') as f:
            return json.load(f)
    return {
        "api_key": "",
        "base_url": "https://api.openai.com/v1",
        "model": "gpt-4o",
        "training_path": "",
        "output_path": "",
        "system_prompt": "Você é um especialista em criar Estórias de Usuário no padrão LogLab."
    }

def save_config(config):
    with open(CONFIG_FILE, 'w', encoding='utf-8') as f:
        json.dump(config, f, indent=4)

def get_training_content(path):
    content = ""
    if not os.path.exists(path):
        return "Diretório de treinamento não encontrado."
    
    files = glob.glob(os.path.join(path, "**/*.md"), recursive=True) + \
            glob.glob(os.path.join(path, "**/*.txt"), recursive=True)
    
    for file_path in files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content += f"\n--- INÍCIO ARQUIVO: {os.path.basename(file_path)} ---\n"
                content += f.read()
                content += f"\n--- FIM ARQUIVO ---\n"
        except Exception as e:
            print(f"Erro ao ler {file_path}: {e}")
    return content

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/config', methods=['GET', 'POST'])
def config_handler():
    if request.method == 'POST':
        new_config = request.json
        save_config(new_config)
        return jsonify({"status": "success", "message": "Configuração salva!"})
    return jsonify(load_config())

@app.route('/api/generate', methods=['POST'])
def generate():
    data = request.json
    code = data.get('code')
    session_id = data.get('session_id', 'default')
    
    config = load_config()
    
    if not config.get('api_key'):
        return jsonify({"error": "Chave de API não configurada."}), 400

    client = OpenAI(api_key=config['api_key'], base_url=config.get('base_url'))
    
    # Initialize session if needed
    if session_id not in sessions:
        sessions[session_id] = {'history': [], 'trained': False}
    
    session = sessions[session_id]
    messages = []

    # Training Phase (First time only)
    if not session['trained']:
        training_content = get_training_content(config.get('training_path', '.'))
        system_prompt = config.get('system_prompt', '')
        
        full_system_message = f"{system_prompt}\n\nCONTEXTO E EXEMPLOS:\n{training_content}"
        
        # Add system message to history
        session['history'].append({"role": "system", "content": full_system_message})
        session['trained'] = True
    
    # Add user code to history
    user_message = f"Analise o seguinte código frontend e gere a estória de usuário no padrão LogLab:\n\n```\n{code}\n```"
    session['history'].append({"role": "user", "content": user_message})
    
    try:
        response = client.chat.completions.create(
            model=config.get('model', 'gpt-4o'),
            messages=session['history']
        )
        
        ai_response = response.choices[0].message.content
        session['history'].append({"role": "assistant", "content": ai_response})
        
        return jsonify({"result": ai_response})
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/refine', methods=['POST'])
def refine():
    data = request.json
    selection = data.get('selection')
    instruction = data.get('instruction')
    session_id = data.get('session_id', 'default')
    
    config = load_config()
    client = OpenAI(api_key=config['api_key'], base_url=config.get('base_url'))
    
    if session_id not in sessions:
        return jsonify({"error": "Sessão não encontrada. Gere uma estória primeiro."}), 400
    
    session = sessions[session_id]
    
    refine_prompt = f"No texto anterior, foque APENAS neste trecho:\n'{selection}'\n\nInstrução de alteração: {instruction}\n\nRetorne o trecho reescrito (ou a estória ajustada se necessário)."
    session['history'].append({"role": "user", "content": refine_prompt})
    
    try:
        response = client.chat.completions.create(
            model=config.get('model', 'gpt-4o'),
            messages=session['history']
        )
        
        ai_response = response.choices[0].message.content
        session['history'].append({"role": "assistant", "content": ai_response})
        
        return jsonify({"result": ai_response})
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/save_file', methods=['POST'])
def save_file():
    data = request.json
    content = data.get('content')
    filename = data.get('filename', 'estoria.md')
    
    config = load_config()
    save_path = config.get('output_path', '.')
    
    if not os.path.exists(save_path):
        try:
            os.makedirs(save_path)
        except:
            return jsonify({"error": "Caminho de salvamento inválido."}), 400
            
    full_path = os.path.join(save_path, filename)
    
    try:
        with open(full_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return jsonify({"message": f"Arquivo salvo em {full_path}"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5001)
