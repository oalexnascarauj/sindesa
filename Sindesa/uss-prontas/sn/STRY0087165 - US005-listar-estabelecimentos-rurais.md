# US005 - Listar Estabelecimentos Rurais
#### STRY0087165

## DESCRIÇÃO

**Título da Tela:** Filtro de Pesquisa de Estabelecimento
**Caminho de navegação (breadcrumb):** Pesquisa de Estabelecimento Rural > Estabelecimento/Exploração

**EU COMO** usuário do sistema de cadastro rural do INDEA
**QUERO** pesquisar estabelecimentos rurais por diversos critérios de filtro
**PARA QUE** eu possa localizar, visualizar, editar e gerenciar estabelecimentos cadastrados no sistema de forma eficiente

---

## PROTÓTIPO DE TELA

![Protótipo - US005 Listar Estabelecimento Rural](US005-listar-estabelecimento-rural.png)

*Figura 1: Tela de listagem com filtros de pesquisa e tabela de resultados com ações para cada estabelecimento*

---

## 1. Critérios de Aceitação - Campos de Filtro

### i) Seleção do Campo de Filtro

- **Título**: Adicionar filtro
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Código, Nome, Histórico Nome (Fonetizado), CPF/CNPJ Produtor, Indicativo Rural/Não Rural, Município, Unidade Local de Execução, Setor do Município, CPF/CNPJ do Proprietário, Nome do Proprietário, Situação
- **Seleção**: Uma opção
- **Estado Inicial**: Placeholder "Selecionar"
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível
- **Validações Extras**: Ao selecionar uma opção, deve habilitar o campo correspondente para preenchimento

### ii) Fieldset de Filtros

- **Título**: Filtro de Pesquisa de Estabelecimento
- **Tipo do Campo**: Container recolhível
- **Estado Inicial**: Expandido
- **Preenchimento do Campo**: N/A
- **Visibilidade**: Sempre visível
- **Funcionalidade**: Permite recolher/expandir a seção de filtros

## 2. Critérios de Aceitação - Tabela de Resultados

### i) Estrutura da Tabela

- **Status inicial**: "Sem registros" quando não há dados
- **Tipo**: Tabela de dados com paginação
- **Preenchimento**: Obrigatório quando há resultados
- **Visibilidade**: Sempre visível após pesquisa
- **Colunas**: Código, Nome, Indicativo Rural/Não Rural, Município, Situação, Ações

#### Detalhamento das Colunas:

##### 1) Código
- **Tipo**: Coluna de tabela
- **Preenchimento**: Obrigatório, não editável
- **Visibilidade**: Sempre visível
- **Formato**: Numérico (ex: 51000000003)

##### 2) Nome
- **Tipo**: Coluna de tabela
- **Preenchimento**: Obrigatório, não editável
- **Visibilidade**: Sempre visível

##### 3) Indicativo Rural/Não Rural
- **Tipo**: Coluna de tabela
- **Preenchimento**: Obrigatório, não editável
- **Visibilidade**: Sempre visível
- **Valores Permitidos**: RURAL, NÃO RURAL

##### 4) Município
- **Tipo**: Coluna de tabela
- **Preenchimento**: Obrigatório, não editável
- **Visibilidade**: Sempre visível

##### 5) Situação
- **Tipo**: Coluna de tabela
- **Preenchimento**: Obrigatório, não editável
- **Visibilidade**: Sempre visível
- **Valores Permitidos**: CADASTRO DEFINITIVO, CADASTRO SUSPENSO, CADASTRO INATIVO, CADASTRO PROVISÓRIO

##### 6) Ações
- **Tipo**: Coluna de tabela com botões
- **Preenchimento**: 6 botões por registro
- **Visibilidade**: Sempre visível

### ii) Botões de Ação por Registro

#### a.1) Visualizar
- **Tipo**: Botão
- **Preenchimento**: Ícone de arquivo/texto (fa-file-text)
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Ação Apenas em Tela
- **Ação realizada**: Abre tela de visualização do estabelecimento em modo somente leitura
- **Destino da navegação**: Tela de visualização do estabelecimento
- **Validações**: Verifica permissão de visualização do usuário

#### a.2) Alterar
- **Tipo**: Botão
- **Preenchimento**: Ícone de lápis (fa-pencil)
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Abre tela de edição do estabelecimento
- **Destino da navegação**: Tela de alteração do estabelecimento
- **Validações**: Verifica permissão de edição do usuário; Na tela de edição, para alteração de status para "DEFINITIVO", aplica mesma restrição municipal

#### a.3) Excluir
- **Tipo**: Botão
- **Preenchimento**: Ícone de lixeira (fa-trash)
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Remove o estabelecimento do sistema
- **Destino da navegação**: Permanece na tela atual (atualiza lista)
- **Validações**: Solicita confirmação antes da exclusão; Verifica se não existem vínculos ativos

#### a.4) Ativar/Desativar
- **Tipo**: Botão
- **Preenchimento**: Ícone de "ban" (fa-ban)
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Altera o status de ativo/inativo do estabelecimento
- **Destino da navegação**: Permanece na tela atual (atualiza lista)
- **Validações**: Solicita confirmação; Alterna entre ativo/inativo; **RF-AC-005**: Para tornar estabelecimento "DEFINITIVO", verifica se o município do servidor logado é igual ao município do estabelecimento; Se municípios diferentes, exibe mensagem: "Você não tem permissão para tornar este estabelecimento definitivo. Apenas servidores do município [NOME_MUNICÍPIO] podem realizar esta operação."

#### a.5) Exploração Pecuária
- **Tipo**: Botão
- **Preenchimento**: Ícone de pata (fa-paw)
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Abre tela de exploração pecuária do estabelecimento
- **Destino da navegação**: Tela de exploração pecuária
- **Validações**: Disponível apenas para estabelecimentos rurais

#### a.6) Imprimir Ficha
- **Tipo**: Botão
- **Preenchimento**: Ícone de impressora (fa-print)
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Gera e abre relatório da ficha de cadastro
- **Destino da navegação**: Nova aba/janela com relatório PDF
- **Validações**: Verifica se pop-ups estão liberados no navegador

## 3. Critérios de Aceitação - Funcionalidades da Tabela

### i) Paginação
- **Itens por página**: 10 (opções: 10, 20, 50)
- **Navegação**: Primeira, anterior, numérica, próxima, última
- **Contador**: Exibe range e total (ex: "1 - 10 Total 264")
- **Visibilidade**: Sempre visível quando há múltiplas páginas

### ii) Ordenação
- **Funcionalidade**: Clique no cabeçalho para ordenar ascendente/descendente
- **Colunas ordenáveis**: Todas as colunas de dados
- **Indicador visual**: Ícone de triângulo no cabeçalho

### iii) Exportação de Dados
- **Formatos disponíveis**: XLS, PDF, CSV, XML
- **Localização**: Canto superior direito da tabela
- **Visibilidade**: Sempre visível

#### Botões de Exportação:

##### 1) Exportar para XLS
- **Tipo**: Link com ícone
- **Preenchimento**: Ícone de planilha (fa-file-excel-o)
- **Visibilidade**: Sempre visível
- **Ação**: Gera arquivo Excel com dados da pesquisa atual

##### 2) Exportar para PDF
- **Tipo**: Link com ícone
- **Preenchimento**: Ícone de PDF (fa-file-pdf-o)
- **Visibilidade**: Sempre visível
- **Ação**: Gera arquivo PDF com dados da pesquisa atual

##### 3) Exportar para CSV
- **Tipo**: Link com ícone
- **Preenchimento**: Ícone de texto (fa-file-text-o)
- **Visibilidade**: Sempre visível
- **Ação**: Gera arquivo CSV com dados da pesquisa atual

##### 4) Exportar para XML
- **Tipo**: Link com ícone
- **Preenchimento**: Ícone de código (fa-file-code-o)
- **Visibilidade**: Sempre visível
- **Ação**: Gera arquivo XML com dados da pesquisa atual

## 4. Critérios de Aceitação - Botões Principais

### i) Botão "Pesquisar"
- **Tipo**: Botão
- **Preenchimento**: Texto "Pesquisar" com ícone de lupa
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Executa a pesquisa com base nos filtros preenchidos
- **Destino da navegação**: Permanece na tela atual (atualiza resultados)
- **Validações**: Pelo menos um filtro deve ser preenchido; Exibe loading durante a execução

### ii) Botão "Limpar"
- **Tipo**: Botão
- **Preenchimento**: Texto "Limpar" com ícone de borracha
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Link
- **Ação realizada**: Limpa todos os filtros preenchidos
- **Destino da navegação**: Permanece na tela atual (limpa formulário)
- **Validações**: Não solicita confirmação; Limpa imediatamente

### iii) Botão "Incluir"
- **Tipo**: Botão com menu dropdown
- **Preenchimento**: Texto "Incluir" com ícone de mais
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Link
- **Opções do menu**:
  - Estabelecimento Rural
  - Estabelecimento Não Rural

#### a) Estabelecimento Rural
- **Ação realizada**: Abre tela de inclusão de estabelecimento rural
- **Destino da navegação**: Tela de cadastro de estabelecimento rural
- **Validações**: Verifica permissão de inclusão do usuário

#### b) Estabelecimento Não Rural
- **Ação realizada**: Abre tela de inclusão de estabelecimento não rural
- **Destino da navegação**: Tela de cadastro de estabelecimento não rural
- **Validações**: Verifica permissão de inclusão do usuário

## 5. Regras / Validações / Ações não relacionadas apenas a um campo

- **Validação de pesquisa**: Pelo menos um campo de filtro deve ser preenchido para executar a pesquisa
- **Performance**: A pesquisa deve retornar resultados em até 5 segundos para até 10.000 registros
- **Mensagem de empty state**: Exibir "Nenhum registro encontrado" quando a pesquisa não retornar resultados
- **Controle de acesso**: Botões de ação devem respeitar as permissões do usuário logado
- **Histórico de pesquisa**: Manter os filtros aplicados durante a sessão do usuário
- **Responsividade**: A tabela deve ser responsiva e adaptável para dispositivos móveis
- **Acessibilidade**: Todos os elementos devem ser acessíveis via teclado e screen readers

### **RF-AC-005 - Restrição Municipal para Status Definitivo**

- **Regra de Negócio**: A operação de alterar status de estabelecimento rural para "CADASTRO DEFINITIVO" deve ser restrita exclusivamente a servidores cujo município de lotação/endereço cadastral seja o mesmo município do estabelecimento rural
- **Implementação**: 
  - Sistema verifica o município do servidor logado vs município do estabelecimento
  - Se municípios diferentes: bloqueia ação e exibe mensagem informativa
  - Se municípios iguais: permite a operação normalmente
- **Mensagem de Bloqueio**: "Você não tem permissão para tornar este estabelecimento definitivo. Apenas servidores lotados no município de [NOME_MUNICÍPIO] podem realizar esta operação."
- **Aplicação**: 
  - Botão "Ativar/Desativar" na listagem (quando mudança for para DEFINITIVO)
  - Tela de edição de estabelecimento (campo situação/status)
  - Qualquer interface que permita alteração de status de estabelecimento
- **Exceções**: Não se aplica aos demais status (PROVISÓRIO, SUSPENSO, INATIVO) - apenas para DEFINITIVO
- **Log de Auditoria**: Registrar tentativas de acesso negado com identificação do servidor e estabelecimento

## 6. Requisitos Considerados

- **Requisitos nas palavras do cliente**

  MÓDULO ANIMAL - Permitir que exista a possibilidade de **reativar um cadastro de ESTABELECIMENTO RURAL** para qualquer usuário que seja SERVIDOR, independentemente do PERFIL DE ACESSO.

  MÓDULO ANIMAL - Permitir que qualquer USUÁRIO SERVIDOR possa tornar um **cadastro de estabelecimento rural definitivo**. DESDE QUE A LOTAÇÃO DO SERVIDOR SEJA = AO MUNICÍPIO DO ESTABELECIMENTO RURAL Atualmente existe permissão apenas para o perfil VETERINÁRIO ULE.

  MÓDULO ANIMAL - Permitir que qualquer USUÁRIO SERVIDOR possa tornar uma **exploração pecuária definitiva**, DESDE QUE A LOTAÇÃO DO SERVIDOR SEJA = AO MUNICÍPIO DO ESTABELECIMENTO RURAL Atualmente existe permissão apenas para o perfil VETERINÁRIO ULE.