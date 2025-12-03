# US015 - Incluir Espécie - Carência para comunicação de Nascimento e Evolução
#### STRY0087925 ok

## DESCRIÇÃO

**Título da Tela:** Incluir Espécie
**Caminho de navegação (breadcrumb):** Principal > Pesquisa de Espécie > Incluir Espécie

**EU COMO** servidor fiscal do sistema INDEA
**QUERO** cadastrar novas espécies animais no sistema com suas configurações específicas
**PARA QUE** eu possa organizar e controlar adequadamente as diferentes categorias de animais no sistema de defesa agropecuária.

## PROTÓTIPO DE TELA

![Protótipo da tela de inclusão de espécie](US015-param-carencia-comunic-nasc.png)

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
- **Colunas**: Nome, Ordem Cronológica, Código PGA, Sexo, Idade Inicial, Idade Final, Faixa Etária Fixa, Carência Comunicação Nascimento, Carência Entrada GTA Nasc., Carência Comunicação Evolução, Carência Entrada GTA Evolução, Ações
- **Botão "Adicionar"**: Ícone "+" para abrir modal de estratificação

#### ii) Botão "Adicionar Estratificação"
- **Status inicial**: Habilitado
- **Tipo**: Botão com ícone "+"
- **Preenchimento**: Apenas ícone, sem texto visível
- **Visibilidade**: Sempre visível
- **Ação**: Ao clicar, abre um modal específico para cadastro de Estratificação (faixa etária)
- **Validações**: Todas as validações relacionadas ao cadastro de faixas etárias são realizadas dentro do modal

## 3. Modal de estratificação (faixa etária)

## 3.1. Critérios de Aceitação - Campos

### i) Nome
- **Título**: Nome
- **Tipo do Campo**: Texto
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Tamanho Máximo**: 60 caracteres
- **Validações Extras**: Nome deve ser único no sistema; Não pode conter caracteres especiais

### ii) Código PGA
- **Título**: Código PGA
- **Tipo do Campo**: Texto
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Tamanho Máximo**: 10 caracteres
- **Validações Extras**: Formato alfanumérico; Código único no sistema

### iii) Sexo
- **Título**: Sexo
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Selecione, AMBOS, FÊMEA, MACHO
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: Placeholder "Selecione"
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Lista de Valores Permitidos**: AMBOS, FÊMEA, MACHO
- **Validações Extras**: Deve ser diferente da opção "Selecione"

### iv) Idade Inicial
- **Título**: Idade Inicial
- **Tipo do Campo**: Número Inteiro
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Valor Mínimo**: 0
- **Valor Máximo**: 999999999
- **Validações Extras**: Deve ser menor ou igual à Idade Final; Não pode ser negativo

### v) Idade Final
- **Título**: Idade Final
- **Tipo do Campo**: Número Inteiro
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Valor Mínimo**: 0
- **Valor Máximo**: 999999999
- **Valor Mínimo Condicional**: Deve ser maior ou igual à Idade Inicial
- **Validações Extras**: Não pode ser negativo; Se Idade Inicial for 0 e Idade Final for 0, considerar como "até"

### vi) Ordem Cronológica
- **Título**: Ordem Cronológica
- **Tipo do Campo**: Número Inteiro
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Valor Mínimo**: 1
- **Valor Máximo**: 999999999
- **Validações Extras**: Ordem deve ser única por espécie; Define a sequência de evolução das faixas etárias

### vii) Faixa Etária Fixa
- **Título**: Faixa Etária Fixa
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Selecione, SIM, NÃO
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: "NÃO" selecionado
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível com ícone de informação
- **Lista de Valores Permitidos**: SIM, NÃO
- **Tooltip**: Informações adicionais sobre faixa etária fixa
- **Validações Extras**: Se "SIM", a faixa etária não pode ser alterada posteriormente
  
### viii) Carência Comunicação Nascimento
- **Título**: Carência Comunicação Nascimento
- **Tipo do Campo**: Número Inteiro
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Valor Mínimo**: 0
- **Valor Máximo**: 999999999
- **Validações Extras**: Define o período de carência para comunicação de nascimento

### ix) Carência Entrada GTA Nasc.
- **Título**: Carência Entrada GTA Nasc.
- **Tipo do Campo**: Número Inteiro
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Valor Mínimo**: 0
- **Valor Máximo**: 999999999
- **Validações Extras**: Define o período de carência para entrada de GTA relacionada ao nascimento

### x) Carência Comunicação Evolução
- **Título**: Carência Comunicação Evolução
- **Tipo do Campo**: Número Inteiro
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Valor Mínimo**: 0
- **Valor Máximo**: 999999999
- **Validações Extras**: Define o período de carência para comunicação de evolução

### xi) Carência Entrada GTA Evolução
- **Título**: Carência Entrada GTA Evolução
- **Tipo do Campo**: Número Inteiro
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Valor Mínimo**: 0
- **Valor Máximo**: 999999999
- **Validações Extras**: Define o período de carência para entrada de GTA relacionada à evolução

## 4. Critérios de Aceitação - Botões de Ação

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

#### iv) Requisitos
- Criar período de carência parametrizado para evolução contado a partir da entrada de uma GTA e entre evoluções
- Criar período de carência parametrizado para nascimento contado a partir da entrada de uma GTA e entre comunicações de nascimento.