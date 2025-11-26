# US005 - Incluir Espécie

## DESCRIÇÃO

**Título da Tela:** Incluir Espécie
**Caminho de navegação (breadcrumb):** Principal > Pesquisa de Espécie > Incluir Espécie

**EU COMO** administrador do sistema INDEA
**QUERO** cadastrar novas espécies animais no sistema com suas configurações específicas
**PARA QUE** eu possa organizar e controlar adequadamente as diferentes categorias de animais no sistema de defesa agropecuária.

## PROTÓTIPO DE TELA

*[Inserir Protótipo da tela de inclusão de espécie]*

## 1. Critérios de Aceitação - Campos

#### i) Nome
- **Título**: Nome
- **Tipo do Campo**: Texto
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Tamanho Máximo**: 100 caracteres
- **Validações Extras**: Nome deve ser único no sistema

#### ii) Nome Científico
- **Título**: Nome Científico
- **Tipo do Campo**: Texto
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Tamanho Máximo**: 100 caracteres
- **Validações Extras**: Formato livre para nomenclatura científica

#### iii) Grupo Espécie
- **Título**: Grupo Espécie
- **Tipo do Campo**: Seleção Única (Autocomplete)
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Opções**: Lista de grupos de espécies cadastrados
- **Validações Extras**: Deve selecionar um grupo válido da lista

#### iv) Código PGA
- **Título**: Código PGA
- **Tipo do Campo**: Texto
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Tamanho Máximo**: 10 caracteres
- **Validações Extras**: Código único no sistema

#### v) Intervalo para nova Evolução (dias)
- **Título**: Intervalo para nova Evolução (dias)
- **Tipo do Campo**: Número Inteiro
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Valor Mínimo**: 0
- **Valor Máximo**: 999999999
- **Validações Extras**: Define o período mínimo entre evoluções para a espécie

#### vi) Controla Saldo
- **Título**: Controla Saldo
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Selecione, SIM, NÃO
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: Placeholder "Selecione"
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível com ícone de informação
- **Lista de Valores Permitidos**: SIM, NÃO
- **Tooltip**: Informações sobre controle de saldo
- **Validações Extras**: Define se a espécie terá controle de estoque/saldo

#### vii) Possui Marcas
- **Título**: Possui Marcas
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Selecione, SIM, NÃO
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: "NÃO" selecionado
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível com ícone de informação
- **Lista de Valores Permitidos**: SIM, NÃO
- **Tooltip**: Informações sobre sistema de marcação
- **Validações Extras**: Define se a espécie utiliza sistema de marcação individual

## 2. Critérios de Aceitação - Tabela de Faixa Etária

#### i) Estrutura da Tabela
- **Status inicial**: Vazia com mensagem "Sem registros"
- **Tipo**: Tabela de dados
- **Preenchimento**: Opcional (mas recomendado)
- **Visibilidade**: Sempre visível
- **Colunas**: Nome, Ordem Cronológica, Código PGA, Sexo, Idade Inicial, Idade Final, Faixa Etária Fixa, Ações
- **Botão "Adicionar"**: Ícone "+" para abrir modal de estratificação

#### ii) Botão "Adicionar Estratificação"
- **Status inicial**: Habilitado
- **Tipo**: Botão com ícone "+"
- **Preenchimento**: Texto não visível, apenas ícone
- **Visibilidade**: Sempre visível
- **Ação**: Abre modal "Incluir Estratificação"
- **Validações**: Modal específico para cadastro de faixas etárias

## 3. Critérios de Aceitação - Botões de Ação

#### i) Botão "Salvar"
- **Status inicial**: Habilitado
- **Tipo**: Botão
- **Preenchimento**: Texto "Salvar" com ícone de disquete
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Salva a espécie com todas as configurações
- **Destino da navegação**: Retorna para tela de pesquisa de espécies
- **Validações**: Executa TODAS as validações obrigatórias; Verifica unicidade do nome e código PGA; Valida consistência dos dados

#### ii) Botão "Limpar"
- **Status inicial**: Habilitado
- **Tipo**: Botão
- **Preenchimento**: Texto "Limpar" com ícone de borracha
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Link
- **Ação realizada**: Limpa todos os campos preenchidos
- **Destino da navegação**: Permanece na mesma tela
- **Validações**: Solicita confirmação antes de limpar

#### iii) Botão "Fechar"
- **Status inicial**: Habilitado
- **Tipo**: Botão
- **Preenchimento**: Texto "Fechar" com ícone "X"
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Link
- **Ação realizada**: Fecha a tela e retorna para pesquisa
- **Destino da navegação**: Tela de "Pesquisa de Espécie"
- **Validações**: Verifica se há dados não salvos

## 4. Regras / Validações / Ações

#### i) Validações de Campos Obrigatórios
- Todos os campos marcados com "*" são obrigatórios
- Nome, Grupo Espécie, Controla Saldo e Possui Marcas devem ser preenchidos
- Código PGA, Nome Científico e Intervalo para Evolução são opcionais

#### ii) Validações de Negócio
- Nome da espécie deve ser único no sistema
- Código PGA deve ser único se preenchido
- Grupo Espécie deve ser válido e existente no sistema
- Intervalo para Evolução deve ser um número inteiro não negativo

#### iii) Integração com Estratificações
- As faixas etárias cadastradas na tabela são específicas para a espécie
- A ordem cronológica das estratificações define a sequência de evolução
- As estratificações podem ser editadas/excluídas após o cadastro

## 5. Observações

- O sistema deve fornecer feedback visual durante o processamento do salvamento
- Mensagens de erro devem ser claras e específicas para cada validação
- A espécie salva deve estar imediatamente disponível para uso no sistema
- As configurações de "Controla Saldo" e "Possui Marcas" afetam o comportamento do sistema para a espécie
- O intervalo de evolução será utilizado para controlar a frequência de comunicações de evolução
- As estratificações são essenciais para o correto funcionamento do sistema de evolução de animais
## Tela: Incluir Espécie

### Breadcrumb
Principal > Pesquisa de Espécie > Incluir Espécie

### Campos Principais
- **Nome** (Texto, obrigatório, máx. 100, único)
- **Nome Científico** (Texto, opcional, máx. 100)
- **Grupo Espécie** (Seleção única/autocomplete, obrigatório, lista de grupos existentes)
- **Código PGA** (Texto, opcional, máx. 10, único se preenchido)
- **Intervalo para nova Evolução (dias)** (Número inteiro, opcional, min. 0, máx. 999999999)
- **Controla Saldo** (Dropdown, obrigatório, opções: SIM/NÃO, ícone info, tooltip)
- **Possui Marcas** (Dropdown, obrigatório, opções: SIM/NÃO, ícone info, tooltip, default NÃO)

### Tabela de Faixa Etária
- Inicialmente vazia, mensagem "Sem registros"
- Colunas: Nome, Ordem Cronológica, Código PGA, Sexo, Idade Inicial, Idade Final, Faixa Etária Fixa, Ações
- Botão "+" para adicionar estratificação (abre modal)

### Botões de Ação
- **Salvar**: Salva espécie, retorna à pesquisa, validações obrigatórias, unicidade, consistência
- **Limpar**: Limpa todos os campos, pede confirmação
- **Fechar**: Fecha tela, retorna à pesquisa, verifica dados não salvos

### Regras e Validações
- Campos obrigatórios: Nome, Grupo Espécie, Controla Saldo, Possui Marcas
- Código PGA e Nome Científico opcionais
- Nome e Código PGA devem ser únicos
- Grupo Espécie deve ser válido
- Intervalo para Evolução deve ser inteiro não negativo
- Faixas etárias específicas por espécie, ordem cronológica define evolução

### Observações
- Feedback visual durante salvamento
- Mensagens de erro claras e específicas
- Espécie salva disponível imediatamente
- Configurações de saldo/marcas afetam comportamento
- Intervalo de evolução controla frequência de comunicações
- Estratificações essenciais para evolução de animais
