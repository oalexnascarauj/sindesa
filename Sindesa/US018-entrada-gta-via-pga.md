# US018 - Entrada de GTA via PGA
#### STRXXX

## DESCRIÇÃO

**Título da Tela:** Entrada de Guia de Trânsito Animal
**Caminho de navegação (breadcrumb):** Pesquisa de Emissão de Guia de Trânsito Animal (GTA) > Entrada de Guia de Trânsito Animal

**EU COMO** servidor do INDEA
**QUERO** registrar a entrada de Guias de Trânsito Animal (GTA) de origem fora de MT
**PARA QUE** eu possa controlar o trânsito interestadual de animais e assegurar a atualização correta dos saldos e conformidades sanitárias.

## PROTÓTIPO DE TELA

![Protótipo - US002 Entrada de GTA](US002-entrada-gta.png)

## 1. Critérios de Aceitação - Seção "Origem / Destino"

### i) UF Origem

- **Título**: Estado Origem
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Lista de Unidades Federativas (AC, AL, AM, AP, BA, CE, DF, ES, GO, MA, MG, MS, PA, PB, PE, PI, PR, RJ, RN, RO, RR, RS, SC, SE, SP, TO)
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: Placeholder "SELECIONE"
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validações Extras**: Não deve permitir selecionar o estado de destino (MT)

### ii) UF Destino

- **Título**: Estado Destino
- **Tipo do Campo**: Texto
- **Estado Inicial**: "MT"
- **Preenchimento do Campo**: Apenas visualização (Leitura)
- **Visibilidade**: Sempre visível
- **Valor Padrão**: MT

### iii) Número da GTA

- **Título**: Número da GTA
- **Tipo do Campo**: Numérico
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Tamanho Máximo**: 9 dígitos
- **Validações Extras**: Deve ser confirmado no campo "Confirmar Número da GTA"

### iv) Série da GTA

- **Título**: Série da GTA
- **Tipo do Campo**: Texto
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Tamanho Máximo**: 2 caracteres
- **Validações Extras**: Deve ser confirmado no campo "Confirmar Série da GTA"

### v) Confirmação Número da GTA

- **Título**: Confirmar Número da GTA
- **Tipo do Campo**: Numérico
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validações Extras**: Deve ser idêntico ao valor do campo "Número da GTA"

### vi) Confirmação Série da GTA

- **Título**: Confirmar Série da GTA
- **Tipo do Campo**: Texto
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validações Extras**: Deve ser idêntico ao valor do campo "Série da GTA"

### vii) Data de Emissão

- **Título**: Data de Emissão
- **Tipo do Campo**: Data (Calendário)
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validações Extras**: Não pode ser futura

### viii) Data de Chegada dos Animais

- **Título**: Data de Chegada dos Animais
- **Tipo do Campo**: Data (Calendário)
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Validações Extras**: Deve ser igual ou posterior à Data de Emissão

## 2. Critérios de Aceitação – Seção "Classificação e Espécie"

### i) Grupo de Espécie

- **Título**: Grupo de Espécie
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: ANFIBIOS, AVES, BOVÍDEOS, CAPRINO, CAPRINOS, EQUÍDEOS, OUTRS ESPÉCIES, PEIXES, SUÍDEOS
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: Placeholder "SELECIONE"
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Regra de Negócio**: A seleção deste campo recarrega/habilita os campos de Espécie, Procedência e Destino

### ii) Espécie

- **Título**: Espécie
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Lista filtrada com base no Grupo de Espécie selecionado
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: Desabilitado (até seleção do Grupo)
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível

### iii) Finalidade

- **Título**: Finalidade
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Lista de finalidades de trânsito
- **Seleção**: Uma opção obrigatória
- **Estado Inicial**: Desabilitado
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível

## 3. Critérios de Aceitação – Seção "Procedência"

### i) CPF/CNPJ Produtor Origem

- **Título**: CPF/CNPJ
- **Tipo do Campo**: Texto
- **Estado Inicial**: Vazio / Desabilitado
- **Preenchimento do Campo**: Obrigatório (Preenchimento via integração ou busca)
- **Visibilidade**: Sempre visível
- **Tamanho Máximo**: 14 caracteres (CPF) ou 18 caracteres (CNPJ)

### ii) Nome do Produtor

- **Título**: Nome do Produtor
- **Tipo do Campo**: Texto
- **Estado Inicial**: Vazio / Desabilitado
- **Preenchimento do Campo**: Automático/Visualização
- **Visibilidade**: Sempre visível

### iii) Município de Origem

- **Título**: Município
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Estado Inicial**: Desabilitado
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível

### iv) Código do Estabelecimento

- **Título**: Código do Estabelecimento
- **Tipo do Campo**: Numérico
- **Estado Inicial**: Vazio / Desabilitado
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível

### v) Nome do Estabelecimento

- **Título**: Nome do Estabelecimento
- **Tipo do Campo**: Texto
- **Estado Inicial**: Vazio / Desabilitado
- **Preenchimento do Campo**: Automático/Visualização
- **Visibilidade**: Sempre visível

### vi) Código da Exploração

- **Título**: Código da Exploração
- **Tipo do Campo**: Numérico
- **Estado Inicial**: Vazio / Desabilitado
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível

## 4. Critérios de Aceitação – Seção "Destino"

### i) CPF/CNPJ Produtor Destino

- **Título**: CNPJ/CPF Produtor
- **Tipo do Campo**: Autocomplete (Texto com sugestão)
- **Estado Inicial**: Desabilitado
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível
- **Regra de Negócio**: Ao selecionar, deve carregar as opções de estabelecimento e propriedade

### ii) Local de Destino

- **Título**: Estabelecimento / Propriedade Destino
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Lista de propriedades vinculadas ao produtor selecionado
- **Estado Inicial**: Desabilitado
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível

### iii) Exploração de Destino

- **Título**: Exploração/Aglomeração
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: Lista de explorações vinculadas à propriedade
- **Estado Inicial**: Desabilitado
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível

### iv) Município de Destino

- **Título**: Município
- **Tipo do Campo**: Texto
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Apenas visualização (Carregado automaticamente)
- **Visibilidade**: Sempre visível

## 5. Critérios de Aceitação – Seção "Dados Finais do Trânsito"

### i) Meio de Transporte Principal

- **Título**: Meio de Transporte Principal
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: RODOVIÁRIO, MARÍTIMO/FLUVIAL, FERROVIÁRIO, A PÉ, AÉREO
- **Estado Inicial**: Placeholder "SELECIONE"
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível

### ii) Meio de Transporte Secundário

- **Título**: Meio de Transporte Secundário
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: RODOVIÁRIO, MARÍTIMO/FLUVIAL, FERROVIÁRIO, A PÉ, AÉREO
- **Estado Inicial**: Placeholder "SELECIONE"
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível

### iii) Rebanho de Elite

- **Título**: Rebanho de Elite
- **Tipo do Campo**: Seleção Única (Dropdown)
- **Opções**: SIM, NÃO
- **Estado Inicial**: NÃO
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível

### iv) Data de Validade

- **Título**: Data de Validade
- **Tipo do Campo**: Data (Calendário)
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Obrigatório
- **Visibilidade**: Sempre visível

### v) Programação Início do Trânsito

- **Título**: Data e Hora Programação Início do Trânsito
- **Tipo do Campo**: Data e Hora (Calendário)
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível

### vi) Previsão Chegada

- **Título**: Data e Hora Prevista Para Chegada dos Animais
- **Tipo do Campo**: Data e Hora (Calendário)
- **Estado Inicial**: Vazio
- **Preenchimento do Campo**: Opcional
- **Visibilidade**: Sempre visível

## 6. Critérios de Aceitação – Ações

### i) Botão "Próximo"

- **Status inicial:** Habilitado
- **Tipo:** Botão
- **Preenchimento:** Texto "Próximo" com ícone de seta
- **Visibilidade:** Sempre visível
- **Ação realizada:** Valida os dados da aba atual e navega para a próxima etapa do wizard (Exigências Sanitárias).

### ii) Botão "Fechar"

- **Status inicial:** Habilitado
- **Tipo:** Botão
- **Preenchimento:** Texto "Fechar" com ícone de fechar
- **Visibilidade:** Sempre visível
- **Ação realizada:** Fecha a tela atual e retorna para a pesquisa ou tela inicial.

## 7. Requisitos considerados
- Integrar a consulta à PGA durante a entrada de gta vindo de fora de MT.