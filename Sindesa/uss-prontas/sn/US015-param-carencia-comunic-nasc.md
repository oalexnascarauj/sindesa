# US015 - Alterar Parâmetros da Guia Parâmetros Animal
#### STRY0087925

## DESCRIÇÃO

**Título da Tela:** Parâmetros Animal
**Caminho de navegação (breadcrumb):** Configurações > Parâmetros do Sistema > Parâmetros Animal

**EU COMO** administrador do sistema
**QUERO** alterar os parâmetros específicos da guia "Parâmetros Animal"
**PARA QUE** o sistema utilize corretamente as regras e textos definidos para validações, relatórios e emissão de documentos relacionados ao módulo animal.

## PROTÓTIPO DE TELA

![Protótipo - US015 Parâmetros Animal](US015-param-carencia-comunic-nasc.png)

*Figura 1: Protótipo da tela de parâmetros do sistema, guia "Parâmetros Animal" selecionada, exibindo todos os campos e botões descritos abaixo.*

## 1. Critérios de Aceitação - Componentes da Guia "Parâmetros Animal"

### i) Verificação DAR Animal
- **Título**: Verificação DAR Animal?
- **Tipo do Campo**: Dropdown (Seleção Única)
- **Opções**: SIM, NÃO
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível

### ii) Prazo de Validade da Receita de Brucelose (Dias)
- **Título**: Prazo de Validade da Receita de Brucelose (Dias)
- **Tipo do Campo**: Número Inteiro (InputText)
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível

### iii) Prazo de Validade da GTA (Dias)
- **Título**: Prazo de Validade da GTA (Dias)
- **Tipo do Campo**: Número Inteiro (InputText)
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível

### iv) Prazo de Validade do cadastro do produtor (Dias)
- **Título**: Prazo de Validade do cadastro do produtor (Dias)
- **Tipo do Campo**: Número Inteiro (InputText)
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível
- **Ícone de informação**: fa fa-info-circle

### v) Prazo de Carência para entrada de GTA Intraestadual (Dias)
- **Título**: Prazo de Carência para entrada de GTA Intraestadual (Dias)
- **Tipo do Campo**: Número Inteiro (InputText)
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível

### vi) Prazo de Carência para entrada de GTA Interestadual (Dias)
- **Título**: Prazo de Carência para entrada de GTA Interestadual (Dias)
- **Tipo do Campo**: Número Inteiro (InputText)
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível

### vii) Prazo para visualização de GTAs na aba GTAs de Origem (Dias)
- **Título**: Prazo para visualização de GTAs na aba GTAs de Origem (Dias)
- **Tipo do Campo**: Número Inteiro (InputText)
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível
- **Ícone de informação**: fa fa-info-circle

### viii) Prazo de Carência para Comunicação de Nascimento de Bovídeos (Dias)
- **Título**: Prazo de Carência para Comunicação de Nascimento de Bovídeos (Dias)
- **Tipo do Campo**: Número Inteiro (InputText)
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: 30
- **Visibilidade**: Sempre visível

### ix) Prazo de Carência para Comunicação de Evolução de Bovídeos (Dias)
- **Título**: Prazo de Carência para Comunicação de Evolução de Bovídeos (Dias)
- **Tipo do Campo**: Número Inteiro (InputText)
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: 30
- **Visibilidade**: Sempre visível

### viii) Cabeçalho Relatórios
- **Título**: Cabeçalho Relatórios
- **Tipo do Campo**: Texto Multilinha (Textarea)
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível
- **Limite de caracteres**: 300

### ix) Cabeçalho Ficha/Termo
- **Título**: Cabeçalho Ficha/Termo
- **Tipo do Campo**: Texto Multilinha (Textarea)
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível
- **Limite de caracteres**: 300

### x) Rodapé
- **Título**: Rodapé
- **Tipo do Campo**: Texto Multilinha (Textarea)
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível
- **Limite de caracteres**: 300

### xi) Imprimir Mensagens em todas as GTAs
- **Título**: Imprimir Mensagens em todas as GTAs
- **Tipo do Campo**: Dropdown (Seleção Única)
- **Opções**: SIM, NÃO
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível

### xii) Mensagem GTA
- **Título**: Mensagem GTA
- **Tipo do Campo**: Texto Multilinha (Textarea)
- **Preenchimento do Campo**: Opcional
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível
- **Limite de caracteres**: 300

### xiii) Imprimir Mensagens para BOVÍDEOS
- **Título**: Imprimir Mensagens para BOVÍDEOS
- **Tipo do Campo**: Dropdown (Seleção Única)
- **Opções**: SIM, NÃO
- **Preenchimento do Campo**: Obrigatório
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível

### xiv) Mensagem BOVÍDEOS
- **Título**: Mensagem BOVÍDEOS
- **Tipo do Campo**: Texto Multilinha (Textarea)
- **Preenchimento do Campo**: Opcional
- **Estado Inicial**: Valor carregado do banco
- **Visibilidade**: Sempre visível
- **Limite de caracteres**: 300

## 2. Critérios de Aceitação - Botão de Ação

### i) Botão "Alterar"
- **Status inicial**: Sempre habilitado
- **Tipo**: Botão de ação principal
- **Preenchimento**: Ícone de lápis (fa fa-pencil) + texto "Alterar"
- **Visibilidade**: Sempre visível
- **Classificação da Ação**: Ações Práticas
- **Ação realizada**: Permite editar todos os campos da guia "Parâmetros Animal" e salvar alterações
- **Destino da navegação**: Permanece na tela e exibe mensagem de sucesso
- **Validações**: Verifica obrigatoriedade e formato dos campos


## 3. Requisitos Considerados

- Criar período de carência parametrizado para evolução contado a partir da entrada de uma GTA e entre evoluções.
- Criar período de carência parametrizado para nascimento contado a partir da entrada de uma GTA e entre comunicações de nascimento.

