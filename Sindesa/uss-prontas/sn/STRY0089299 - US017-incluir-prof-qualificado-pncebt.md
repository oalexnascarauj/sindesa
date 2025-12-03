# US017 - Incluir Profissional Qualificado no PNCEBT/MT
#### STRY0089299

## DESCRIÇÃO

**Título da Tela:** Cadastramento de Médico Veterinário Autônomo do Programa PNCEBT/MT  
**Caminho de navegação (breadcrumb):** Pesquisa de Profissional Qualificado > Incluir Profissional Qualificado > Cadastramento de Médico Veterinário Autônomo do Programa PNCEBT/MT

**EU COMO** servidor técnico do INDEA responsável pelo cadastro de profissionais qualificados  
**QUERO** cadastrar um médico veterinário autônomo no Programa Estadual de Erradicação e Controle da Brucelose e Tuberculose (PNCEBT/MT), incluindo suas qualificações, áreas de atuação, vacinadores vinculados e espécies atendidas  
**PARA QUE** eu possa manter um registro atualizado e válido de profissionais autorizados a atuar no programa, garantindo o controle sanitário e a rastreabilidade das ações de saúde animal no estado.

## PROTÓTIPO DE TELA

![Protótipo - US017 Incluir Profissional Qualificado PNCEBT](US017-incluir-prof-qualificado-pncebt.png)

*Figura 1: Tela de cadastramento de médico veterinário autônomo no PNCEBT/MT com campos principais, tabelas de vinculação e ações de gestão*

## 1. Critérios de Aceitação - Campos

#### i) Profissional

- **Título**: Profissional
- **Tipo do Campo**: Texto (somente leitura)
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório, preenchido automaticamente após seleção do profissional (outra tela/fluxo)
- **Visibilidade**: Sempre visível
- **Validações Extras**: Deve referenciar um médico veterinário cadastrado no sistema com registro ativo no CRMV-MT

#### ii) Programa

- **Título**: Programa
- **Tipo do Campo**: Texto (somente leitura)
- **Estado Inicial**: “PROGRAMA ESTADUAL DE ERRADICAÇÃO E CONTROLE DA BRUCELOSE E TUBERCULOSE”
- **Preenchimento do Campo**: Obrigatório, preenchido automaticamente
- **Visibilidade**: Sempre visível
- **Valor Fixo**: Não editável, definido pelo contexto da tela

#### iii) Qualificação

- **Título**: Qualificação
- **Tipo do Campo**: Texto (somente leitura)
- **Estado Inicial**: “CADASTRO DE MÉDICO VETERINÁRIO AUTÔNOMO NO PECEBT”
- **Preenchimento do Campo**: Obrigatório, preenchido automaticamente
- **Visibilidade**: Sempre visível
- **Valor Fixo**: Não editável, definido pelo contexto da tela

#### iv) Curso para Qualificação em Programa de Saúde Animal

- **Título**: Curso para Qualificação em Programa de Saúde Animal
- **Tipo do Campo**: Seleção Única (Dropdown com busca)
- **Opções**: Lista de cursos cadastrados no sistema (tabela: cursos_qualificacao)
- **Seleção**: Opcional
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Validações Extras**: Curso deve estar ativo e vinculado ao PNCEBT/MT

#### v) Data de Obtenção do Certificado

- **Título**: Data de Obtenção do Certificado
- **Tipo do Campo**: Data
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Valor Máximo**: Data atual (não pode ser futura)
- **Validação de Formato**: dd/mm/aaaa
- **Validações Extras**: Se preenchida, deve ser posterior à data de criação do curso selecionado

#### vi) Data de Solicitação

- **Título**: Data de Solicitação
- **Tipo do Campo**: Data
- **Estado Inicial**: Data atual (preenchida automaticamente)
- **Preenchimento do Campo**: Opcional, preenchida automaticamente
- **Visibilidade**: Sempre visível
- **Valor de Preenchimento Automático**: Data do dia
- **Validação de Formato**: dd/mm/aaaa

#### vii) Nº da Portaria

- **Título**: Nº da Portaria
- **Tipo do Campo**: Número Inteiro
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Valor Mínimo**: 1
- **Valor Máximo**: 999999999
- **Validações Extras**: Deve ser único por ano; formato numérico sem pontos ou traços

#### viii) Data da Portaria

- **Título**: Data da Portaria
- **Tipo do Campo**: Data
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Validação de Formato**: dd/mm/aaaa
- **Validações Extras**: Se preenchida, não pode ser futura; deve ser igual ou posterior à data de solicitação

#### ix) Nº da Portaria de Descredenciamento

- **Título**: Nº da Portaria de Descredenciamento
- **Tipo do Campo**: Texto
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Tamanho Máximo**: 10 caracteres
- **Validações Extras**: Habilitado apenas se situação for “INATIVO”

#### x) Data do Descredenciamento

- **Título**: Data do Descredenciamento
- **Tipo do Campo**: Data
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Validação de Formato**: dd/mm/aaaa
- **Validações Extras**: Habilitado apenas se situação for “INATIVO”; deve ser igual ou posterior à data da portaria de credenciamento

#### xi) Situação

- **Título**: Situação
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: ATIVO, INATIVO
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: “ATIVO” selecionado
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Lista de Valores Permitidos**: ATIVO, INATIVO
- **Validações Extras**: Alteração para “INATIVO” exige preenchimento dos campos de descredenciamento

## 2. Critérios de Aceitação – Seção "Anexos ( )"

### i) Tabela de Dados

- **Status inicial:** Tabela vazia com título “Anexos (0)” e botão de anexar (ícone de clipe)
- **Tipo:** tabela de dados
- **Preenchimento:** opcional
- **Visibilidade:** sempre visível

#### Botão "Anexar"

- **Status inicial:** habilitado
- **Tipo:** botão com ícone de clipe
- **Visibilidade:** sempre visível
- **Regra de negócio:** ao clicar, redireciona para tela “Manter Anexos” (outra estória)
- **Classificação da Ação:** Ação Apenas em Tela
- **Ação realizada:** Abre tela de gerenciamento de anexos
- **Destino da navegação:** Tela de “Manter Anexos”
- **Validações:** Permite upload de documentos comprobatórios (certificado, portaria, etc.)

## 3. Critérios de Aceitação – Seção "Município de Atuação"

### i) Tabela de Dados

- **Status inicial:** Tabela vazia com título “Município de Atuação” e botão “+” no cabeçalho
- **Tipo:** tabela de dados
- **Preenchimento:** obrigatório (pelo menos um município)
- **Visibilidade:** sempre visível
- **Colunas:** Município, Situação, Ações

#### Botão "Adicionar Município"

- **Status inicial:** habilitado
- **Tipo:** botão com ícone “+”
- **Visibilidade:** sempre visível
- **Regra de negócio:** abre modal “Município” para seleção
- **Classificação da Ação:** Ação Apenas em Tela
- **Ação realizada:** Abre modal de cadastro de município de atuação
- **Destino da navegação:** Modal “Município”
- **Validações:** Município deve ser válido em MT e não pode estar duplicado na tabela

#### Detalhamento das Colunas

##### 1) Município

- **Status inicial:** preenchido com nome do município selecionado
- **Tipo:** coluna de tabela (somente leitura)
- **Preenchimento:** obrigatório
- **Visibilidade:** sempre visível

##### 2) Situação

- **Status inicial:** “ATIVO”
- **Tipo:** coluna de tabela (somente leitura)
- **Preenchimento:** obrigatório
- **Visibilidade:** sempre visível

##### 3) Ações

- **Botões:** Editar, Excluir
- **Editar:** abre modal para alterar município/situação
- **Excluir:** remove o município da lista (com confirmação)

## 4. Critérios de Aceitação – Seção "Vacinador"

### i) Tabela de Dados

- **Status inicial:** Tabela vazia com título “Vacinador” e botão “+” no cabeçalho
- **Tipo:** tabela de dados
- **Preenchimento:** opcional
- **Visibilidade:** sempre visível
- **Colunas:** Nome, CPF, Situação, Ações

#### Botão "Adicionar Vacinador"

- **Status inicial:** habilitado
- **Tipo:** botão com ícone “+”
- **Visibilidade:** sempre visível
- **Regra de negócio:** abre modal “Vacinador” para cadastro
- **Classificação da Ação:** Ação Apenas em Tela
- **Ação realizada:** Abre modal de cadastro de vacinador vinculado
- **Destino da navegação:** Modal “Vacinador”
- **Validações:** Vacinador deve ter CPF válido e não estar vinculado a outro profissional no mesmo período
- **Regra de negócio:** Qualquer servidor de poder incluir um vacinador na tabela de vacinadores

#### Detalhamento das Colunas

##### 1) Nome

- **Status inicial:** preenchido com nome do vacinador
- **Tipo:** coluna de tabela (somente leitura)
- **Preenchimento:** obrigatório
- **Visibilidade:** sempre visível

##### 2) CPF

- **Status inicial:** preenchido com CPF do vacinador
- **Tipo:** coluna de tabela (somente leitura)
- **Preenchimento:** obrigatório
- **Visibilidade:** sempre visível
- **Validação de Formato:** 000.000.000-00

##### 3) Situação

- **Status inicial:** “ATIVO”
- **Tipo:** coluna de tabela (somente leitura)
- **Preenchimento:** obrigatório
- **Visibilidade:** sempre visível

##### 4) Ações

- **Botões:** Editar, Excluir
- **Editar:** abre modal para alterar dados do vacinador
- **Excluir:** remove o vacinador da lista (com confirmação)

## 5. Critérios de Aceitação – Seção "Espécie"

### i) Tabela de Dados

- **Status inicial:** Tabela vazia com título “Espécie” e botão “+” no cabeçalho
- **Tipo:** tabela de dados
- **Preenchimento:** obrigatório (pelo menos uma espécie)
- **Visibilidade:** sempre visível
- **Colunas:** Código, Espécie, Grupo Espécie, Ações

#### Botão "Adicionar Espécie"

- **Status inicial:** habilitado
- **Tipo:** botão com ícone “+”
- **Visibilidade:** sempre visível
- **Regra de negócio:** abre modal “Espécie” para seleção
- **Classificação da Ação:** Ação Apenas em Tela
- **Ação realizada:** Abre modal de seleção de espécie atendida
- **Destino da navegação:** Modal “Espécie”
- **Validações:** Espécie deve estar cadastrada e ativa no sistema; não pode ser duplicada na tabela

#### Detalhamento das Colunas

##### 1) Código

- **Status inicial:** preenchido com código da espécie
- **Tipo:** coluna de tabela (somente leitura)
- **Preenchimento:** obrigatório
- **Visibilidade:** sempre visível

##### 2) Espécie

- **Status inicial:** preenchido com nome da espécie
- **Tipo:** coluna de tabela (somente leitura)
- **Preenchimento:** obrigatório
- **Visibilidade:** sempre visível

##### 3) Grupo Espécie

- **Status inicial:** preenchido com grupo da espécie
- **Tipo:** coluna de tabela (somente leitura)
- **Preenchimento:** obrigatório
- **Visibilidade:** sempre visível

##### 4) Ações

- **Botões:** Excluir
- **Excluir:** remove a espécie da lista (com confirmação)

## 6. Critérios de Aceitação – Ações

### i) Botão "Adicionar"

- **Status inicial:** habilitado
- **Tipo:** botão com ícone de disquete e texto “Adicionar”
- **Visibilidade:** sempre visível
- **Funcionalidade:** Salva o cadastro do profissional qualificado
- **Classificação da Ação:** Ações Práticas
- **Ação realizada:** Valida e persiste todos os dados do formulário
- **Destino da navegação:** Retorna para tela de pesquisa de profissional qualificado

### ii) Botão "Fechar"

- **Status inicial:** habilitado
- **Tipo:** botão com ícone de “X” e texto “Fechar”
- **Visibilidade:** sempre visível
- **Funcionalidade:** Fecha a tela sem salvar
- **Classificação da Ação:** Link
- **Ação realizada:** Fecha a tela de cadastro
- **Destino da navegação:** Tela de “Pesquisa de Profissional Qualificado”
- **Validações:** Se houver alterações não salvas, exibe modal de confirmação “Deseja sair sem salvar?”

## 7. Requisitos Considerados
- Permitir que **qualquer servidor** possa visualizar a qualificação profissional CADASTRAMENTO DE VETERINÁRIO NO PNCEBT e incluir dados na GRID VACINADOR.