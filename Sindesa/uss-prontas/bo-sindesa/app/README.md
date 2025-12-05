# Automação de Cadastro de Estórias - ServiceNow (Com Webview)

Este projeto automatiza o processo de cadastro de estórias de usuário no ServiceNow, lendo arquivos Markdown e preenchendo os formulários correspondentes.

A principal característica desta versão é a **Webview Integrada**, que permite visualizar o progresso da automação em tempo real diretamente na interface da aplicação, através de streaming de capturas de tela.

## Funcionalidades

- **Leitura de Estórias**: Processa arquivos `.md` da pasta `estorias`.
- **Automação Web**: Utiliza Selenium para interagir com o ServiceNow.
- **Webview em Tempo Real**: Exibe o que o robô está vendo na tela.
- **Logs Detalhados**: Acompanhamento passo a passo na interface.
- **Seleção de Módulo**: Suporte para módulos "ANIMAL" e "MIGRAÇÃO".

## Pré-requisitos

- Python 3.8 ou superior
- Google Chrome instalado

## Instalação

1. Navegue até a pasta da aplicação:
   ```bash
   cd Sindesa/uss-prontas/bo-sindesa/app
   ```

2. Crie e ative o ambiente virtual:
   ```bash
   python -m venv venv
   .\venv\Scripts\activate
   ```

3. Instale as dependências:
   ```bash
   pip install -r requirements.txt
   ```

## Como Usar

1. Execute a aplicação:
   ```bash
   python app.py
   ```

2. Abra o navegador e acesse:
   [http://127.0.0.1:5000](http://127.0.0.1:5000)

3. Preencha os dados:
   - **Nome de Usuário**: Seu usuário do ServiceNow.
   - **Senha**: Sua senha do ServiceNow.
   - **Módulo**: Selecione o módulo desejado.

4. Clique em **Iniciar Cadastro**.

5. Acompanhe o progresso na área de logs e veja a automação acontecendo na área de "Visualização em Tempo Real".

## Notas Técnicas

- O script utiliza o Selenium para controlar o navegador Chrome.
- A "Webview" é implementada via streaming de screenshots em base64 via Server-Sent Events (SSE), garantindo que você veja o estado atual da automação sem precisar alternar janelas.
- O navegador é aberto em tamanho 1920x1080 para garantir a visibilidade de todos os elementos.
