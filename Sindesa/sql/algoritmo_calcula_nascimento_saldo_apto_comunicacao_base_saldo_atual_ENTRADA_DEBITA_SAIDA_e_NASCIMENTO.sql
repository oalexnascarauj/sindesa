
      
      WITH saldo_base AS (
    SELECT  
        exploracao_propriedade_id,
        SUM(slda.sld_saldo) AS saldo_femeas
    FROM sca_saldo_estratificacao slda
    WHERE slda.estratificacao_id IN (8,9,10,18,19,20)
      AND exploracao_propriedade_id =291097
    GROUP BY exploracao_propriedade_id
),

evolucoes AS (
  WITH
  evo_eventos AS (
    SELECT
        er.exploracao_propriedade_id,
        see.estratificacao_nova_id        AS estratificacao,
        er.evr_data_hora_evolucao         AS ts_evolucao,
        see.ere_quantidade::numeric       AS qtd_evolucao,
        LEAD(er.evr_data_hora_evolucao) OVER (
          PARTITION BY er.exploracao_propriedade_id
          ORDER BY er.evr_data_hora_evolucao
        )                                 AS ts_proxima_evolucao
    FROM public.sca_evolucao_rebanho er
    JOIN public.sca_evolucao_estratificacao see
      ON see.evolucao_rebanho_id = er.evolucao_rebanho_id
    WHERE see.estratificacao_nova_id IN (8,18)
      AND er.exploracao_propriedade_id = 291097
      AND er.evr_data_hora_evolucao >= current_timestamp - INTERVAL '90 days'
      AND er.evr_data_hora_evolucao <= current_timestamp
  ),

  mortes_por_intervalo AS (
    SELECT
        e.exploracao_propriedade_id,
        e.estratificacao,
        e.ts_evolucao,
        COALESCE(e.ts_proxima_evolucao, current_timestamp) AS ts_fim_intervalo,
        e.qtd_evolucao,
        COALESCE((
          SELECT SUM(m.cmo_quantidade)::numeric
          FROM public.sca_comunicacao_morte m
          WHERE m.exploracao_propriedade_id = e.exploracao_propriedade_id
            AND m.estratificacao_id IN (8,18)
            AND m.cmo_data_hora_comunicacao >= e.ts_evolucao
            AND m.cmo_data_hora_comunicacao <  COALESCE(e.ts_proxima_evolucao, current_timestamp)
        ), 0)::numeric AS mortes_intervalo
    FROM evo_eventos e
  ),

  saldo_intervalado AS (
    SELECT
        exploracao_propriedade_id,
        estratificacao,
        ts_evolucao,
        GREATEST(qtd_evolucao - LEAST(mortes_intervalo, qtd_evolucao), 0)::numeric AS saldo_intervalo
    FROM mortes_por_intervalo
  )

  SELECT
      s.exploracao_propriedade_id,
      SUM(s.saldo_intervalo) AS saldo_evoluido
  FROM saldo_intervalado s
  GROUP BY s.exploracao_propriedade_id
),


-- Bloco intermediário: nascimentos com checagem de saídas posteriores

nascimentos_filtrados AS (
    WITH nascimentos_base AS (
        SELECT 
            scn.exploracao_propriedade_id,
            scn.cna_data_hora_comunicacao,
            SUM(scn.cna_quantidade) AS qtd_nascimentos
        FROM sca_comunicacao_nascimento scn
        WHERE scn.estratificacao_id IN (1,2,6,7,11,12,16,17)
          AND scn.cna_data_hora_comunicacao BETWEEN current_timestamp - INTERVAL '270 days' AND current_timestamp
          AND scn.exploracao_propriedade_id =291097
          AND scn.situacao_comunicacao = 1
        GROUP BY scn.exploracao_propriedade_id, scn.cna_data_hora_comunicacao
    ),
    nascimentos_com_saida AS (
        SELECT 
            nb.exploracao_propriedade_id,
            nb.cna_data_hora_comunicacao,
            nb.qtd_nascimentos,
            COALESCE(saidas.qtd_saida, 0) AS saidas_ate_proximo
        FROM nascimentos_base nb
        LEFT JOIN LATERAL (
            SELECT SUM(seg.egt_qt_enviada) AS qtd_saida
            FROM sca_gta sg
            JOIN sca_estratificacao_gta seg ON seg.gta_id = sg.gta_id
            WHERE sg.situacao_gta_id = 'B'
              AND sg.gta_o_exploracao_id = nb.exploracao_propriedade_id
              AND sg.gta_data_emissao > nb.cna_data_hora_comunicacao
              AND sg.gta_data_emissao < COALESCE((
                  SELECT MIN(scn2.cna_data_hora_comunicacao)
                  FROM sca_comunicacao_nascimento scn2
                  WHERE scn2.exploracao_propriedade_id = nb.exploracao_propriedade_id
                    AND scn2.cna_data_hora_comunicacao > nb.cna_data_hora_comunicacao
                    AND scn2.estratificacao_id IN (1,2,6,7,11,12,16,17)
                    AND scn2.situacao_comunicacao = 1
              ), DATE '9999-12-31')
              AND seg.estratificacao_id IN (8,9,10,18,19,20)
        ) AS saidas ON TRUE
    ),
    agrupado_rn AS (
        SELECT 
            *,
            ROW_NUMBER() OVER (ORDER BY cna_data_hora_comunicacao) AS rn,
            CASE 
                WHEN LAG(saidas_ate_proximo, 1, 0::bigint) OVER (ORDER BY cna_data_hora_comunicacao) > 0 THEN 1
                ELSE 0
            END AS novo_grupo
        FROM nascimentos_com_saida
    ),
    grupos_nascimentos AS (
        SELECT 
            *,
            SUM(novo_grupo) OVER (ORDER BY rn) AS grupo_id
        FROM agrupado_rn
    ),
    -- resumo por grupo com truncamento em zero (subtotal)
    resumo_por_grupo AS (
        SELECT 
            exploracao_propriedade_id,
            MIN(cna_data_hora_comunicacao) AS inicio_grupo,
            MAX(cna_data_hora_comunicacao) AS fim_grupo,
            SUM(qtd_nascimentos) AS qtd_nascimentos,
            COALESCE(MAX(saidas_ate_proximo), 0) AS saidas_pos_nascimento,
            GREATEST(SUM(qtd_nascimentos) - COALESCE(MAX(saidas_ate_proximo), 0), 0) AS subtotal
        FROM grupos_nascimentos
        GROUP BY exploracao_propriedade_id, grupo_id
    )
    SELECT
        exploracao_propriedade_id,
        MIN(inicio_grupo) AS inicio_grupo,
        MAX(fim_grupo)    AS fim_grupo,
        -- resultado final desejado (soma dos subtotais dos grupos)
        SUM(subtotal)     AS qtd_nascimentos,
        -- permanece 0 conforme especificação
        0::bigint         AS saidas_pos_nascimento
    FROM resumo_por_grupo
    GROUP BY exploracao_propriedade_id
    ORDER BY inicio_grupo
),

-- Com o truncamento já resolvido em nascimentos_filtrados,
-- o CTE 'nascimentos' vira uma soma simples
nascimentos AS (
    SELECT 
        exploracao_propriedade_id,
        SUM(qtd_nascimentos) AS qtd_nascimento_final
    FROM nascimentos_filtrados
    GROUP BY exploracao_propriedade_id
),

        
        

-- Bloco intermediário: entrada com checagem de saídas posteriores
entradas_filtrados AS (
   with entradas_agrupados as (
SELECT 
        sg.gta_d_exploracao_id AS exploracao_propriedade_id, 
        sg.gta_data_chegada,
        SUM(seg.egt_qt_recebida) AS femeas_recebidas
    FROM sca_gta sg 
    INNER JOIN sca_estratificacao_gta seg ON seg.gta_id = sg.gta_id 
    WHERE sg.situacao_gta_id = 'B'
      AND sg.gta_data_chegada >= current_date - INTERVAL '90 days'
      AND sg.gta_data_chegada <= current_date
      AND seg.estratificacao_id IN (8,9,10,18,19,20)
      AND sg.usuario_digitacao_entrada_id IS NOT NULL
      AND sg.gta_d_exploracao_id =291097
    GROUP BY sg.gta_d_exploracao_id,sg.gta_data_chegada
    )

    SELECT 
        na.exploracao_propriedade_id,
        na.gta_data_chegada,
        na.femeas_recebidas,

        (
            SELECT COALESCE(SUM(seg.egt_qt_enviada), 0)
            FROM sca_gta sg
            INNER JOIN sca_estratificacao_gta seg ON seg.gta_id = sg.gta_id
            WHERE sg.situacao_gta_id = 'B'
              AND sg.gta_o_exploracao_id = na.exploracao_propriedade_id
              AND sg.gta_data_emissao > na.gta_data_chegada
              AND sg.gta_data_emissao < COALESCE((
                  SELECT MIN(sg2.gta_data_chegada)
                  FROM sca_gta sg2
                  INNER JOIN sca_estratificacao_gta seg2 ON seg2.gta_id = sg2.gta_id 
                  WHERE sg2.gta_d_exploracao_id = na.exploracao_propriedade_id
                    AND sg2.gta_data_chegada > na.gta_data_chegada
                    AND seg2.estratificacao_id IN (1,2,6,7,11,12,16,17)
                    AND sg2.situacao_gta_id = 'B'
              ), DATE '9999-12-31')
              AND seg.estratificacao_id IN (8,9,10,18,19,20)
        ) AS saidas_pos_entrada

    FROM entradas_agrupados na

),

entradas AS (
    SELECT 
        exploracao_propriedade_id,
        SUM(
            CASE 
                WHEN saidas_pos_entrada >= femeas_recebidas THEN 0
                ELSE femeas_recebidas - saidas_pos_entrada
            END
        ) AS qtd_femeas_entrada
    FROM entradas_filtrados
    GROUP BY exploracao_propriedade_id
)



-- Consulta Final
SELECT 
    'nascimentos' AS grupo_faixa,
    se.exploracao_propriedade_id,
    COALESCE(se.saldo_femeas, 0)
    - GREATEST(COALESCE(gtin.qtd_femeas_entrada, 0)) 
    - GREATEST(COALESCE(evo.saldo_evoluido, 0))
    - GREATEST(COALESCE(n.qtd_nascimento_final, 0)) AS saldo_estimado_futuro
FROM saldo_base se
LEFT JOIN entradas gtin ON gtin.exploracao_propriedade_id = se.exploracao_propriedade_id
LEFT JOIN evolucoes evo ON evo.exploracao_propriedade_id = se.exploracao_propriedade_id

LEFT JOIN nascimentos n ON n.exploracao_propriedade_id = se.exploracao_propriedade_id
ORDER BY grupo_faixa, exploracao_propriedade_id;
      










