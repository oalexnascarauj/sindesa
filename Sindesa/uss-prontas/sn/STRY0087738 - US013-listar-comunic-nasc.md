# US013 - Listar Comunicação de Nascimentos
#### STRY0087738

## DESCRIÇÃO

**Título da Tela:** Filtro de Pesquisa de Comunicação de Nascimentos
**Caminho de navegação (breadcrumb):** Pesquisa de Comunicação de Nascimentos

**EU COMO** usuário do sistema
**QUERO** pesquisar e visualizar comunicações de nascimentos registradas no sistema utilizando diversos critérios de filtro
**PARA QUE** eu possa consultar, gerenciar e controlar as comunicações de nascimentos de animais, permitindo visualizar, cancelar e imprimir as comunicações conforme necessário, além de monitorar o status e histórico das comunicações realizadas.

## PROTÓTIPO DE TELA

![Protótipo - US013 Listar Comunicação de Nascimentos](US013-listar-comunic-nasc.png)

*Figura 1: Protótipo da tela de listagem de comunicações de nascimentos com filtros dinâmicos, resultados paginados e ações por registro (visualizar, analisar, cancelar, imprimir) conforme situação da comunicação.*

## 1. Critérios de Aceitação - Seção "Filtro de Pesquisa de Comunicação de Nascimentos"

### i) Painel de Filtros (Fieldset Expansível)

- **Título**: Filtro de Pesquisa de Comunicação de Nascimentos
- **Tipo do Campo**: Fieldset expansível/colapsável
- **Estado Inicial**: Expandido
- **Visibilidade**: Sempre visível
- **Funcionalidade**: Permite adicionar múltiplos filtros de pesquisa dinamicamente

### ii) Dropdown "Adicionar filtro"

- **Título**: Adicionar filtro
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: 
  - Selecionar (opção padrão)
  - Identificador
  - Produtor
  - Exploração
  - Espécie
  - Faixa Etária / Espécie
  - Usuário Digitação
  - Usuário Cancelamento
  - Situação da Comunicação
  - Motivo do Cancelamento
  - Data da Comunicação
- **Estado Inicial**: "Selecionar"
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Validações Extras**: Ao selecionar uma opção, adiciona dinamicamente o campo correspondente na área de filtros; Atualiza a lista de opções disponíveis removendo filtros já adicionados

### iii) Campos de Filtro Dinâmicos

#### iii.a) Filtro "Identificador"

- **Título**: Identificador
- **Tipo do Campo**: Texto
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Visível após seleção no dropdown "Adicionar filtro"
- **Tamanho Máximo**: 20 caracteres
- **Validações Extras**: Aceita apenas números

#### iii.b) Filtro "Produtor"

- **Título**: Produtor
- **Tipo do Campo**: Seleção Única (Autocomplete)
- **Opções**: Lista de produtores cadastrados
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Visível após seleção no dropdown "Adicionar filtro"
- **Validações Extras**: Busca incremental por nome ou CPF/CNPJ

#### iii.c) Filtro "Exploração"

- **Título**: Exploração
- **Tipo do Campo**: Seleção Única (Autocomplete)
- **Opções**: Lista de explorações cadastradas
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Visível após seleção no dropdown "Adicionar filtro"
- **Validações Extras**: Pode ser filtrado por produtor se este filtro estiver ativo

#### iii.d) Filtro "Espécie"

- **Título**: Espécie
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Lista de espécies cadastradas (ex: BOVINO, EQUINO, SUÍNO)
- **Estado Inicial**: Vazio com placeholder "Selecione"
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Visível após seleção no dropdown "Adicionar filtro"

#### iii.e) Filtro "Faixa Etária / Espécie"

- **Título**: Faixa Etária / Espécie
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Lista de estratificações (faixas etárias) por espécie
- **Estado Inicial**: Vazio com placeholder "Selecione"
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Visível após seleção no dropdown "Adicionar filtro"
- **Validações Extras**: Pode ser filtrado por espécie se este filtro estiver ativo

#### iii.f) Filtro "Usuário Digitação"

- **Título**: Usuário Digitação
- **Tipo do Campo**: Seleção Única (Autocomplete)
- **Opções**: Lista de usuários do sistema
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Visível após seleção no dropdown "Adicionar filtro"
- **Validações Extras**: Busca incremental por nome ou CPF

#### iii.g) Filtro "Usuário Cancelamento"

- **Título**: Usuário Cancelamento
- **Tipo do Campo**: Seleção Única (Autocomplete)
- **Opções**: Lista de usuários do sistema
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Visível após seleção no dropdown "Adicionar filtro"
- **Validações Extras**: Busca incremental por nome ou CPF

#### iii.h) Filtro "Situação da Comunicação"

- **Título**: Situação da Comunicação
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: COMUNICADO, CANCELADO, EM ANÁLISE, APROVADO, REPROVADO
- **Estado Inicial**: Vazio com placeholder "Selecione"
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Visível após seleção no dropdown "Adicionar filtro"

#### iii.i) Filtro "Motivo do Cancelamento"

- **Título**: Motivo do Cancelamento
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Lista de motivos de cancelamento cadastrados
- **Estado Inicial**: Vazio com placeholder "Selecione"
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Visível após seleção no dropdown "Adicionar filtro"

#### iii.j) Filtro "Data da Comunicação"

- **Título**: Data da Comunicação
- **Tipo do Campo**: Intervalo de Datas (Data Inicial e Data Final)
- **Estado Inicial**: Ambos os campos vazios
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Visível após seleção no dropdown "Adicionar filtro"
- **Validação de Formato**: dd/mm/aaaa
- **Validações Extras**: Data inicial não pode ser posterior à data final; Não pode pesquisar intervalo superior a 365 dias

## 2. Critérios de Aceitação - Ações do Painel de Filtros

### i) Botão "Pesquisar"

- **Status inicial**: Sempre habilitado
- **Tipo**: Botão de ação principal
- **Preenchimento**: Ícone de lupa (fa fa-search) + texto "Pesquisar"
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Executa a pesquisa com os filtros selecionados e atualiza a grade de resultados
- **Destino da navegação**: Permanece na tela (atualiza seção de resultados)
- **Validações**: Aceita pesquisa sem filtros (retorna todos os registros com paginação); Valida formato e consistência dos filtros aplicados; Exibe mensagem se não houver resultados

### ii) Botão "Limpar"

- **Status inicial**: Sempre habilitado
- **Tipo**: Botão de ação
- **Preenchimento**: Ícone de borracha (fa fa-eraser) + texto "Limpar"
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Link
- **Ação realizada**: Remove todos os filtros aplicados e limpa a grade de resultados
- **Destino da navegação**: Permanece na tela (reseta formulário e resultados)
- **Validações**: Reseta todos os campos de filtro; Limpa a seção de resultados; Retorna dropdown "Adicionar filtro" para estado "Selecionar"

### iii) Botão "Incluir"

- **Status inicial**: Habilitado para usuários com permissão "incluir.comunicacaoNascimento"
- **Tipo**: Botão de ação
- **Preenchimento**: Ícone de mais (fa fa-plus) + texto "Incluir"
- **Visibilidade**: Visível para usuários com permissão adequada
- **Classificação da Ação**: Link
- **Ação realizada**: Redireciona para tela de inclusão de nova comunicação de nascimento
- **Destino da navegação**: Tela "Incluir Comunicação de Nascimentos"
- **Validações**: Verifica permissões de carência de nascimentos e quantitativo de matrizes antes de permitir inclusão

## 3. Critérios de Aceitação - Seção "Resultado de Pesquisa"

### i) Painel de Resultados

- **Título**: Resultado de Pesquisa por Comunicação de Nascimentos
- **Tipo**: Painel com tabela de dados (DataTable)
- **Estado Inicial**: Vazio ou com mensagem "Nenhum registro encontrado"
- **Visibilidade**: Sempre visível
- **Funcionalidade**: Exibe resultados da pesquisa em formato tabular com recursos de ordenação, paginação e exportação

### ii) Barra de Exportação

- **Posição**: Canto superior direito do cabeçalho da tabela
- **Visibilidade**: Sempre visível
- **Ícones de Exportação**:
  - **XLS** (Excel): Exporta dados para planilha Excel
  - **PDF**: Exporta dados para documento PDF
  - **CSV**: Exporta dados para arquivo CSV
  - **XML**: Exporta dados para arquivo XML
- **Validações**: Exporta apenas os registros do resultado da pesquisa atual; Respeita filtros aplicados; Inclui todas as colunas visíveis na tabela

## 4. Critérios de Aceitação - Colunas da Tabela de Resultados

### i) Coluna "Identificador"

- **Título**: Identificador
- **Tipo**: Coluna de tabela
- **Conteúdo**: Código único da comunicação (ex: 1089)
- **Ordenação**: Habilitada (ascendente/descendente)
- **Largura**: 110px (redimensionável)
- **Visibilidade**: Sempre visível

### ii) Coluna "Produtor"

- **Título**: Produtor
- **Tipo**: Coluna de tabela
- **Conteúdo**: Nome completo do produtor
- **Ordenação**: Habilitada (ascendente/descendente)
- **Largura**: 110px (redimensionável)
- **Visibilidade**: Sempre visível

### iii) Coluna "Exploração"

- **Título**: Exploração
- **Tipo**: Coluna de tabela
- **Conteúdo**: Código da exploração (ex: 510000004090002)
- **Ordenação**: Habilitada (ascendente/descendente)
- **Largura**: 110px (redimensionável)
- **Visibilidade**: Sempre visível

### iv) Coluna "Espécie"

- **Título**: Espécie
- **Tipo**: Coluna de tabela
- **Conteúdo**: Nome da espécie animal (ex: BOVINO)
- **Ordenação**: Habilitada (ascendente/descendente)
- **Largura**: 110px (redimensionável)
- **Visibilidade**: Sempre visível

### v) Coluna "Faixa Etária / Espécie"

- **Título**: Faixa Etária / Espécie
- **Tipo**: Coluna de tabela
- **Conteúdo**: Descrição completa da estratificação (ex: "00 A 04 MESES - BOVINO - MACHO")
- **Ordenação**: Habilitada (ascendente/descendente)
- **Largura**: 110px (redimensionável)
- **Visibilidade**: Sempre visível

### vi) Coluna "Usuário Digitação"

- **Título**: Usuário Digitação
- **Tipo**: Coluna de tabela
- **Conteúdo**: Nome completo e CPF do usuário que digitou (ex: "ISLANNA HELOIZA PEREIRA ROCHA - 03849199100")
- **Ordenação**: Habilitada (ascendente/descendente)
- **Largura**: 110px (redimensionável)
- **Visibilidade**: Sempre visível

### vii) Coluna "Usuário Cancelamento"

- **Título**: Usuário Cancelamento
- **Tipo**: Coluna de tabela
- **Conteúdo**: Nome completo e CPF do usuário que cancelou (vazio se não cancelado)
- **Ordenação**: Habilitada (ascendente/descendente)
- **Largura**: 110px (redimensionável)
- **Visibilidade**: Sempre visível

### viii) Coluna "Situação da Comunicação"

- **Título**: Situação da Comunicação
- **Tipo**: Coluna de tabela
- **Conteúdo**: Status atual da comunicação (COMUNICADO, CANCELADO, EM ANÁLISE, APROVADO, REPROVADO)
- **Ordenação**: Habilitada (ascendente/descendente)
- **Largura**: 110px (redimensionável)
- **Visibilidade**: Sempre visível

### ix) Coluna "Motivo do Cancelamento"

- **Título**: Motivo do Cancelamento
- **Tipo**: Coluna de tabela
- **Conteúdo**: Descrição do motivo do cancelamento (vazio se não cancelado)
- **Ordenação**: Habilitada (ascendente/descendente)
- **Largura**: 110px (redimensionável)
- **Visibilidade**: Sempre visível

### x) Coluna "Data da Comunicação"

- **Título**: Data da Comunicação
- **Tipo**: Coluna de tabela
- **Conteúdo**: Data da comunicação no formato dd/mm/aaaa
- **Ordenação**: Habilitada (ascendente/descendente)
- **Largura**: 110px (redimensionável)
- **Visibilidade**: Sempre visível
- **Validação de Formato**: dd/mm/aaaa

### xi) Coluna "Quantidade Nascimentos"

- **Título**: Quantidade Nascimentos
- **Tipo**: Coluna de tabela
- **Conteúdo**: Número inteiro representando a quantidade de nascimentos comunicados
- **Ordenação**: Habilitada (ascendente/descendente)
- **Largura**: 110px (redimensionável)
- **Visibilidade**: Sempre visível

### xii) Coluna "Ações"

- **Título**: Ações
- **Tipo**: Coluna de tabela com botões de ação
- **Largura**: 130px (fixa)
- **Visibilidade**: Sempre visível
- **Conteúdo**: Até 4 botões de ação por linha, conforme situação da comunicação

## 5. Critérios de Aceitação - Ações por Registro

### i) Botão "Visualizar"

- **Status inicial**: Sempre habilitado
- **Tipo**: Botão de ação (ícone)
- **Preenchimento**: Ícone de documento (fa-file-text)
- **Visibilidade**: Sempre visível para todos os registros
- **Tooltip**: "Visualizar Comunicação de Nascimento"
- **Classificação da Ação**: Ação Apenas em Tela
- **Ação realizada**: Abre tela de visualização em modo somente leitura
- **Destino da navegação**: Tela "Visualizar Comunicação de Nascimentos"
- **Validações**: Verifica permissão "pesquisar.comunicacaoNascimento"

### ii) Botão "Analisar Nascimento"

- **Status inicial**: Habilitado apenas para comunicações com situação "EM ANÁLISE"
- **Tipo**: Botão de ação (ícone)
- **Preenchimento**: Ícone de check em círculo (fa fa-check-circle)
- **Visibilidade**: Visível apenas para comunicações com situação "EM ANÁLISE"
- **Tooltip**: "Analisar Comunicação de Nascimento"
- **Classificação da Ação**: Ação Apenas em Tela
- **Ação realizada**: Redireciona para tela de análise da comunicação
- **Destino da navegação**: Tela "Analisar Comunicação de Nascimentos"
- **Validações**: Verifica permissão "analisar.comunicacaoNascimento"; Exibe apenas se situação = "EM ANÁLISE"

### iii) Botão "Cancelar"

- **Status inicial**: Habilitado apenas para comunicações com situação "COMUNICADO"
- **Tipo**: Botão de ação (ícone)
- **Preenchimento**: Ícone de proibido (fa-ban)
- **Visibilidade**: Visível apenas para comunicações com situação "COMUNICADO"
- **Tooltip**: "Cancelar Comunicação de Nascimento"
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Redireciona para tela de cancelamento
- **Destino da navegação**: Tela "Cancelar Comunicação de Nascimentos"
- **Validações**: Verifica permissão "cancelar.comunicacaoNascimento"; Exibe apenas se situação = "COMUNICADO"

### iv) Botão "Imprimir"

- **Status inicial**: Sempre habilitado
- **Tipo**: Botão de ação (ícone)
- **Preenchimento**: Ícone de impressora (fa-print)
- **Visibilidade**: Sempre visível para todos os registros
- **Tooltip**: "Imprimir Comunicação de Nascimento"
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Gera e exibe relatório imprimível da comunicação
- **Destino da navegação**: Abre em nova janela/aba ou modal com PDF para impressão
- **Validações**: Verifica permissão "imprimir.comunicacaoNascimento"; Gera documento PDF formatado com todos os dados da comunicação

## 6. Critérios de Aceitação - Paginação e Controles da Tabela

### i) Paginador Inferior

- **Posição**: Parte inferior da tabela
- **Visibilidade**: Sempre visível quando há resultados
- **Componentes**:
  - Indicador de registros: "(X - Y Total Z)" onde X é primeiro registro da página, Y é último registro da página, Z é total de registros
  - Botão "Primeira Página": Navega para primeira página
  - Botão "Página Anterior": Navega para página anterior
  - Números de páginas: Exibe até 10 páginas clicáveis
  - Botão "Próxima Página": Navega para próxima página
  - Botão "Última Página": Navega para última página
  - Dropdown "Registros por Página": Opções 10, 20, 50

### ii) Controle de Registros por Página

- **Tipo**: Dropdown
- **Opções**: 10, 20, 50 registros por página
- **Estado Inicial**: 10 registros
- **Funcionalidade**: Altera quantidade de registros exibidos por página
- **Validações**: Mantém o primeiro registro da página atual visível após mudança; Atualiza contador total de páginas

### iii) Ordenação de Colunas

- **Funcionalidade**: Todas as colunas (exceto "Ações") são ordenáveis
- **Indicador Visual**: Ícone de dupla seta (ui-icon-carat-2-n-s)
- **Estados**: 
  - Não ordenado (ícone dupla seta)
  - Ordenado ascendente (ícone seta para cima)
  - Ordenado descendente (ícone seta para baixo)
- **Validações**: Apenas uma coluna pode estar ordenada por vez; Ordenação mantida durante navegação entre páginas

### iv) Redimensionamento de Colunas

- **Funcionalidade**: Todas as colunas são redimensionáveis
- **Indicador Visual**: Cursor muda para redimensionar ao passar sobre borda da coluna
- **Validações**: Largura mínima de 50px; Largura máxima limitada pelo container da tabela; Preserva proporções das demais colunas

## 7. Regras / Validações / Ações Gerais

### i) Estado Vazio da Tabela

- Quando não há resultados, exibir mensagem: "Nenhum registro encontrado"
- Quando pesquisa não foi executada, exibir tabela vazia sem mensagem
- Após limpar filtros, retornar ao estado inicial vazio

### ii) Controle de Acesso e Permissões

- Botão "Incluir": Aparece apenas para usuários autorizados a incluir comunicações de nascimento
- Botão "Visualizar": Aparece para usuários autorizados a consultar comunicações de nascimento
- Botão "Cancelar": Aparece apenas para usuários autorizados a cancelar comunicações E somente quando a situação da comunicação for "COMUNICADO"
- Botão "Imprimir": Aparece para usuários autorizados a imprimir comunicações de nascimento

### iii) Integração com Outras Funcionalidades

- Ao retornar de telas de Incluir, Visualizar ou Cancelar, manter filtros aplicados
- Atualizar automaticamente resultados após inclusão ou cancelamento bem-sucedido
- Preservar estado de ordenação e paginação durante navegação

## 8. Requisitos Considerados

- **RF-NASC-LIST-001 – Pesquisa Multicritério:** O sistema deve permitir pesquisa de comunicações de nascimentos utilizando múltiplos critérios de filtro de forma combinada, incluindo identificador, produtor, exploração, espécie, estratificação, usuários, situação, motivo de cancelamento e data da comunicação.

- **RF-NASC-LIST-002 – Visualização e Gerenciamento:** O sistema deve permitir visualizar, cancelar (quando aplicável) e imprimir comunicações de nascimentos diretamente da listagem de resultados, com validação de permissões específicas para cada ação.

- **RF-NASC-LIST-003 – Exportação de Dados:** O sistema deve permitir exportação dos resultados de pesquisa nos formatos XLS, PDF, CSV e XML, mantendo todos os dados das colunas visíveis na tabela.

- **RF-NASC-LIST-004 – Controle de Situações:** O sistema deve exibir diferentes ações por registro conforme a situação da comunicação, permitindo cancelamento apenas de comunicações com status "COMUNICADO" e visualização/impressão para todas as situações.

- **RF-NASC-LIST-005 – Análise de Nascimentos:** MÓDULO ANIMAL - na funcionalidade nascimento, criar um botão de ação denominado de ANALISAR NASCIMENTO. Ao acessar esse botão o usuário irá ver a comunicação de nascimento e o questionário (US012). Cabe ao usuário APROVAR ou RECUSAR o nascimento. No caso de recusa, apresentar o campo MOTIVO DA RECUSA, com 1000 caracteres. O BOTÃO ANALISAR COMUNICAÇÃO É HABILITADO QUANDO A SITUAÇÃO DA COMUNICAÇÃO DO NASCIMENTO FOR EM ANÁLISE

