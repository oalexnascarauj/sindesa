// Global State
let editor;
let sessionId = 'session_' + Math.random().toString(36).substr(2, 9);
let currentMarkdown = "";

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    // Init CodeMirror
    editor = CodeMirror.fromTextArea(document.getElementById('codeEditor'), {
        mode: 'htmlmixed',
        theme: 'dracula',
        lineNumbers: true,
        autoCloseTags: true,
        matchBrackets: true,
        lineWrapping: true
    });

    // Load Config
    loadConfig();

    // Setup Refine Popover
    setupRefinePopover();
});

function openSettings() {
    const modal = new bootstrap.Modal(document.getElementById('settingsModal'));
    modal.show();
}

async function loadConfig() {
    try {
        const res = await fetch('/api/config');
        const config = await res.json();
        
        document.getElementById('baseUrl').value = config.base_url || '';
        document.getElementById('apiKey').value = config.api_key || '';
        document.getElementById('modelName').value = config.model || '';
        document.getElementById('trainingPath').value = config.training_path || '';
        document.getElementById('outputPath').value = config.output_path || '';
        document.getElementById('systemPrompt').value = config.system_prompt || '';
    } catch (e) {
        console.error("Erro ao carregar config:", e);
    }
}

async function saveSettings() {
    const config = {
        base_url: document.getElementById('baseUrl').value,
        api_key: document.getElementById('apiKey').value,
        model: document.getElementById('modelName').value,
        training_path: document.getElementById('trainingPath').value,
        output_path: document.getElementById('outputPath').value,
        system_prompt: document.getElementById('systemPrompt').value
    };

    try {
        await fetch('/api/config', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(config)
        });
        
        const modal = bootstrap.Modal.getInstance(document.getElementById('settingsModal'));
        modal.hide();
        alert('Configurações salvas!');
    } catch (e) {
        alert('Erro ao salvar configurações.');
    }
}

async function generateStory() {
    const code = editor.getValue();
    if (!code.trim()) {
        alert("Por favor, insira algum código.");
        return;
    }

    // Show Loading
    document.getElementById('loadingOverlay').classList.remove('d-none');

    try {
        const res = await fetch('/api/generate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                code: code,
                session_id: sessionId
            })
        });

        const data = await res.json();
        
        if (data.error) {
            alert("Erro: " + data.error);
        } else {
            currentMarkdown = data.result;
            renderMarkdown(currentMarkdown);
        }
    } catch (e) {
        alert("Erro de conexão: " + e.message);
    } finally {
        document.getElementById('loadingOverlay').classList.add('d-none');
    }
}

function renderMarkdown(md) {
    const outputDiv = document.getElementById('markdownOutput');
    outputDiv.innerHTML = marked.parse(md);
}

async function saveFile() {
    if (!currentMarkdown) {
        alert("Nenhuma estória gerada para salvar.");
        return;
    }

    const filename = prompt("Nome do arquivo (ex: estoria.md):", "estoria.md");
    if (!filename) return;

    try {
        const res = await fetch('/api/save_file', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                content: currentMarkdown,
                filename: filename
            })
        });
        
        const data = await res.json();
        if (data.error) alert(data.error);
        else alert(data.message);
    } catch (e) {
        alert("Erro ao salvar: " + e.message);
    }
}

function copyToClipboard() {
    if (!currentMarkdown) return;
    navigator.clipboard.writeText(currentMarkdown).then(() => {
        alert("Copiado para a área de transferência!");
    });
}

// Refine Logic
function setupRefinePopover() {
    const outputDiv = document.getElementById('markdownOutput');
    const popover = document.getElementById('refinePopover');

    outputDiv.addEventListener('mouseup', (e) => {
        const selection = window.getSelection();
        if (selection.toString().trim().length > 0) {
            const rect = selection.getRangeAt(0).getBoundingClientRect();
            
            popover.style.display = 'block';
            popover.style.top = `${rect.bottom + window.scrollY + 10}px`;
            popover.style.left = `${rect.left + window.scrollX}px`;
            
            // Store selection for use
            popover.dataset.selection = selection.toString();
        } else {
            // Only hide if clicking outside popover
            if (!popover.contains(e.target)) {
                popover.style.display = 'none';
            }
        }
    });
}

async function submitRefinement() {
    const popover = document.getElementById('refinePopover');
    const selection = popover.dataset.selection;
    const instruction = document.getElementById('refineInput').value;

    if (!instruction) return;

    // Show Loading (maybe a smaller one or same one)
    document.getElementById('loadingOverlay').classList.remove('d-none');
    popover.style.display = 'none';

    try {
        const res = await fetch('/api/refine', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                selection: selection,
                instruction: instruction,
                session_id: sessionId
            })
        });

        const data = await res.json();
        
        if (data.error) {
            alert("Erro: " + data.error);
        } else {
            // Append or Replace? The prompt asks to "adjust just that part".
            // But usually LLMs return the whole thing or just the snippet.
            // My backend prompt asks for "Retorne o trecho reescrito".
            // So I should probably show it or ask user to replace.
            // For simplicity in this version, I'll append the refinement to the bottom 
            // OR replace if I can find the exact text.
            
            // Simple approach: Replace first occurrence of selection
            if (currentMarkdown.includes(selection)) {
                currentMarkdown = currentMarkdown.replace(selection, data.result);
                renderMarkdown(currentMarkdown);
                alert("Trecho atualizado!");
            } else {
                alert("Não foi possível encontrar o trecho original para substituição automática. O resultado foi copiado para o final.");
                currentMarkdown += "\n\n--- Refinamento ---\n" + data.result;
                renderMarkdown(currentMarkdown);
            }
        }
    } catch (e) {
        alert("Erro: " + e.message);
    } finally {
        document.getElementById('loadingOverlay').classList.add('d-none');
        document.getElementById('refineInput').value = '';
    }
}
