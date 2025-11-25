# Processos de Negócio: Controle de Rebanho

Este documento detalha os principais processos de negócio mapeados a partir da análise do schema SQL, com fluxos, regras e detalhes operacionais. Cada processo é acompanhado de um diagrama visual em Mermaid para facilitar o entendimento.

---

## 1. Comunicação de Nascimento

### Descrição
Processo para registrar o nascimento de animais em uma propriedade, validando permissões, saldo de matrizes e atualizando os saldos.

### Fluxo
1. Usuário solicita comunicação de nascimento.
2. Sistema valida permissões (unidade, gestor).
3. Verifica saldo apto de matrizes (faixa etária, espécie, núcleo, galpão, lote).
4. Se saldo suficiente, insere registro em `sca_comunicacao_nascimento`.
5. Atualiza saldo em `sca_saldo_estratificacao`.
6. Permite cancelamento, com atualização reversa do saldo.

```mermaid
flowchart TD
    INICIO([Início]) --> VALIDA_PERMISSAO{Permissão OK?}
    VALIDA_PERMISSAO -- Não --> FIM([Fim])
    VALIDA_PERMISSAO -- Sim --> VALIDA_SALDO{Saldo apto?}
    VALIDA_SALDO -- Não --> FIM
    VALIDA_SALDO -- Sim --> REGISTRA_NASC[Registra nascimento]
    REGISTRA_NASC --> ATUALIZA_SALDO[Atualiza saldo]
    ATUALIZA_SALDO --> FIM
```

---

## 2. Comunicação de Morte

### Descrição
Processo para registrar a morte de animais, validando permissões e saldo, e atualizando os saldos.

### Fluxo
1. Usuário solicita comunicação de morte.
2. Sistema valida permissões (unidade, gestor).
3. Verifica saldo disponível na faixa etária.
4. Se saldo suficiente, insere registro em `sca_comunicacao_morte`.
5. Atualiza saldo em `sca_saldo_estratificacao`.
6. Permite exclusão, com atualização reversa do saldo.

```mermaid
flowchart TD
    INICIO_M([Início]) --> VALIDA_PERMISSAO_M{Permissão OK?}
    VALIDA_PERMISSAO_M -- Não --> FIM_M([Fim])
    VALIDA_PERMISSAO_M -- Sim --> VALIDA_SALDO_M{Saldo disponível?}
    VALIDA_SALDO_M -- Não --> FIM_M
    VALIDA_SALDO_M -- Sim --> REGISTRA_MORTE[Registra morte]
    REGISTRA_MORTE --> ATUALIZA_SALDO_M[Atualiza saldo]
    ATUALIZA_SALDO_M --> FIM_M
```

---

## 3. Evolução de Rebanho

### Descrição
Processo para evoluir animais entre faixas etárias, validando permissões, saldo apto e carências do grupo de espécie.

### Fluxo
1. Usuário solicita evolução de rebanho.
2. Sistema valida permissões.
3. Verifica saldo apto para evolução (considerando carências).
4. Se saldo suficiente, insere registro em `sca_evolucao_rebanho` e `sca_evolucao_estratificacao`.
5. Atualiza saldo nas faixas etárias envolvidas.
6. Permite exclusão, com atualização reversa dos saldos.

```mermaid
flowchart TD
    INICIO_E([Início]) --> VALIDA_PERMISSAO_E{Permissão OK?}
    VALIDA_PERMISSAO_E -- Não --> FIM_E([Fim])
    VALIDA_PERMISSAO_E -- Sim --> VALIDA_SALDO_E{Saldo apto?}
    VALIDA_SALDO_E -- Não --> FIM_E
    VALIDA_SALDO_E -- Sim --> REGISTRA_EVOLUCAO[Registra evolução]
    REGISTRA_EVOLUCAO --> ATUALIZA_SALDO_E[Atualiza saldo]
    ATUALIZA_SALDO_E --> FIM_E
```

---

## 4. Entrada e Saída de Animais (GTA)

### Descrição
Processo para registrar entradas e saídas de animais via GTA, atualizando saldos e respeitando carências e faixas etárias.

### Fluxo
1. Usuário registra GTA de entrada ou saída.
2. Sistema valida permissões e dados.
3. Atualiza saldos em `sca_saldo_estratificacao` conforme faixas e carências.
4. Relaciona registros em `sca_gta` e `sca_estratificacao_gta`.

```mermaid
flowchart TD
    INICIO_GTA([Início]) --> REGISTRA_GTA[Registra GTA]
    REGISTRA_GTA --> ATUALIZA_SALDO_GTA[Atualiza saldo]
    ATUALIZA_SALDO_GTA --> FIM_GTA([Fim])
```

---

## 5. Atualização Manual de Saldos

### Descrição
Processo para ajuste manual de saldos por usuário autorizado, via `sca_atu_saldo_estratiticacao`.

### Fluxo
1. Usuário solicita ajuste.
2. Sistema valida permissões.
3. Insere registro de ajuste.
4. Atualiza saldo em `sca_saldo_estratificacao`.

```mermaid
flowchart TD
    INICIO_AJUSTE([Início]) --> VALIDA_PERMISSAO_AJUSTE{Permissão OK?}
    VALIDA_PERMISSAO_AJUSTE -- Não --> FIM_AJUSTE([Fim])
    VALIDA_PERMISSAO_AJUSTE -- Sim --> REGISTRA_AJUSTE[Registra ajuste]
    REGISTRA_AJUSTE --> ATUALIZA_SALDO_AJUSTE[Atualiza saldo]
    ATUALIZA_SALDO_AJUSTE --> FIM_AJUSTE
```

---

# Observações Gerais
- Todos os processos dependem de validação de permissões e regras de negócio específicas (carências, faixas, espécie, núcleo, galpão, lote).
- Cancelamentos e exclusões sempre atualizam os saldos de forma reversa.
- O controle é centralizado em saldos por faixa etária, espécie e localização.

---
