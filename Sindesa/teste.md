```mermaid
graph TD
    %% Configuração de Cores e Estilos
    classDef start fill:#d1fae5,stroke:#059669,stroke-width:2px;
    classDef end fill:#fee2e2,stroke:#dc2626,stroke-width:4px;
    classDef task fill:#fff7ed,stroke:#f59e0b;
    classDef gateway fill:#ffedd5,stroke:#f97316;

    %% Início
    A([Início: Entrada GTA Fora MT]):::start --> B;

    %% Aba 1: Identificação e Confirmação
    B{1. Aba: Identificação GTA (SINDESA / PGA)}:::task --> C{GTA Encontrada na Base?};

    %% Gateway 1: GTA Encontrada? (XOR)
    C:::gateway -->|Sim| D;
    C -->|Não| E{Cadastrar Manualmente?};
    
    %% Task: Cadastrar Manualmente (Decisão)
    E:::gateway -->|Sim| D;
    E -->|Não| F([FIM: Rejeitada]);
    
    %% Aba 2: Exigências Sanitárias e Recebimento
    D{2. Aba: Qtde Chegada e Docs}:::task --> G{Qtde Chegada <> Qtde Origem?};

    %% Gateway 2: Diferença na Quantidade (XOR)
    G:::gateway -->|Sim| H(Obrigatório Motivo da Diferença (Morte/Roubo/Não Embarque))
    H --> I;
    G -->|Não| I;

    %% Task Final: Processamento
    I((3. Confirmar Entrada, Atualizar Estoque (Entrada) e Noventena)):::task --> J;
    
    %% Fim
    J([FIM: GTA Recebida no Destino]):::end;
    F:::end;
```