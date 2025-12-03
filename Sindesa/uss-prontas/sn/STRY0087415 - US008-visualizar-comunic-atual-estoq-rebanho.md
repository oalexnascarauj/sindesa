# US008 - Visualizar Comunicação de Atualização de Estoque de Rebanho
#### STRY0087415 ok - Baixa prioridade 

## DESCRIÇÃO

**EU COMO** usuário do sistema (produtor rural ou servidor do INDEA)
**QUERO** visualizar os detalhes completos de uma comunicação de atualização de estoque de rebanho existente
**PARA QUE** eu possa consultar todas as informações cadastradas, acompanhar o status da comunicação e verificar eventuais recusas

## PROTÓTIPO DE TELA

![Protótipo - US008 Visualizar Comunicação de Atualização de Estoque de Rebanho](US008-visualizar-comunic-atual-estoq-rebanho.png)

*Figura 1: Tela de visualização de comunicação de atualização de estoque de rebanho com dados do produtor, exploração, estoques atual e após comunicação*

## 1. Critérios de Aceitação - Campos Principais

### i) Identificador da Comunicação
- **Tipo do Campo**: Numérico (somente leitura)
- **Estado Inicial**: Carregado com o ID único da comunicação
- **Preenchimento do Campo**: Apenas visualização
- **Exemplo**: 489

### ii) Campanha de Atualização
- **Tipo do Campo**: Seleção Única (Dropdown - somente leitura)
- **Estado Inicial**: Carregado com a campanha selecionada
- **Preenchimento do Campo**: Apenas visualização
- **Exemplo**: "ATUALIZAÇÃO DE ESTOQUE - NOV 2025"

### iii) Produtor Responsável
- **Tipo do Campo**: Autocomplete (somente leitura)
- **Formato de Exibição**: CPF/CNPJ - Nome Completo
- **Preenchimento do Campo**: Apenas visualização
- **Exemplo**: "966.460.551-49 - RICARDO DA SILVA GONÇALVES"

### iv) Exploração Pecuária
- **Tipo do Campo**: Seleção Única (Dropdown - somente leitura)
- **Formato de Exibição**: Código - Nome - Estado - Município
- **Preenchimento do Campo**: Apenas visualização
- **Exemplo**: "510000000810003 - SITIO IPIRANGA - MT - CUIABÁ"

### v) Quantidade de Matrizes
- **Tipo do Campo**: Numérico (somente leitura)
- **Preenchimento do Campo**: Apenas visualização
- **Informação Adicional**: Ícone de informação (tooltip) disponível para detalhes

### vi) Data da Comunicação
- **Tipo do Campo**: Data (somente leitura)
- **Preenchimento do Campo**: Apenas visualização

### vii) Usuário de Digitação
- **Tipo do Campo**: Texto (somente leitura)
- **Preenchimento do Campo**: Apenas visualização

### viii) Situação da Comunicação
- **Tipo do Campo**: Seleção Única (Dropdown - somente leitura)
- **Valores Permitidos**: PENDENTE, ENVIADO, RECUSADO, FINALIZADO, CANCELADO
- **Preenchimento do Campo**: Apenas visualização
- **Estado Atual**: PENDENTE

## 2. Critérios de Aceitação - Seções de Estoque

### i) Accordion "Estoque Atual"
- **Estado Inicial**: Expandido por padrão
- **Conteúdo**: Tabela com colunas (Espécie, Faixa Etária, Quantidade)
- **Comportamento**: Exibe o estoque registrado antes da comunicação
- **Mensagem de Estado Vazio**: "Não Possui Estoque" quando não há dados

### ii) Accordion "Estoque Após a Comunicação"
- **Estado Inicial**: Expandido por padrão
- **Conteúdo**: Tabela com colunas (Espécie, Faixa Etária, Saldo)
- **Comportamento**: Exibe o estoque projetado após a comunicação
- **Mensagem de Estado Vazio**: "Não Possui Estoque" quando não há dados

## 3. Critérios de Aceitação - Motivo da Recusa

### i) Exibição do Motivo da Recusa
- **Condição de Exibição**: Quando a situação da comunicação for "RECUSADO"
- **Perfis com Acesso**: Produtor e Veterinário
- **Localização**: Seção destacada na tela de visualização
- **Conteúdo**: Texto completo do motivo informado no momento da recusa
- **Formato**: Campo de texto longo (readonly)
- **Visibilidade**: Condicional baseada na situação e perfil do usuário

## 4. Critérios de Aceitação - Botões

### i) Botão "Fechar"
- **Tipo**: Botão de ação
- **Preenchimento**: Texto "Fechar" com ícone (fa-close)
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Link
- **Ação realizada**: Fecha a tela atual e retorna para a tela anterior
- **Destino da navegação**: Tela de pesquisa de comunicações
- **Validações**: Não solicita confirmação

## 5. Regras / Validações / Ações não relacionadas apenas a um campo

- **Modo Somente Leitura**: Todos os campos devem estar em estado readonly
- **Carregamento de Dados**: Os dados devem ser carregados automaticamente baseados no ID da comunicação (489)
- **Controle de Acesso**: Diferentes perfis de usuário têm a mesma visibilidade na tela de visualização
- **Workflow de Situação**: A situação determina quais informações adicionais são exibidas
- **Histórico de Alterações**: O sistema deve manter o histórico completo das alterações na comunicação

## 6. Requisitos Específicos

### Exibição do Motivo da Recusa para Perfis Produtor e Veterinário
- **Descrição**: Inserir no visualizar Comunicação de Atualização de Estoque de Rebanho os dados do Motivo da Recusa, quando a situação da comunicação for RECUSADO
- **Condição de Aplicação**: 
  - Situação da comunicação = "RECUSADO"
  - Perfil do usuário = "Produtor" OU "Veterinário"
- **Comportamento Esperado**:
  - Exibir seção "Motivo da Recusa" com o texto completo
  - Manter formato readonly para garantir integridade dos dados
  - Posicionar a seção de forma destacada na tela
- **Validações**: 
  - Verificar situação da comunicação antes de exibir o motivo
  - Validar perfil do usuário logado
  - Garantir que apenas os motivos recusados sejam exibidos

## 7. Observações

- A tela opera exclusivamente em modo de visualização, sem opções de edição
- Os accordions de estoque permitem comparar visualmente a situação antes e depois da comunicação
- O sistema deve garantir a consistência dos dados exibidos com o registro original
- A exibição do motivo da recusa é fundamental para transparência do processo