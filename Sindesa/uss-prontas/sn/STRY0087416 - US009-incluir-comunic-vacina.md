# US009 - Incluir Comunicação de Vacinação
#### STRY0087416

## DESCRIÇÃO

**Título da Tela:** Incluir Comunicação de Vacinação
**Caminho de navegação (breadcrumb):** Pesquisa de Comunicação de Vacinação > Incluir Comunicação de Vacinação

**EU COMO** produtor rural e/ou veterinário
**QUERO** registrar uma comunicação de vacinação para minhas explorações
**PARA QUE** eu possa cumprir com as obrigações sanitárias e manter o controle vacinal do meu rebanho atualizado perante os órgãos fiscalizadores.

## 1. Critérios de Aceitação - Campos

### i) Doença
- **Título**: Doença
- **Tipo do Campo**: Seleção Única (Autocomplete)
- **Opções**: Lista de doenças (tabela: doenças)
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validações Extras**: Ao selecionar doença, carrega automaticamente as campanhas disponíveis

### ii) Campanha
- **Título**: Campanha
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Lista de campanhas filtrada pela doença selecionada
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: Desabilitado com placeholder "SELECIONE"
- **Preenchimento do Campo**: Condicionado (obrigatório após seleção da doença)
- **Visibilidade**: Sempre visível
- **Validações Extras**: Habilitado apenas após seleção da doença; Deve filtrar apenas campanhas com situação "Ativa" e "Em Andamento"

### iii) Produtor
- **Título**: Produtor
- **Tipo do Campo**: Seleção Única (Autocomplete)
- **Opções**: Lista de produtores cadastrados
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validações Extras**: Ao selecionar produtor, carrega automaticamente as explorações disponíveis

### iv) Exploração
- **Título**: Exploração
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Lista de explorações filtrada pelo produtor selecionado
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: Desabilitado com placeholder "SELECIONE"
- **Preenchimento do Campo**: Condicionado (obrigatório após seleção do produtor)
- **Visibilidade**: Sempre visível
- **Validações Extras**: Habilitado apenas após seleção do produtor

## 2. Critérios de Aceitação - Ações

### i) Botão "Comunicar"
- **Status inicial**: Habilitado quando todos os campos obrigatórios estão preenchidos
- **Tipo**: Botão de ação
- **Preenchimento**: Ícone de documento + texto "Comunicar"
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Valida os dados e inicia o processo de comunicação de vacinação
- **Destino da navegação**: Wizard de comunicação com abas subsequentes
- **Validações**: Verifica se todos os campos obrigatórios estão preenchidos; Valida se existe comunicação já finalizada para a exploração (exibe modal de confirmação para comunicação complementar); Valida se a campanha selecionada está ativa

### ii) Botão "Fechar"
- **Status inicial**: Sempre habilitado
- **Tipo**: Botão de ação
- **Preenchimento**: Ícone de fechar + texto "Fechar"
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Link
- **Ação realizada**: Fecha a tela atual sem salvar
- **Destino da navegação**: Retorna para tela de Pesquisa de Comunicação de Vacinação
- **Validações**: Se houver dados não salvos, solicita confirmação do usuário
odutor" incluam comunicações de vacinação para campanhas com situação "Encerrada" ou "Inativa", 
## 3. Regras / Validações / Ações não relacionadas apenas a um campo

### i) Validação de Comunicação Existente
- Para usuários com perfil "Produtor" ou "Veterinário", o sistema deve bloquear a seleção de campanhas com situação "Encerrada" ou "Inativa"
- Ao selecionar uma doença, o dropdown de campanhas deve apresentar apenas campanhas com situação "Ativa" ou "Em Andamento"
- Se tentar comunicar para campanha encerrada/inativa, exibir mensagem: "Não é possível incluir comunicação para campanhas encerradas ou inativas"

## 4. Requisitos Considerados

**Perfil Produtor -** Bloquear inclusão de Comunicação de vacina para campanhas com situação Encerrada ou Inativa.
**Perfil Veterinário -** Bloquear inclusão de Comunicação de Estoque de vacinas para campanhas com situação Encerrada ou Inativa.