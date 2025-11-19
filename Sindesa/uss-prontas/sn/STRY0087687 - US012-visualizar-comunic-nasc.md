# US012 - Analisar Comunicação de Nascimentos
#### STRY0087687

## DESCRIÇÃO

**Título da Tela:** Analisar Comunicação de Nascimentos
**Caminho de navegação (breadcrumb):** Pesquisa de Comunicação de Nascimentos > Analisar Comunicação de Nascimentos

**EU COMO** servidor com perfil INDEA
**QUERO** analisar uma comunicação de nascimento que está "EM ANÁLISE" por quebra de regras (limite de matrizes ou prazo de carência)
**PARA QUE** eu possa aprovar ou reprovar a comunicação com base na justificativa fornecida.

## 1. Critérios de Aceitação - Campos 

*Os campos a seguir exibem os dados da comunicação original em modo de apenas visualização.*

### i) Identificador
- **Título**: Identificador
- **Tipo do Campo**: Texto (Não editável)
- **Preenchimento**: Apenas visualização

### ii) Produtor ou Promotor de Evento
- **Título**: Produtor ou Promotor de Evento
- **Tipo do Campo**: Seleção Única (Não editável)
- **Preenchimento**: Apenas visualização

### iii) Produtor
- **Título**: Produtor
- **Tipo do Campo**: Seleção Única (Não editável)
- **Preenchimento**: Apenas visualização

### iv) Exploração
- **Título**: Exploração
- **Tipo do Campo**: Seleção Única (Não editável)
- **Preenchimento**: Apenas visualização

### v) Espécie
- **Título**: Espécie
- **Tipo do Campo**: Seleção Única (Não editável)
- **Preenchimento**: Apenas visualização

### vi) Estratificação
- **Título**: Estratificação
- **Tipo do Campo**: Seleção Única (Não editável)
- **Preenchimento**: Apenas visualização

### vii) Quantidade
- **Título**: Quantidade
- **Tipo do Campo**: Número Inteiro (Não editável)
- **Preenchimento**: Apenas visualização

### viii) Data da Comunicação
- **Título**: Data da Comunicação
- **Tipo do Campo**: Data (Não editável)
- **Preenchimento**: Apenas visualização

### ix) Incluído por
- **Título**: Incluído por
- **Tipo do Campo**: Texto (Não editável)
- **Preenchimento**: Apenas visualização

### x) Situação da Comunicação
- **Título**: Situação da Comunicação
- **Tipo do Campo**: Seleção Única (Não editável)
- **Valor Esperado**: "EM ANÁLISE"
- **Preenchimento**: Apenas visualização

### xi) Questionário
- **Título**: Questionário
- **Tipo do Campo**: Seção/Container
- **Preenchimento**: Apenas visualização
- **Visibilidade**: Sempre visível quando a comunicação está "EM ANÁLISE"
- **Descrição**: Exibe o questionário preenchido pelo informante com as justificativas para a comunicação de nascimento que não cumpriu os requisitos (limite de matrizes atingido ou prazo de carência não cumprido). O questionário completo deve ser apresentado em modo somente leitura para análise pelo servidor.

## 2. Critérios de Aceitação - Seção de Análise (Somente Leitura)

*Esta seção só é visível se a comunicação tiver sido analisada (status APROVADO ou RECUSADO).*

### i) Data da Aprovação/Recusa
- **Título**: Data da Análise
- **Tipo**: Data (Não editável)

### ii) Usuário da Aprovação/Recusa
- **Título**: Analisado por
- **Tipo**: Texto (Não editável)

### iii) Motivo da Recusa
- **Título**: Motivo da Recusa
- **Tipo**: Área de Texto
- **Tamanho Máximo**: 1000 caracteres
- **Preenchimento**: Obrigatório quando a ação "Reprovar" for executada
- **Visibilidade**: Sempre visível
- **Estado**: 
  - Somente leitura quando a comunicação já foi analisada (APROVADO ou RECUSADO)
  - Editável apenas quando o botão "Reprovar Comunicação" é clicado (situação "EM ANÁLISE")
  - Vazio em caso de APROVADO
- **Validação**: Campo obrigatório para concluir a reprovação

## 3. Critérios de Aceitação - Ações

*As ações a seguir são visíveis apenas para servidores com perfil INDEA e quando a comunicação está com a situação "EM ANÁLISE".*

### i) Botão "Aprovar Comunicação"
- **Visibilidade**: Visível e habilitado para servidor INDEA se a situação for "EM ANÁLISE".
- **Tipo**: Botão de ação.
- **Ação realizada**: Altera a situação para "APROVADO", registra o usuário e a data da aprovação.

### ii) Botão "Reprovar Comunicação"
- **Visibilidade**: Visível e habilitado para servidor INDEA se a situação for "EM ANÁLISE".
- **Tipo**: Botão de ação.
- **Ação realizada**: Ao ser clicado, habilita o campo "Motivo da Recusa" para edição e, após preenchimento e confirmação, altera a situação para "REPROVADO", registrando os dados da análise (data, usuário e motivo).

### iii) Botão "Fechar"
- **Status inicial**: Sempre habilitado
- **Tipo**: Botão de ação
- **Preenchimento**: Ícone de fechar + texto "Fechar"
- **Visibilidade**: Sempre visível
- **Ação realizada**: Fecha a tela de visualização.
- **Destino da navegação**: Retorna para a tela de Pesquisa de Comunicação de Nascimentos.

## 4. Requisitos Considerados

- **21. MÓDULO ANIMAL:** Na funcionalidade nascimento, criar um botão de ação denominado de ANALISAR NASCIMENTO. Ao acessar esse botão o usuário irá ver a comunicação de nascimento e o questionário. Cabe ao usuário APROVAR ou RECUSAR o nascimento. No caso de recusa, apresentar o campo MOTIVO DA RECUSA, com 1000 caracteres. O BOTÃO ANALISAR COMUNICAÇÃO É HABILITADO QUANDO A SITUAÇÃO DA COMUNICAÇÃO DO NASCIMENTO FOR EM ANÁLISE.

- **22. MÓDULO ANIMAL:** Na funcionalidade nascimento, o botão visualizar deve apresentar na tela o usuário que aprovou ou recusou a comunicação. Para o caso de recusa, apresentar o motivo. Para isso apresentar, se APROVADO, os campos: Data da Aprovação (Timestamp) e Usuário da aprovação. Se RECUSADO, data da recusa (timestamp), usuário da recusa e motivo da recusa.

- **Aprovação/Reprovação de Comunicação de Nascimentos:** a APROVAÇÃO ou REPROVAÇÃO de uma comunicação de nascimento deve ser realizada por um servidor com perfil INDEA, que terá acesso aos botões específicos para essas ações quando a comunicação estiver em análise. o INFORMANTE não poderá comunicar nascimentos sem justificativa (questionário) nos seguinte casos:
  - limite de matrizes for atingido para estratifiação selecionada.
  - prazo de carência para nascimentos não cumprido.