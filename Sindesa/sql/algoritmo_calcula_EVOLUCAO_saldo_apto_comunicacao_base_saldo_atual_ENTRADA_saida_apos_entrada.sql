WITH params AS (
  SELECT 30919::int AS exploracao_id, 7::int AS estratificacao
),

-- Saldo atual na faixa
saldo_atual AS (
  SELECT
    p.exploracao_id,
    p.estratificacao,
    COALESCE(SUM(s.sld_saldo),0)::numeric AS saldo
  FROM params p
  JOIN sca_saldo_estratificacao s
    ON s.exploracao_propriedade_id = p.exploracao_id
   AND s.estratificacao_id        = p.estratificacao
  GROUP BY 1,2
),

-- Evoluído recentemente (limita carência a 10 dias)
evoluido AS (
  SELECT
    p.exploracao_id,
    p.estratificacao,
    COALESCE(SUM(ee.ere_quantidade),0)::numeric AS qtd
  FROM params p
  JOIN sca_evolucao_rebanho er  ON er.exploracao_propriedade_id = p.exploracao_id
  JOIN sca_evolucao_estratificacao ee ON ee.evolucao_rebanho_id = er.evolucao_rebanho_id
  JOIN sca_especie es           ON es.especie_id = er.especie_id
  JOIN sca_grupo_especie ge     ON ge.grupo_especie_id = es.grupo_especie_id
  WHERE ee.estratificacao_nova_id = p.estratificacao
    AND (current_date - er.evr_data_evolucao) 
        < LEAST(COALESCE(ge.gre_carencia_evolucao,0), 0)
  GROUP BY 1,2
),
-- Recebidos recentes (ENTRADAS LÍQUIDAS de saídas entre chegadas)
recebido_carencia AS (
  SELECT 
      p.exploracao_id,
      p.estratificacao,
      SUM(sub.total_liquido)::numeric AS qtd
  FROM params p
  CROSS JOIN LATERAL (
      SELECT 
          g.gta_data_chegada,
          GREATEST(
              SUM(COALESCE(seg.egt_qt_recebida, 0))
              -
              COALESCE((
                  SELECT SUM(COALESCE(seg_out.egt_qt_enviada, 0))
                  FROM sca_gta g_out
                  JOIN sca_estratificacao_gta seg_out 
                    ON seg_out.gta_id = g_out.gta_id
                  WHERE g_out.situacao_gta_id = 'B'
                    AND g_out.gta_o_exploracao_id = p.exploracao_id
                    AND seg_out.estratificacao_id = p.estratificacao
                    AND COALESCE(g_out.gta_d_estabelecimento_id, 0) 
                        <> COALESCE(g_out.gta_o_estabelecimento_id, 0)
                    AND g_out.gta_data_emissao > g.gta_data_chegada
                    AND g_out.gta_data_emissao < COALESCE((
                        SELECT MIN(g_next.gta_data_chegada)
                        FROM sca_gta g_next
                        JOIN sca_estratificacao_gta seg_next 
                          ON seg_next.gta_id = g_next.gta_id
                        WHERE g_next.situacao_gta_id = 'B'
                          AND g_next.gta_d_exploracao_id = p.exploracao_id
                          AND seg_next.estratificacao_id = p.estratificacao
                          AND g_next.gta_data_chegada > g.gta_data_chegada
                    ), DATE '9999-12-31')
                  ), 0)
          , 0) AS total_liquido
      FROM sca_estratificacao_gta seg
      JOIN sca_gta g ON g.gta_id = seg.gta_id
      JOIN sca_grupo_especie ge ON ge.grupo_especie_id = g.grupo_especie_id
      WHERE seg.estratificacao_id = p.estratificacao
        AND g.gta_d_exploracao_id = p.exploracao_id
        AND g.situacao_gta_id = 'B'
        AND g.gta_data_chegada IS NOT NULL
        AND COALESCE(g.gta_d_estabelecimento_id, 0) 
            <> COALESCE(g.gta_o_estabelecimento_id, 0)
        AND g.gta_data_chegada >= (CURRENT_DATE - (ge.gre_carencia_evo_gta_matriz || ' days')::INTERVAL)
      GROUP BY g.gta_data_chegada
  ) sub
  GROUP BY p.exploracao_id, p.estratificacao
),


-- Nascimentos na carência (limita a 10 dias)
nascimentos_carencia AS (
  SELECT
    p.exploracao_id,
    p.estratificacao,
    COALESCE(SUM(n.cna_quantidade),0)::numeric AS qtd
  FROM params p
  JOIN sca_comunicacao_nascimento n ON n.estratificacao_id = p.estratificacao
  JOIN sca_especie es               ON es.especie_id = n.especie_id
  JOIN sca_grupo_especie ge         ON ge.grupo_especie_id = es.grupo_especie_id
  WHERE n.exploracao_propriedade_id = p.exploracao_id
    AND n.situacao_comunicacao = 1
    AND n.cna_data_hora_comunicacao BETWEEN
        ( current_timestamp 
          - ( LEAST(COALESCE(ge.gre_carencia_evolucao,0),0) || ' days')::interval )
        AND current_timestamp
  GROUP BY 1,2
)

SELECT
  p.exploracao_id,
  GREATEST(
    COALESCE(sa.saldo,0)
    - ( COALESCE(nc.qtd,0) + COALESCE(ev.qtd,0) + COALESCE(rc.qtd,0) ),
    0
  ) AS saldo_apto,
  COALESCE(sa.saldo,0) AS saldo_atual,
  COALESCE(nc.qtd,0)   AS nascimentos_carencia,
  COALESCE(ev.qtd,0)   AS evoluido_carencia,
  COALESCE(rc.qtd,0)   AS recebidos_carencia
FROM params p
LEFT JOIN saldo_atual         sa ON sa.exploracao_id = p.exploracao_id AND sa.estratificacao = p.estratificacao
LEFT JOIN nascimentos_carencia nc ON nc.exploracao_id = p.exploracao_id AND nc.estratificacao = p.estratificacao
LEFT JOIN evoluido            ev ON ev.exploracao_id = p.exploracao_id AND ev.estratificacao = p.estratificacao
LEFT JOIN recebido_carencia   rc ON rc.exploracao_id = p.exploracao_id AND rc.estratificacao = p.estratificacao;
