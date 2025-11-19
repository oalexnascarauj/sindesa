# US014 - Incluir Comunicação de Evolução/Transferência de Animais
#### STRY0087766

## DESCRIÇÃO

**Título da Tela:** Incluir Comunicação de Evolução/Transferência de Animais
**Caminho de navegação (breadcrumb):** Principal > Comunicação de Evolução/Transferência de Animais > Pesquisar > Incluir

**EU COMO** servidor do INDEA
**QUERO** incluir comunicações de evolução e transferência de animais entre diferentes faixas etárias e estruturas (núcleos, galpões, lotes)
**PARA QUE** eu possa registrar o crescimento e movimentação dos rebanhos, garantindo o controle sanitário e a rastreabilidade dos animais no sistema.

## PROTÓTIPO DE TELA

*[Inserir Protótipo da tela de inclusão de comunicação de evolução/transferência]*

## 1. Critérios de Aceitação - Campos Principais

### i) Identificador
- **Título**: Identificador
- **Tipo do Campo**: Texto
- **Estado Inicial**: Preenchido automaticamente (ex: "1439")
- **Preenchimento do Campo**: Apenas visualização
- **Visibilidade**: Sempre visível
- **Valor de Preenchimento Automático**: Gerado automaticamente pelo sistema

### ii) Data da Comunicação
- **Título**: Data da Comunicação
- **Tipo do Campo**: Data
- **Estado Inicial**: Data atual (ex: "19/11/2025")
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validação de Formato**: dd/mm/aaaa
- **Validações Extras**: Não pode ser data futura

### iii) Produtor
- **Título**: Produtor
- **Tipo do Campo**: Seleção Única (Autocomplete)
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Opções**: Lista de produtores cadastrados (formato: "CPF - NOME")
- **Validações Extras**: Ao selecionar produtor, carrega explorações disponíveis

### iv) Exploração
- **Título**: Exploração
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Estado Inicial**: Desabilitado até seleção do produtor
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Opções**: Lista de explorações do produtor selecionado (formato: "CÓDIGO - NOME - UF - MUNICÍPIO")
- **Validações Extras**: Ao selecionar exploração, carrega espécies disponíveis

### v) Espécie
- **Título**: Espécie
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Estado Inicial**: Desabilitado até seleção da exploração
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Opções**: Lista de espécies disponíveis na exploração (ex: BOVINO, EQUINO, SUÍNO)
- **Validações Extras**: Ao selecionar espécie, habilita tabela de evoluções/transferências

### vi) Incluído por
- **Título**: Incluído por
- **Tipo do Campo**: Texto
- **Estado Inicial**: Preenchido automaticamente com usuário logado
- **Preenchimento do Campo**: Apenas visualização
- **Visibilidade**: Sempre visível
- **Formato**: "CPF - NOME DO USUÁRIO"

### vii) Situação da Comunicação
- **Título**: Situação da Comunicação
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Estado Inicial**: "COMUNICADO"
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Opções**: COMUNICADO, EM ANÁLISE, APROVADO, REPROVADO, CANCELADO
- **Validações Extras**: Campo somente leitura; Sistema define automaticamente: "COMUNICADO" se todas carências cumpridas, "EM ANÁLISE" se alguma carência não cumprida após preencher questionário

## 2. Critérios de Aceitação - Tabela de Evoluções/Transferências

### i) Estrutura da Tabela
- **Status inicial**: Vazia com botão "Adicionar"
- **Tipo**: Tabela de dados
- **Preenchimento**: Obrigatório pelo menos um item
- **Visibilidade**: Habilitada após seleção da espécie
- **Colunas**: Faixa Etária Anterior, Saldo Anterior, Faixa Etária Nova, Tipo de Movimento, Quantidade, Novo Saldo Origem, Novo Saldo Destino, Ações

### ii) Botão "Adicionar"
- **Status inicial**: Habilitado após seleção da espécie
- **Tipo**: Botão com ícone "+"
- **Preenchimento**: Texto não visível, apenas ícone
- **Visibilidade**: Sempre visível quando habilitado
- **Ação**: Abre modal específico conforme a espécie selecionada
- **Validações**: Modal diferente para BOVINOS, SUÍNOS e AVES

## 3. Critérios de Aceitação - Modal de Inclusão de Item (Bovinos)

### i) Fieldset "Origem"
- **Faixa Etária**: Seleção obrigatória via autocomplete
- **Saldo Normal Origem**: Campo numérico somente leitura
- **Saldo Parcial Origem**: Campo numérico somente leitura
- **Saldo Temporário Origem**: Campo numérico somente leitura

### ii) Fieldset "Evolução"
- **Faixa Etária**: Seleção obrigatória via autocomplete
- **Tipo de Movimento**: Dropdown (EVOLUÇÃO/TRANSFERÊNCIA) - default EVOLUÇÃO
- **Tipo de Saldo**: Dropdown (NORMAL/PARCIAL/TEMPORÁRIO) - default NORMAL
- **Saldo Normal Destino**: Campo numérico somente leitura
- **Quantidade**: Campo numérico editável
- **Novo Saldo Origem**: Campo numérico calculado automaticamente
- **Novo Saldo Destino**: Campo numérico calculado automaticamente

## 4. Critérios de Aceitação - Botões de Ação

### i) Botão "Salvar"
- **Status inicial**: Habilitado
- **Tipo**: Botão
- **Preenchimento**: Texto "Salvar" com ícone de disquete (fa fa-save)
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Valida os 3 prazos de carência; Se cumpridos, salva com situação "COMUNICADO"; Se não cumpridos, exibe questionário justificativo e após preenchimento salva com situação "EM ANÁLISE"
- **Validações**: Executa TODAS as validações obrigatórias; Verifica se há pelo menos um item na tabela; Valida cálculos de saldos; **Valida 3 prazos de carência: (1) Carência após emissão de GTA, (2) Carência após comunicação de nascimento da faixa etária, (3) Carência entre evoluções consecutivas**

### ii) Botão "Limpar"
- **Status inicial**: Habilitado
- **Tipo**: Botão
- **Preenchimento**: Texto "Limpar" com ícone de borracha (fa fa-eraser)
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Link
- **Ação realizada**: Limpa todos os campos preenchidos
- **Validações**: Solicita confirmação antes de limpar

### iii) Botão "Fechar"
- **Status inicial**: Habilitado
- **Tipo**: Botão
- **Preenchimento**: Texto "Fechar" com ícone X (fa fa-times)
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Link
- **Ação realizada**: Fecha a tela e retorna para pesquisa
- **Validações**: Verifica se há dados não salvos

## 5. Critérios de Aceitação - Ações na Tabela

### i) Botão "Visualizar"
- **Ícone**: Arquivo de texto (fa fa-file-text)
- **Tooltip**: "Visualizar Item"
- **Visibilidade**: Sempre visível para todos os itens
- **Ação**: Abre modal de visualização do item em modo leitura

### ii) Botão "Excluir"
- **Ícone**: Lixeira (fa fa-trash)
- **Tooltip**: "Excluir Item"
- **Visibilidade**: Sempre visível para todos os itens
- **Ação**: Remove o item da tabela
- **Validações**: Solicita confirmação "Deseja realmente excluir o Item de Evolução?"

## 6. Regras / Validações / Ações

### i) Validações de Campos Obrigatórios
- Todos os campos marcados com "*" são obrigatórios
- Produtor, Exploração e Espécie devem ser selecionados sequencialmente
- Pelo menos um item deve ser adicionado na tabela antes de salvar

### ii) Cálculos Automáticos
- "Novo Saldo Origem" = "Saldo Anterior" - "Quantidade"
- "Novo Saldo Destino" = "Saldo Atual Destino" + "Quantidade"
- Quantidade não pode ser maior que Saldo Anterior
- Quantidade deve ser maior que zero

### iii) Fluxo Dependente
- Exploração só é habilitada após seleção do produtor
- Espécie só é habilitada após seleção da exploração
- Tabela de itens só é habilitada após seleção da espécie
- Modal de inclusão varia conforme a espécie selecionada

## 7. Observações

- A comunicação deve registrar automaticamente o usuário que realizou a inclusão
- Os saldos são calculados automaticamente com base no estoque atual do sistema
- Para transferências, é necessário selecionar exploração de destino
- O sistema deve validar a consistência dos saldos em tempo real
- Deve haver feedback visual durante o processamento dos cálculos
- **Validação de Carências**: O sistema valida 3 prazos de carência: (1) após emissão de GTA, (2) após comunicação de nascimento, (3) entre evoluções consecutivas. Se QUALQUER carência não for cumprida, exige questionário justificativo e a situação passa para "EM ANÁLISE"

## 8. Requisitos Considerados

### i) Regras de Carência para Evolução

**MÓDULO ANIMAL** - Na funcionalidade evolução, inserir as regras de carência para evolução. Quando um usuário insere uma evolução que não cumpriu o prazo de carência, então deve ser apresentado ao usuário um questionário para justificar a evolução feita. Após salvar o questionário o botão SALVAR é habilitado para o usuário. Ao salvar, a situação da evolução passa a ser EM ANÁLISE.

**Detalhamento dos 3 Prazos de Carência:**

1. **Carência após emissão de GTA**: Prazo mínimo após emissão de Guia de Trânsito Animal envolvendo a faixa etária de origem
2. **Carência após comunicação de nascimento**: Prazo mínimo após informar nascimento daquela faixa etária específica
3. **Carência entre evoluções consecutivas**: Prazo mínimo após ter feito uma evolução para mesma faixa etária recentemente

### ii) Análise de Evolução

**MÓDULO ANIMAL** - na funcionalidade "listagem de evolução", criar um botão de ação denominado de ANALISAR EVOLUÇÃO. Ao acessar esse botão o usuário irá ver a comunicação de evolução e o questionário. Cabe ao usuário APROVAR ou RECUSAR a evolução. No caso de recusa, apresentar o campo MOTIVO DA RECUSA, com 1000 caracteres. O BOTÃO ANALISAR COMUNICAÇÃO É HABILITADO QUANDO A SITUAÇÃO DA COMUNICAÇÃO FOR EM ANÁLISE.

**Especificações do Botão:**
- **Ícone**: fa fa-check-circle
- **Tooltip**: "Analisar Comunicação de Evolução"
- **Visibilidade**: Apenas para situação "EM ANÁLISE"
- **Perfil**: Servidor INDEA com permissão de análise

**Ações na Tela de Análise:**
- **Botão "Aprovar"** (fa fa-check): Altera situação para "APROVADO", registra usuário e data/hora, atualiza saldos
- **Botão "Recusar"** (fa fa-times-circle): Exibe campo "Motivo da Recusa" (obrigatório, 1000 caracteres), altera situação para "REPROVADO", NÃO atualiza saldos

### iii) Visualização de Análise

**MÓDULO ANIMAL** - Na funcionalidade evolução, o botão visualizar deve apresentar na tela o usuário que aprovou ou recusou a comunicação. Para o caso de recusa, apresentar o motivo. Para isso apresentar, se APROVADO, os campos: Data da Aprovação e Usuário da aprovação. Se RECUSADO, data da recusa, usuário da recusa e motivo da recusa.

**Campos Adicionais na Visualização:**

**Se situação = APROVADO:**
- Data da Aprovação (timestamp formato dd/mm/aaaa HH:mm:ss)
- Aprovado por (formato: CPF - NOME DO USUÁRIO)

**Se situação = REPROVADO:**
- Data da Recusa (timestamp formato dd/mm/aaaa HH:mm:ss)
- Recusado por (formato: CPF - NOME DO USUÁRIO)
- Motivo da Recusa (área de texto somente leitura, até 1000 caracteres)