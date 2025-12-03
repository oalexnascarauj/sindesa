# Regra de negócio detalhada da funcionalidade de Carência de Comunicações
Este documento apresenta uma análise detalhada dos processos de negócio relacionados à carência de comunicações, comparando o cenário atual ("ANTES") com o cenário desejável ("DEPOIS"), conforme os requisitos do documento "Travas no procedimento de evolução e nascimento". Os processos abordados incluem a Comunicação de Nascimento e a Comunicação de Evolução de Rebanho.

---

## 1. Evolução de Rebanho

### Cenário Atual (ANTES)
1. O usuário solicita a evolução de animais.
2. O sistema consulta o saldo apto por espécie/faixa etária.
3. A verificação de carência é realizada apenas por espécie, sem considerar a faixa etária.
4. Havendo saldo apto suficiente, a evolução é permitida e o saldo é atualizado.
5. Campos de saldo temporário/parcial podem ser exibidos.
6. Não há controle detalhado das datas de chegada ou evolução dos animais.

**Fluxo Simplificado:**
- Solicitação → Consulta saldo → Verificação de carência → Permissão/Recusa → Atualização de saldo

```mermaid
flowchart TD
    INICIO([Solicitação de evolução]) --> CONSULTA_SALDO([Consulta saldo apto por espécie/faixa etária])
    CONSULTA_SALDO --> VERIFICA_CARENCIA([Verifica carência por espécie])
    VERIFICA_CARENCIA --> DECISAO{Saldo apto suficiente?}
    DECISAO -- Não --> RECUSA([Recusa operação])
    DECISAO -- Sim --> PERMITE([Permite evolução])
    PERMITE --> ATUALIZA_SALDO([Atualiza saldo])
```

---

### Cenário Desejável (DEPOIS)
1. O usuário solicita a evolução de animais, informando espécie, faixa etária e quantidade.
2. O sistema consulta o saldo apto considerando espécie, faixa etária e datas de chegada/evolução.
3. A carência é verificada especificamente por faixa etária, considerando o prazo definido.
4. Para cada grupo de animais, o sistema verifica:
   - Se data de chegada + carência ≤ data atual.
   - Se data da última evolução + carência ≤ data atual.
   - Se existe GTA emitida para a mesma faixa etária, verificar se a carência de emissão da GTA também foi cumprida. Se não, encaminha para questionário e salva como "em análise".
5. Havendo saldo apto suficiente e carências cumpridas, a evolução é permitida e o saldo é atualizado.
6. Caso contrário, é exibido automaticamente um questionário de justificativa, obrigatório para prosseguir.
7. A comunicação é registrada com status "Em análise", aguardando aprovação de um servidor responsável.
8. Se aprovada, a comunicação é efetivada e os saldos são atualizados. O campo "Motivo da recusa" permanece em branco.
9. Se recusada, a comunicação é recusada e o usuário pode registrar uma nova solicitação. O servidor deve preencher obrigatoriamente o campo "Motivo da recusa".
10. Os campos de saldo temporário/parcial são removidos da interface.

**Fluxo de Comunicação de Evolução Detalhado:**
1. Usuário solicita a comunicação de evolução, informando espécie, faixa etária e quantidade.
2. O sistema consulta o saldo de rebanho apto para a faixa etária específica.
3. O sistema verifica se há carência de evolução para a faixa etária informada:
    - **Se houver carência:** 
      - Exibe questionário de justificativa obrigatório.
      - Salva a comunicação com status "Em análise".
      - Servidor responsável analisa a comunicação.
      - Se aprovada, atualiza o saldo apto.
      - Se recusada, o servidor deve obrigatoriamente preencher o campo "Motivo da recusa".
    - **Se não houver carência:** 
      - Verifica se há carência de emissão de GTA para a mesma faixa etária.
         - **Se houver carência de GTA:**
            - Exibe questionário de justificativa obrigatório.
            - Salva a comunicação com status "Em análise".
            - Servidor responsável analisa a comunicação.
            - Se aprovada, atualiza o saldo apto.
            - Se recusada, o servidor deve obrigatoriamente preencher o campo "Motivo da recusa".
         - **Se não houver carência de GTA:**
            - Permite a evolução e atualiza o saldo apto imediatamente.

```mermaid
flowchart TD
    S1([Usuário solicita comunicação de evolução<br/>Informando espécie, faixa etária e quantidade]) --> S2([Consulta saldo apto por faixa etária])
    S2 --> S3([Verifica carência de evolução])
    
    S3 --> D1{Há carência de evolução?}

    %% Ramo: Há carência de evolução
    D1 --|Sim|--> Q1([Exibe questionário de justificativa obrigatório])
    Q1 --> S4([Salva comunicação com status Em análise])
    S4 --> S5([Servidor responsável analisa comunicação])
    S5 --> D2{Aprovar comunicação?}

    D2 --|Sim|--> S6([Atualiza saldo da exploração])
    D2 --|Não|--> R1([Servidor preenche Motivo da recusa - obrigatório])
    R1 --> S7([Salva comunicação como Recusada])

    %% Ramo: Não há carência de evolução
    D1 --|Não|--> S8([Verifica carência de entrada de GTA])
    S8 --> D3{Há carência de GTA?}

    D3 --|Sim|--> Q1
    D3 --|Não|--> S6

    %% Fim
    S6 --> F1([Fim])
    S7 --> F1

```

---

## 2. Nascimento

### Cenário Atual (ANTES)
1. O usuário solicita o registro de nascimento.
2. O sistema consulta o saldo de matrizes (fêmeas ≥ 13-24 meses).
3. O nascimento é permitido até o limite do saldo de matrizes.
4. A carência é genérica, não vinculada à data de chegada/evolução.

**Fluxo Simplificado:**
- Solicitação → Consulta matrizes → Permissão/Recusa → Atualização de saldo

```mermaid
flowchart TD
    INICIO_N([Solicitação de nascimento]) --> CONSULTA_MATRIZES([Consulta saldo de matrizes])
    CONSULTA_MATRIZES --> DECISAO_N{Saldo de matrizes suficiente?}
    DECISAO_N -- Não --> RECUSA_N([Recusa operação])
    DECISAO_N -- Sim --> PERMITE_N([Permite nascimento])
    PERMITE_N --> ATUALIZA_SALDO_N([Atualiza saldo de matrizes])
```

---

### Cenário Desejável (DEPOIS)
1. O usuário solicita o registro de nascimento, informando espécie, faixa etária e quantidade.
2. O sistema consulta matrizes aptas, considerando carência específica por faixa etária.
3. Para cada matriz, verifica se data de chegada + carência ≤ data atual.
4. Verifica se existe GTA emitida para a mesma faixa etária. Se houver, verifica se a carência de emissão da GTA foi cumprida. Se não, encaminha para questionário e salva como "em análise".
5. O nascimento é permitido apenas se a quantidade solicitada for menor ou igual ao número de matrizes aptas e todas as carências cumpridas.
6. Caso contrário, é exibido automaticamente um questionário de justificativa, obrigatório para prosseguir.
7. A comunicação é registrada com status "Em análise", aguardando aprovação de um servidor responsável.
8. Se aprovada, a comunicação é efetivada e os saldos são atualizados. O campo "Motivo da recusa" permanece em branco.
9. Se recusada, a comunicação é recusada e o usuário pode registrar uma nova solicitação. O servidor deve preencher obrigatoriamente o campo "Motivo da recusa".
10. O saldo de matrizes aptas é atualizado após o nascimento.

**Fluxo de Comunicação de Nascimento Detalhado:**
1. Usuário solicita a comunicação de nascimento.
2. O sistema consulta o saldo de rebanho de matrizes aptas, ou seja, na faixa etária específica.
3. Há matrizes aptas suficientes para o nascimento solicitado?
    - **Se não houver matrizes aptas suficientes:**
      - Leva ao questionário de justificativa obrigatório.
      - Salva a comunicação com status "Em análise".
      - Servidor responsável analisa a comunicação.
        - Se aprovada, atualiza o saldo apto.
        - Se recusada, o servidor deve obrigatoriamente preencher o campo "Motivo da recusa".
      - Encerra o processo.
    - **Se houver matrizes aptas suficientes:**
      - Verifica se há GTA emitida para as matrizes usadas no nascimento.
         - **Se não houver GTA emitida:**
           - Permite o nascimento.
           - Salva a comunicação de nascimento.
           - Finaliza o processo.
         - **Se houver GTA emitida:**
           - Verifica se a carência de emissão da GTA das matrizes foi cumprida.
              - **Se a carência não foi cumprida:**
                - Leva ao questionário de justificativa obrigatório.
                - Salva a comunicação com status "Em análise".
                - Servidor responsável analisa a comunicação.
                  - Se aprovada, atualiza o saldo apto.
                  - Se recusada, o servidor deve obrigatoriamente preencher o campo "Motivo da recusa".
                - Finaliza o processo.
              - **Se a carência foi cumprida:**
                - Permite o nascimento.
                - Salva a comunicação de nascimento.
                - Atualiza o saldo de matrizes aptas.
                - Finaliza o processo.
                

```mermaid
flowchart TD
    S1([Usuário solicita comunicacao de nascimento]) --> S2([Consulta saldo de rebanho de matrizes aptas por faixa etaria])
    S2 --> D1{Ha matrizes aptas suficientes?}
    D1 --|Nao|--> Q1([Exibe questionario de justificativa obrigatorio])
    Q1 --> S4([Salva comunicacao com status Em analise])
    S4 --> S5([Servidor responsavel analisa comunicacao])
    S5 --> D2{Aprovar comunicacao?}
    D2 --|Sim|--> S6([Atualiza saldo apto])
    D2 --|Nao|--> R1([Servidor preenche Motivo da recusa obrigatorio])
    R1 --> S7([Salva comunicacao como Recusada])
    S6 --> F1([Fim])
    S7 --> F1
    D1 --|Sim|--> S8([Verifica se existe GTA emitida para as matrizes usadas no nascimento])
    S8 --> D3{GTA emitida?}
    D3 --|Nao|--> S9([Permite nascimento e salva comunicacao de nascimento])
    S9 --> F1
    D3 --|Sim|--> S11([Verifica carencia de emissao da GTA das matrizes])
    S11 --> D4{Carencia de GTA cumprida?}
    D4 --|Nao|--> Q1
    D4 --|Sim|--> S9
```

---

# Observações Gerais

- Todas as regras de carência devem ser aplicadas considerando espécie, faixa etária e quantidade.
- O sistema deve registrar e consultar datas de chegada, evolução e nascimento para garantir precisão no cálculo do saldo apto.
- Mensagens de bloqueio devem ser claras e orientativas, promovendo transparência ao usuário.
- O processo de comunicação em análise garante maior controle e rastreabilidade das exceções, fortalecendo a governança dos procedimentos.
- O campo "Motivo da recusa" é obrigatório sempre que houver recusa de comunicação em análise.

---
