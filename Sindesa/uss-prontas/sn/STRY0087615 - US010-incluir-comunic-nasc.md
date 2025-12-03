# US010 - Incluir Comunicação de Nascimentos - Regras de Carência
#### STRY0087615 solicitar confirmação

## DESCRIÇÃO

**Título da Tela:** Incluir Comunicação de Nascimentos
**Caminho de navegação (breadcrumb):** Pesquisa de Comunicação de Nascimentos > Incluir Comunicação de Nascimentos

**EU COMO** produtor rural
**QUERO** registrar nascimentos do meu rebanho informando espécie, estratificação e quantidade
**PARA QUE** eu possa manter o controle zootécnico atualizado e cumprir com as obrigações sanitárias, mesmo quando houver necessidade de justificar nascimentos fora dos parâmetros normais.

## PROTÓTIPO DE TELA

![Protótipo - US010 Incluir Comunicação de Nascimentos](US010-incluir-comunic-nasc.png)

*Figura 1: Tela de inclusão de comunicação de nascimentos com campos para produtor, exploração, espécie, estratificação e quantidade com validação de regras de carência*

## 1. Critérios de Aceitação - Campos

### i) Identificador
- **Título**: Identificador
- **Tipo do Campo**: Texto
- **Estado Inicial**: Preenchido automaticamente (ex: "980")
- **Preenchimento do Campo**: Apenas visualização
- **Visibilidade**: Sempre visível
- **Validações Extras**: Gerado automaticamente pelo sistema, somente leitura

### ii) Produtor ou Promotor de Evento
- **Título**: Produtor ou Promotor de Evento
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: PRODUTOR, PROMOTOR
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: "PRODUTOR" selecionado
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validações Extras**: Ao alterar, atualiza os painéis dependentes

### iii) Produtor
- **Título**: Produtor
- **Tipo do Campo**: Seleção Única (Autocomplete)
- **Opções**: Lista de produtores cadastrados
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Visível quando tipo for "PRODUTOR"
- **Validações Extras**: Ao selecionar, carrega explorações disponíveis

### iv) Exploração
- **Título**: Exploração
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Lista de explorações filtrada pelo produtor
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: "SELECIONE"
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validações Extras**: Habilitado após seleção do produtor; ao selecionar, carrega espécies disponíveis

### v) Espécie
- **Título**: Espécie
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Lista de espécies disponíveis para a exploração
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: Desabilitado com "SELECIONE"
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validações Extras**: Habilitado após seleção da exploração; ao selecionar, carrega estratificações

### vi) Estratificação
- **Título**: Estratificação
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Lista de estratificações (faixas etárias) para a espécie
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: Desabilitado com "SELECIONE"
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validações Extras**: Habilitado após seleção da espécie

### vii) Quantidade
- **Título**: Quantidade
- **Tipo do Campo**: Número Inteiro
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Tamanho Máximo**: 10 dígitos
- **Validações Extras**: Deve ser maior que zero

### viii) Data da Comunicação
- **Título**: Data da Comunicação
- **Tipo do Campo**: Data
- **Estado Inicial**: Data atual (ex: "17/11/2025")
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validação de Formato**: dd/mm/aaaa
- **Validações Extras**: Não pode ser data futura

### ix) Incluído por
- **Título**: Incluído por
- **Tipo do Campo**: Texto
- **Estado Inicial**: Preenchido com dados do usuário logado
- **Preenchimento do Campo**: Apenas visualização
- **Visibilidade**: Sempre visível
- **Validações Extras**: Somente leitura

### x) Situação da Comunicação
- **Título**: Situação da Comunicação
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: COMUNICADO, CANCELADO
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: "COMUNICADO" selecionado
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validações Extras**: Somente leitura durante inclusão

## 2. Critérios de Aceitação - Ações

### i) Botão "Salvar"
- **Status inicial**: Habilitado quando todos os campos obrigatórios estão preenchidos
- **Tipo**: Botão de ação principal
- **Preenchimento**: Ícone de disquete + texto "Salvar"
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Valida regras de carência e salva a comunicação
- **Destino da navegação**: Permanece na tela (sucesso) ou exibe questionário (regra quebrada)
- **Validações**: Executa validações de carência e limite de matrizes; se regras forem quebradas, exibe questionário justificativo

### ii) Botão "Limpar"
- **Status inicial**: Sempre habilitado
- **Tipo**: Botão de ação
- **Preenchimento**: Ícone de borracha + texto "Limpar"
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Link
- **Ação realizada**: Limpa todos os campos editáveis
- **Destino da navegação**: Permanece na tela (campos resetados)
- **Validações**: Solicita confirmação se houver dados preenchidos

### iii) Botão "Fechar"
- **Status inicial**: Sempre habilitado
- **Tipo**: Botão de ação
- **Preenchimento**: Ícone de fechar + texto "Fechar"
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Link
- **Ação realizada**: Fecha a tela atual
- **Destino da navegação**: Retorna para tela de Pesquisa de Comunicação de Nascimentos
- **Validações**: Se houver dados não salvos, solicita confirmação

## 3. Regras / Validações / Ações não relacionadas apenas a um campo

### i) Regras de Carência para Nascimento
- O sistema deve validar se o nascimento cumpre o prazo de carência estabelecido para a espécie/exploração
- Deve validar se a quantidade informada não extrapola o número máximo de matrizes permitido
- Parâmetros de carência e limite de matrizes devem ser configuráveis por espécie e exploração

### ii) Questionário de Justificativa
- Quando um nascimento não cumprir o prazo de carência OU extrapolar o número de matrizes:
  - O botão "Salvar" deve ficar desabilitado inicialmente
  - Deve ser apresentado automaticamente um questionário modal para justificar o nascimento
  - O questionário deve conter campos específicos para justificativa técnica
  - Após preencher e salvar o questionário, o botão "Salvar" é habilitado

### iii) Fluxo de Situação
- Comunicações que seguem as regras normais: situação "COMUNICADO"
- Comunicações que requerem justificativa: após salvar questionário, situação "EM ANÁLISE"
- O campo "Situação da Comunicação" deve refletir automaticamente o status conforme as regras validadas

### iv) Dependências entre Campos
- Campo "Produtor" depende da seleção de "Produtor ou Promotor de Evento" = "PRODUTOR"
- Campo "Exploração" depende da seleção de "Produtor"
- Campo "Espécie" depende da seleção de "Exploração"
- Campo "Estratificação" depende da seleção de "Espécie"
- Campos dependentes ficam desabilitados até que o campo pai seja preenchido

## 4. Requisitos Considerados

- **Regras de Carência e Questionário Justificativo:** O sistema deve validar automaticamente o cumprimento dos prazos de carência e limites de matrizes para nascimentos. Quando essas regras forem quebradas, deve apresentar questionário obrigatório para justificativa técnica, alterando a situação para "EM ANÁLISE" após salvar.