-- DROP FUNCTION public.fn_comunicacao_animais(text);

CREATE OR REPLACE FUNCTION public.fn_comunicacao_animais(p_json text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
/**
*************************************************
-- Data: 29/06/2023
-- Programador: Julio Jesus
-- Funcao: Realiza o processo de comunicação de nascimento e morte e devolve o JSON para montagem da grade
-- Data       	| Versao   | Autor         	| Descricao
-- 29/06/2023	| 1.0      | Julio Jesus	| Criacao da Rotina  
-- 08/10/2023	| 2.0      | Julio Jesus	| Inclusão de recurso para cancelar nascimento
-- 09/10/2023	| 3.0      | Julio Jesus	| Inclusão de recurso para excluir morte e evolução
-- 17/10/2023	| 4.0      | Julio Jesus	| Tratamento na evolução para não atualizar grupo especie bov
-- 26/01/2024	| 5.0      | Julio Jesus	| Tratamento na comunicação de saldo de outras espécies para verificar se informou núcleo ou não
-- 06/03/2024	| 6.0      | Julio Jesus	| Tratamento na ordenação
-- 02/04/2024	| 7.0      | Julio Jesus	| Tratamento na consulta de saldo com o lote
-- 12/04/2024	| 8.0      | Julio Jesus	| Tratamento na rotina de nascimento para permitir cancelamento
-- 07/11/2024	| 9.0      | Julio Jesus	| Tratamento na rotina de evolução do rebanho para utilizar o id serial da tabela de eveolução estratitifcação na ação de cancelamento
-- 08/05/2025	| 10.0     | Julio Jesus	| Tratamento na rotina de nascimento para não permitir nascimos acima da quantidade de matrizes
-- 15/07/2025	| 11.0     | Julio Jesus	| Tratamento na rotina para limitar evoluções baseado na carencia do grupo especie
-- 18/07/2025	| 12.0     | Julio Jesus	| Tratamento na rotina para limitar nascimentos baseado na carencia do grupo especie e limitações de matrizes
-- 21/07/2025	| 13.0     | Julio Jesus	| Tratamento na rotina para limitar evoluções considerando como animais carentes apenas gtas de propriedades diferentes.
-- 01/08/2025	| 14.0     | Julio Jesus	| Tratamento na rotina para validar ULE da propriedade e do usuário
-- 06/08/2025	| 15.0     | Julio Jesus	| Tratamento na rotina para evolução para abater nascimentos recentes do saldo apto
-- 13/08/2025	| 16.0     | Julio Jesus	| Tratamento na rotina para evolução chegando GTA de entrada de fora
-- 15/08/2025	| 17.0     | Julio Jesus	| Ajuste na rotina para evolução para abater nascimentos recentes do saldo apto considerando a carencia de evolução
-- 01/09/2025	| 18.0     | Julio Jesus	| Ajuste na rotina para adicionar a chamada fn_comunicacao_animais_evolucao_saldo_apto para obter o saldo apto para evolução
*************************************************
**/
DECLARE
	_REC RECORD;
	_REC_SALDOS RECORD;
	_ret text;
	_colunas text;
	_json json;
	_json_nascimento json;
	_perm_user json;	
	_id_unidade int;
	_id_ule_propriedade int;
    _id_produtor int;
    _id_exploracao int;
	_saldo_matrizes int;
    _tipo char;
    _especie int;
	_evolucao int;
    _estratificacao int;
	_estratificacao_nova int;
    _quantidade int;
	_saldo_apto int;
	_saldo_evoluido int;
	_saldo_carencia int;
	_saldo_nascimento int;
    _nucleo int;
    _galpao int;
    _lote varchar(20);
	_user_gestor BOOLEAN;
    _motivo_morte char;
    _dataini date;	
    _datafim date;		
	_aux varchar;
    _id_aux int;	
    _id_saldo_estratificacao_anterior int;	
    _id_estratificacao_anterior int;	
	_id_usuario bigint;

BEGIN
	
	-- VERIFICA DADOS DA TRANSAÇÃO
	If p_json	IS NULL Then
		RAISE EXCEPTION 'Informe os dados para processamento!';
	End if;
	_json = p_json::json;
	-- Obtem usuário
	_id_usuario = (_json->>'p_id_usuario')::int;
	-- Obtem json de permissoes do usuário
	_ret = public.fn_obter_permissao_usuario(_id_usuario::bigint);
	-- Verifica permissoes do usuário
	If _ret	IS NULL Then
		RAISE EXCEPTION 'Usuário sem permissão de acesso!';
	End if;
	_perm_user = _ret::json;
	
	-- VALIDA SE É USUÁRIO GESTOR
	SELECT 	true
	INTO 	_user_gestor
	FROM 	sca.fr_usuario_grupo 
	WHERE 	usr_codigo = _id_usuario And grp_codigo in (10);	
		
	-- OBTEM UNIDADE DE ATENDIMENTO
	_id_unidade = CASE WHEN _perm_user->>'vet' = 'true' THEN (_perm_user->>'unidade_vet_id')::int ELSE (_perm_user->>'unidade_srv_id')::int END;
	
	-- Obtem dados basicos dos parametros
    _id_produtor = (_json->>'p_id_produtor')::int;
    _id_exploracao = (_json->>'p_id_exploracao')::int;
    _id_aux = (_json->>'p_id')::int;
    _tipo = (_json->>'p_tipo')::char;
	_id_estratificacao_anterior = (_json->>'p_id_estratificacao_anterior')::int;
	
	-- OBTEM ULE DA PROPRIEDADE
	SELECT	sca_propriedade.unidade_local_id
	INTO	_id_ule_propriedade
	FROM	sca_exploracao_propriedade
		Inner Join sca_propriedade On sca_propriedade.propriedade_id = sca_exploracao_propriedade.propriedade_id
	WHERE
		sca_exploracao_propriedade.exploracao_propriedade_id::BIGINT = _id_exploracao::BIGINT;	
	
	IF _tipo = 'N' THEN -- COMUNICAÇÃO DE NASCIMENTO
		_aux = (_json->>'p_especie')::int;
		IF _aux IS NOT NULL AND _aux <> '' THEN
			_especie = (_json->>'p_especie')::int;
			_estratificacao = (_json->>'p_estratificacao')::int;
			_quantidade = (_json->>'p_quantidade')::int;
			_nucleo = (_json->>'p_nucleo')::int;
			_galpao = (_json->>'p_galpao')::int;
			_lote = (_json->>'p_lote');
			_lote = CASE WHEN _nucleo IS NULL OR ((_lote IS NULL OR _lote = ' ' OR _lote = '""' OR _lote = '')) THEN NULL ELSE _lote END;
			
			IF _especie IN (1,2) THEN	
				/*			
				IF _especie = 1 THEN
					SELECT 	SUM(sld_saldo) as saldo
					INTO _saldo_matrizes
					FROM  	
						sca_saldo_estratificacao
					WHERE 	
						exploracao_propriedade_id = _id_exploracao::INT AND
						estratificacao_id IN (8,9,10);
				ELSE
					SELECT 	SUM(sld_saldo) as saldo
					INTO _saldo_matrizes
					FROM  	
						sca_saldo_estratificacao
					WHERE 	
						exploracao_propriedade_id = _id_exploracao::INT AND
						estratificacao_id IN (18,19,20);
				END IF;
				*/
-- RAISE EXCEPTION '_id_unidade: % - _id_ule_propriedade: %', _id_unidade,_id_ule_propriedade;
				-- VALIDA SE USUÁRIO PODE COMUNICAR
				-- ULE de Origem ou Gestor
				IF _id_unidade <>_id_ule_propriedade THEN
					IF COALESCE(_user_gestor, FALSE) = FALSE THEN
						RAISE EXCEPTION 'COMUNICAÇÃO DE NASCIMENTO DEVE SER REALIZADA PELA UNIDADE DE CADASTRO!!! FAVOR ENVIAR SOLICITAÇÃO DE NASCIMENTO À UNIDADE DE CADASTRO DO ESTABELECIMENTO';
					END IF;
				END IF;					
				
				_json_nascimento = (fn_nascimento_obter_saldos_matriz(_id_exploracao::BIGINT,_especie))::json;
				-- Obtem saldo apto de matrizes
				_saldo_matrizes = (_json_nascimento->>'saldo_apto')::int;
				
				-- SE QUANTIDADE MAIOR QUE SALDO DE MATRIZES
				IF COALESCE(_saldo_matrizes,0) < _quantidade Then
					RAISE EXCEPTION 'SALDO ATUAL DE MATRIZES APTAS NÃO PERMITE COMUNICAÇÃO DO NASCIMENTO SOLICITADO';
				END IF;					
			END IF;
			
			-- INSERE COMUNICACAO DE NASCIMENTO
			INSERT INTO public.sca_comunicacao_nascimento(
				exploracao_propriedade_id, 
				produtor_id, 
				unidade_local_id, 
				especie_id, 
				estratificacao_id, 
				cna_quantidade, 
				usuario_digitacao_id, 
				cna_data_comunicacao, 
				cna_data_hora_comunicacao,
				nucleo_producao_id, 
				galpao_id, 
				can_lote)
			VALUES (_id_exploracao, _id_produtor, _id_unidade, _especie, _estratificacao, _quantidade, _id_usuario::INT, CURRENT_DATE, CURRENT_TIMESTAMP, _nucleo, _galpao, _lote);
			-- VERIFICA SE EXISTE SALDO
			SELECT 	
				saldo_estratificacao_id, COALESCE(sld_saldo,0) as saldo
			FROM  	
				sca_saldo_estratificacao
			WHERE 	
				exploracao_propriedade_id = _id_exploracao::INT AND
				estratificacao_id = _estratificacao AND				
				CASE WHEN _nucleo IS NULL THEN nucleo_producao_id is null ELSE nucleo_producao_id = _nucleo END AND
				CASE WHEN _galpao IS NULL THEN galpao_id is null ELSE galpao_id = _galpao END AND
				CASE WHEN _lote IS NULL THEN sld_lote is null ELSE sld_lote = _lote END
			INTO 	_REC_SALDOS;
			-- ATUALIZA SALDO DA EXPLORAÇÃO
			IF _REC_SALDOS.saldo_estratificacao_id IS NULL THEN
				-- INSERE SALDO
				INSERT INTO public.sca_saldo_estratificacao
				(exploracao_propriedade_id, estratificacao_id, sld_saldo, nucleo_producao_id, galpao_id, sld_lote, sld_data_atualizacao)
				VALUES 
				(_id_exploracao, _estratificacao, _quantidade, _nucleo, _galpao, _lote, NOW());

			-- ATUALIZA SALDO
			ELSIF _REC_SALDOS.saldo_estratificacao_id IS NOT NULL THEN
				-- ATUALIZA SALDO DA EXPLORAÇÃO
				UPDATE 	public.sca_saldo_estratificacao
				SET 	
					sld_saldo = _REC_SALDOS.saldo + _quantidade::INT, 
					sld_data_atualizacao = NOW()
				WHERE 	
					saldo_estratificacao_id =_REC_SALDOS.saldo_estratificacao_id;
			END IF;
		END IF;
		-- CANCELAR
		IF _id_aux IS NOT NULL AND _id_aux <> 0 THEN
			SELECT 	
				exploracao_propriedade_id,  especie_id, estratificacao_id, cna_quantidade, nucleo_producao_id, galpao_id, can_lote
			FROM 	
				public.sca_comunicacao_nascimento
			WHERE 	
				situacao_comunicacao = 1 AND 
				comunicacao_nascimento_id = _id_aux
			INTO _REC;
			
			-- VERIFICA SE COMUNICAÇÃO ESTÁ ATIVA
			IF FOUND THEN
				_id_exploracao = _REC.exploracao_propriedade_id;
				
				-- OBTEM ULE DA PROPRIEDADE
				SELECT	sca_propriedade.unidade_local_id
				INTO	_id_ule_propriedade
				FROM	sca_exploracao_propriedade
					Inner Join sca_propriedade On sca_propriedade.propriedade_id = sca_exploracao_propriedade.propriedade_id
				WHERE
					sca_exploracao_propriedade.exploracao_propriedade_id::BIGINT = _id_exploracao::BIGINT;		
--RAISE EXCEPTION 'Cancela nascimento    _id_unidade: % - _id_ule_propriedade: %', _id_unidade,_id_ule_propriedade;					
				-- VALIDA SE USUÁRIO PODE COMUNICAR
				-- ULE de Origem ou Gestor
				IF _id_unidade <>_id_ule_propriedade AND _REC.especie_id IN (1,2) THEN
					IF COALESCE(_user_gestor, FALSE) = FALSE THEN
						RAISE EXCEPTION 'CANCELAMENTO DE NASCIMENTO DEVE SER REALIZADA PELA UNIDADE DE CADASTRO!!! FAVOR ENVIAR SOLICITAÇÃO DE NASCIMENTO À UNIDADE DE CADASTRO DO ESTABELECIMENTO';
					END IF;
				END IF;				
				
				-- VERIFICA SE EXISTE SALDO
				SELECT 	
					saldo_estratificacao_id, COALESCE(sld_saldo,0) as saldo
				FROM  	
					sca_saldo_estratificacao
				WHERE 	
					exploracao_propriedade_id = _REC.exploracao_propriedade_id AND
					estratificacao_id = _REC.estratificacao_id AND
					CASE WHEN _REC.nucleo_producao_id IS NULL THEN nucleo_producao_id is null ELSE nucleo_producao_id = _REC.nucleo_producao_id END AND
					CASE WHEN _REC.galpao_id IS NULL THEN galpao_id is null ELSE galpao_id = _REC.galpao_id END AND
					CASE WHEN ((_REC.can_lote IS NULL OR _REC.can_lote = ' ' OR _REC.can_lote = '""' OR _REC.can_lote = '')) THEN sld_lote is null ELSE sld_lote = _REC.can_lote END
				INTO 	_REC_SALDOS;

				IF _REC_SALDOS.saldo >= _REC.cna_quantidade THEN

					-- ATUALIZA SALDO DA EXPLORAÇÃO
					UPDATE 	
						public.sca_saldo_estratificacao
					SET 	
						sld_saldo = _REC_SALDOS.saldo - _REC.cna_quantidade, 
						sld_data_atualizacao = NOW()
					WHERE 	
						saldo_estratificacao_id =_REC_SALDOS.saldo_estratificacao_id;	

					-- ATUALIZA NASCIMENTO PARA CANCELADO
					UPDATE 	
						public.sca_comunicacao_nascimento
					SET 	
						situacao_comunicacao = 2,
						motivo_cancelamento = ((_json->>'p_motivo_cancelamento')::int),
						data_cancelamento = NOW(),
						usuario_cancelamento_id = _id_usuario::int
					WHERE 	
						comunicacao_nascimento_id = _id_aux;
				ELSE 
					RAISE EXCEPTION 'NÃO FOI POSSÍVEL CANCELAR O NASCIMENTO. SALDO INSUFICIENTE. Saldo Atual: %! Quantidade Declarada: %', _REC_SALDOS.saldo, _REC.cna_quantidade;				
				
				END IF;
			ELSE
				RAISE EXCEPTION 'Comunicação não localizada ou já cancelada!';
			END IF;

		END IF;		
		-- Monta colunas da grade
		_colunas = 'Código;60;right;true;int;;;;Id;
@<i class="fas fa-print"></i>;50;center;true;text;;;;Print;
@<i class="fas fa-ban"></i>;50;center;true;text;;;;Cancelar;
@Dt. Inclusão;150;center;true;text;false;false;true;Data;;	
@Status;80;center;true;text;;;;Situacao;
@Espécie;80;left;true;text;false;false;true;Especie;;
@Faixa Etária;140;left;true;text;false;false;true;Estratificacao;;
@Qtde.;60;right;true;int;false;false;true;Quantidade;;
@Núcleo/Sítio;100;left;true;text;false;false;true;Nucleo;;
@Galpão;75;left;true;text;false;false;true;Galpao;;
@Lote;60;left;true;text;false;false;true;Lote;;';	
		
		-- Monta JSON de retorno
		SELECT to_json(rows)  INTO _ret
		FROM (
			SELECT COALESCE(array_to_json(array_agg(x)),'[]') As "rows"		
			FROM (
				SELECT
					sca_comunicacao_nascimento.comunicacao_nascimento_id As "Id",
					concat('<i class="fas fa-print" onclick="mkxFlowExecute(''Comunicacao de Animais - Imprimir'',[',comunicacao_nascimento_id,',1]);"></i>') as "Print", 				
					concat('<i class="fas fa-ban text-danger" onclick="mkxFlowExecute(''Comunicacao de Animais - Cancelar'',[',comunicacao_nascimento_id,',1,0]);"></i>') as "Cancelar", 								
					To_Char(sca_comunicacao_nascimento.cna_data_hora_comunicacao, 'dd/MM/yyyy HH24:MI:SS') As "Data",
					Case When sca_comunicacao_nascimento.situacao_comunicacao = 1 Then 'Comunicado' Else 'Cancelado' End As "Situacao",
					sca_especie.esp_nome As "Especie",
					Concat(sca_estratificacao.est_nome, ' - ', sca_estratificacao.sexo_id) As "Estratificacao",
					sca_comunicacao_nascimento.cna_quantidade As "Quantidade",
					sca_nucleo_producao.npr_identificacao As "Nucleo",
					sca_galpao.glp_identificacao As "Galpao",
					sca_comunicacao_nascimento.can_lote As "Lote"
				From
					sca_comunicacao_nascimento
					Inner Join sca_especie On sca_especie.especie_id = sca_comunicacao_nascimento.especie_id
					Inner Join sca_estratificacao On sca_estratificacao.estratificacao_id = sca_comunicacao_nascimento.estratificacao_id
					Left Join sca_nucleo_producao On sca_nucleo_producao.nucleo_producao_id = sca_comunicacao_nascimento.nucleo_producao_id
					Left Join sca_galpao On sca_galpao.galpao_id = sca_comunicacao_nascimento.galpao_id
				Where
					sca_comunicacao_nascimento.exploracao_propriedade_id = _id_exploracao And situacao_comunicacao = 1
				ORDER BY 1 DESC				
			) x
		) AS  rows;		
		
	ELSIF _tipo = 'M' THEN -- COMUNICAÇÃO DE MORTE

		_aux = (_json->>'p_especie')::int;
		-- INCLUIR
		IF _aux IS NOT NULL AND _aux <> '' THEN
			_especie = (_json->>'p_especie')::int;
			_estratificacao = (_json->>'p_estratificacao')::int;
			_quantidade = (_json->>'p_quantidade')::int;
			_nucleo = (_json->>'p_nucleo')::int;
			_galpao = (_json->>'p_galpao')::int;
			_lote = (_json->>'p_lote');
			_motivo_morte = (_json->>'p_motivo_morte');	
    		_dataini = (_json->>'p_data_ini');
    		_datafim = (_json->>'p_data_fim');		
			_lote = (_json->>'p_lote');
			_lote = CASE WHEN _nucleo IS NULL OR ((_lote IS NULL OR _lote = ' ' OR _lote = '""' OR _lote = '')) THEN NULL ELSE _lote END;
			
--RAISE EXCEPTION '_id_unidade: % - _id_ule_propriedade: %', _id_unidade,_id_ule_propriedade;			
			-- VALIDA SE USUÁRIO PODE COMUNICAR
			-- ULE de Origem ou Gestor
			IF _id_unidade <>_id_ule_propriedade and _especie IN (1,2) THEN
				IF COALESCE(_user_gestor, FALSE) = FALSE THEN
					RAISE EXCEPTION 'COMUNICAÇÃO DE MORTE DEVE SER REALIZADA PELA UNIDADE DE CADASTRO!!! FAVOR ENVIAR SOLICITAÇÃO DE COMUNICAÇÃO DE MORTE À UNIDADE DE CADASTRO DO ESTABELECIMENTO';
				END IF;
			END IF;				
			
			-- INSERE COMUNICACAO DE MORTE
			INSERT INTO public.sca_comunicacao_morte(
				exploracao_propriedade_id, 
				produtor_id, 
				unidade_local_id, 
				especie_id, 
				estratificacao_id, 
				cmo_quantidade, 
				usuario_digitacao_id, 
				tipo_comunicado_morte_id, 
				cmo_data_comunicacao, 
				cmo_data_comunicacao_fim,
				cmo_data_hora_comunicacao,
				nucleo_producao_id, 
				galpao_id, 
				cmo_lote)
			VALUES (_id_exploracao, _id_produtor, _id_unidade, _especie, _estratificacao, _quantidade, _id_usuario::INT, _motivo_morte, _dataini::date, _datafim::date,CURRENT_TIMESTAMP, _nucleo, _galpao, _lote);

			-- VERIFICA SE EXISTE SALDO
			SELECT 	
				saldo_estratificacao_id, COALESCE(sld_saldo,0) as saldo
			FROM  	
				sca_saldo_estratificacao
			WHERE 	
				exploracao_propriedade_id = _id_exploracao AND
				estratificacao_id = _estratificacao AND
				CASE WHEN _nucleo IS NULL THEN nucleo_producao_id is null ELSE nucleo_producao_id = _nucleo END AND
				CASE WHEN _galpao IS NULL THEN galpao_id is null ELSE galpao_id = _galpao END AND
				CASE WHEN _lote IS NULL THEN sld_lote is null ELSE sld_lote = _lote END
			INTO 	_REC_SALDOS;

			-- ATUALIZA SALDO DA EXPLORAÇÃO
			IF _REC_SALDOS.saldo_estratificacao_id IS NULL THEN
				RAISE EXCEPTION 'SALDO INEXISTENTE!';
			-- ATUALIZA SALDO
			ELSE
				IF _quantidade::INT > _REC_SALDOS.saldo::INT  THEN
					RAISE EXCEPTION 'SALDO INSUFICIENTE. Saldo Atual: %! Quantidade Informada: %', _REC_SALDOS.saldo, _quantidade;
				END IF;
				-- ATUALIZA SALDO DA EXPLORAÇÃO
				UPDATE 	public.sca_saldo_estratificacao
				SET 	
					sld_saldo = _REC_SALDOS.saldo - _quantidade, 
					sld_data_atualizacao = NOW()
				WHERE 	
					saldo_estratificacao_id =_REC_SALDOS.saldo_estratificacao_id;
			END IF;	
		END IF;
		-- REMOVER
		IF _id_aux IS NOT NULL AND _id_aux <> 0 THEN
			-- VERIFICA LANÇAMENTO DE COMUNICAÇÃO DE MORTE
			SELECT	
				exploracao_propriedade_id, 
				produtor_id, 
				especie_id, 
				estratificacao_id, 
				cmo_quantidade, 
				usuario_digitacao_id, 
				tipo_comunicado_morte_id, 
				cmo_data_comunicacao, 
				cmo_data_comunicacao_fim,
				cmo_data_hora_comunicacao,
				nucleo_producao_id, 
				galpao_id, 
				cmo_lote
			FROM 
				public.sca_comunicacao_morte
			WHERE 
				comunicacao_morte_id = _id_aux
			INTO _REC;
			
			IF FOUND THEN 
				_id_exploracao = _REC.exploracao_propriedade_id;
				
				-- OBTEM ULE DA PROPRIEDADE
				SELECT	sca_propriedade.unidade_local_id
				INTO	_id_ule_propriedade
				FROM	sca_exploracao_propriedade
					Inner Join sca_propriedade On sca_propriedade.propriedade_id = sca_exploracao_propriedade.propriedade_id
				WHERE
					sca_exploracao_propriedade.exploracao_propriedade_id::BIGINT = _id_exploracao::BIGINT;	
					
-- RAISE EXCEPTION 'Cancela morte    _id_unidade: % - _id_ule_propriedade: %', _id_unidade,_id_ule_propriedade;	

				-- VALIDA SE USUÁRIO PODE COMUNICAR
				-- ULE de Origem ou Gestor
				IF _id_unidade <>_id_ule_propriedade AND _REC.especie_id IN (1,2) THEN
					IF COALESCE(_user_gestor, FALSE) = FALSE THEN
						RAISE EXCEPTION 'CANCELAMENTO DE MORTE DEVE SER REALIZADA PELA UNIDADE DE CADASTRO!!! FAVOR ENVIAR SOLICITAÇÃO DE COMUNICAÇÃO DE MORTE À UNIDADE DE CADASTRO DO ESTABELECIMENTO';
					END IF;
				END IF;						
				
				-- VERIFICA SE EXISTE SALDO
				SELECT 	
					saldo_estratificacao_id, COALESCE(sld_saldo,0) as saldo
				FROM  	
					sca_saldo_estratificacao
				WHERE 	
					exploracao_propriedade_id = _REC.exploracao_propriedade_id AND
					estratificacao_id = _REC.estratificacao_id AND
					CASE WHEN _REC.nucleo_producao_id IS NULL THEN nucleo_producao_id is null ELSE nucleo_producao_id = _REC.nucleo_producao_id END AND
					CASE WHEN _REC.galpao_id IS NULL THEN galpao_id is null ELSE galpao_id = _REC.galpao_id END AND
					CASE WHEN ((_REC.cmo_lote IS NULL OR _REC.cmo_lote = ' ' OR _REC.cmo_lote = '""' OR _REC.cmo_lote = '')) THEN sld_lote is null ELSE sld_lote = _REC.cmo_lote END
				INTO 	_REC_SALDOS;	

				-- ATUALIZA SALDO DA EXPLORAÇÃO
				UPDATE 	
					public.sca_saldo_estratificacao
				SET 	
					sld_saldo = _REC_SALDOS.saldo + _REC.cmo_quantidade, 
					sld_data_atualizacao = NOW()
				WHERE 	
					saldo_estratificacao_id =_REC_SALDOS.saldo_estratificacao_id;				
			END IF;
			
			DELETE FROM public.sca_comunicacao_morte WHERE comunicacao_morte_id = _id_aux;
		END IF;
		
		
		-- Monta colunas da grade
		_colunas = 'Código;55;right;true;int;;;;Id;
@<i class="fas fa-print"></i>;45;center;true;text;;;;Print;
@<i class="fas fa-trash-alt"></i>;45;center;true;text;;;;Excluir;
@Dt. Inclusão;135;center;true;text;false;false;true;Data;;
@Tipo de Morte;130;center;true;text;;;;Tipo;
@Espécie;90;left;true;text;false;false;true;Especie;;
@Faixa Etária;130;left;true;text;false;false;true;Estratificacao;;
@Qtde.;55;right;true;int;false;false;true;Quantidade;;
@Núcleo/Sítio;95;left;true;text;false;false;true;Nucleo;;
@Galpão;70;left;true;text;false;false;true;Galpao;;
@Lote;55;left;true;text;false;false;true;Lote;;';

		-- Monta JSON de retorno
		SELECT to_json(rows)  INTO _ret
		FROM (
			SELECT COALESCE(array_to_json(array_agg(x)),'[]') As "rows"		
			FROM (
				SELECT
					comunicacao_morte_id As "Id",
					concat('<i class="fas fa-print" onclick="mkxFlowExecute(''Comunicacao de Animais - Imprimir'',[',comunicacao_morte_id,',2]);"></i>') as "Print",
					concat('<i class="fas fa-trash-alt text-danger" onclick="mkxFlowExecute(''Comunicacao de Animais - Cancelar'',[',comunicacao_morte_id,',2,0]);"></i>') as "Excluir",					
					To_Char(cmo_data_hora_comunicacao, 'dd/MM/yyyy HH24:MI:SS') As "Data",
					tcm_nome As "Tipo",
					sca_especie.esp_nome As "Especie",
					Concat(sca_estratificacao.est_nome, ' - ', sca_estratificacao.sexo_id) As "Estratificacao",
					cmo_quantidade As "Quantidade",
					sca_nucleo_producao.npr_identificacao As "Nucleo",
					sca_galpao.glp_identificacao As "Galpao",
					cmo_lote As "Lote"
				FROM
					sca_comunicacao_morte
					Inner Join sca_especie On sca_especie.especie_id = sca_comunicacao_morte.especie_id
					Inner Join sca_tipo_comunicado_morte On sca_tipo_comunicado_morte.tipo_comunicado_morte_id = sca_comunicacao_morte.tipo_comunicado_morte_id
					Inner Join sca_estratificacao On sca_estratificacao.estratificacao_id = sca_comunicacao_morte.estratificacao_id
					Left Join sca_nucleo_producao On sca_nucleo_producao.nucleo_producao_id = sca_comunicacao_morte.nucleo_producao_id
					Left Join sca_galpao On sca_galpao.galpao_id = sca_comunicacao_morte.galpao_id
				WHERE
					sca_comunicacao_morte.exploracao_propriedade_id = _id_exploracao
				ORDER BY 1 DESC
			) x
		) AS  rows;		
		
	ELSIF _tipo = 'A' THEN -- ATUALIZACAO DE OUTRAS ESPECIES
		_aux = (_json->>'p_especie')::int;
		IF _aux IS NOT NULL AND _aux <> '' THEN
			_especie = (_json->>'p_especie')::int;
			_estratificacao = (_json->>'p_estratificacao')::int;
			_quantidade = (_json->>'p_quantidade')::int;
			_nucleo = (_json->>'p_nucleo')::int;
			_galpao = (_json->>'p_galpao')::int;
			_lote = (_json->>'p_lote');
			_lote = CASE WHEN _nucleo IS NULL OR ((_lote IS NULL OR _lote = ' ' OR _lote = '""' OR _lote = '')) THEN NULL ELSE _lote END;
			-- INSERE ATUALIZACAO
			INSERT INTO public.sca_atu_saldo_estratiticacao(
				exploracao_propriedade_id, 
				produtor_id, 
				unidade_local_id, 
				especie_id, 
				estratificacao_id, 
				ase_saldo_atual, 
				usuario_digitacao_id, 
				ase_data_digitacao, 
				ase_data_hora_autorizacao,
				nucleo_producao_id, 
				galpao_id, 
				ase_lote)
			VALUES (_id_exploracao, _id_produtor, _id_unidade, _especie, _estratificacao, _quantidade, _id_usuario::INT, CURRENT_DATE, CURRENT_TIMESTAMP, _nucleo, _galpao, _lote);

			-- VERIFICA SE EXISTE SALDO
			SELECT 	
				saldo_estratificacao_id, COALESCE(sld_saldo,0) as saldo
			FROM  	
				sca_saldo_estratificacao
			WHERE 	
				exploracao_propriedade_id = _id_exploracao AND
				estratificacao_id = _estratificacao AND				
				CASE WHEN _nucleo IS NULL THEN nucleo_producao_id is null ELSE nucleo_producao_id = _nucleo END AND
				CASE WHEN _galpao IS NULL THEN galpao_id is null ELSE galpao_id = _galpao END AND
				CASE WHEN _lote IS NULL THEN sld_lote is null ELSE sld_lote = _lote END				
			INTO 	_REC_SALDOS;
			--RAISE EXCEPTION  'saldo_estratificacao_id,%', _REC_SALDOS.saldo_estratificacao_id;
			-- ATUALIZA SALDO DA EXPLORAÇÃO
			IF _REC_SALDOS.saldo_estratificacao_id IS NULL THEN
				IF  _quantidade::INT >= 0 THEN
					-- INSERE SALDO
					INSERT INTO public.sca_saldo_estratificacao
						(exploracao_propriedade_id, estratificacao_id, sld_saldo, nucleo_producao_id, galpao_id, sld_lote, sld_data_atualizacao)	
					VALUES 	(_id_exploracao,  _estratificacao, _quantidade, _nucleo, _galpao, _lote, NOW());
				END IF;
			-- ATUALIZA SALDO
			ELSE
				-- ATUALIZA SALDO DA EXPLORAÇÃO
				UPDATE 	public.sca_saldo_estratificacao
				SET 	
					sld_saldo = _quantidade, 
					sld_data_atualizacao = NOW()
				WHERE 	
					saldo_estratificacao_id =_REC_SALDOS.saldo_estratificacao_id;
			END IF;	
		END IF;	
		-- Monta colunas da grade
		_colunas = 'Código;60;right;true;int;;;;Id;
@Dt. Inclusão;150;center;true;text;false;false;true;Data;;	
@Usuario;100;center;true;text;;;;Usuario;
@Espécie;120;left;true;text;false;false;true;Especie;;
@Faixa Etária;180;left;true;text;false;false;true;Estratificacao;;
@Qtde.;60;right;true;int;false;false;true;Quantidade;;
@Núcleo/Sítio;100;left;true;text;false;false;true;Nucleo;;
@Galpão;75;left;true;text;false;false;true;Galpao;;
@Lote;60;left;true;text;false;false;true;Lote;;';				
		-- Monta JSON de retorno
		SELECT to_json(rows)  INTO _ret
		FROM (
			SELECT COALESCE(array_to_json(array_agg(x)),'[]') As "rows"		
			FROM (
				SELECT
					atu_saldo_estratiticacao_id As "Id",
					To_Char(ase_data_hora_autorizacao, 'dd/MM/yyyy HH24:MI:SS') As "Data",
					usr_login AS "Usuario",
					sca_especie.esp_nome As "Especie",
					Concat(sca_estratificacao.est_nome, ' - ', sca_estratificacao.sexo_id) As "Estratificacao",
					ase_saldo_atual As "Quantidade",
					sca_nucleo_producao.npr_identificacao As "Nucleo",
					sca_galpao.glp_identificacao As "Galpao",
					ase_lote As "Lote"
				FROM
					sca_atu_saldo_estratiticacao
					Inner Join sca.fr_usuario On fr_usuario.usr_codigo = sca_atu_saldo_estratiticacao.usuario_digitacao_id					
					Inner Join sca_especie On sca_especie.especie_id = sca_atu_saldo_estratiticacao.especie_id
					Inner Join sca_estratificacao On sca_estratificacao.estratificacao_id = sca_atu_saldo_estratiticacao.estratificacao_id
					Left Join sca_nucleo_producao On sca_nucleo_producao.nucleo_producao_id = sca_atu_saldo_estratiticacao.nucleo_producao_id
					Left Join sca_galpao On sca_galpao.galpao_id = sca_atu_saldo_estratiticacao.galpao_id
				WHERE
					sca_atu_saldo_estratiticacao.exploracao_propriedade_id = _id_exploracao
				ORDER BY 1 DESC				
			) x
		) AS  rows;				

	ELSIF _tipo = 'E' THEN -- EVOLUÇÃO
		_aux = (_json->>'p_especie')::int;
		IF _aux IS NOT NULL AND _aux <> '' THEN
			_especie = (_json->>'p_especie')::int;
			_estratificacao = (_json->>'p_estratificacao')::int;
			_estratificacao_nova = (_json->>'p_estratificacao_nova')::int;
			_quantidade = (_json->>'p_quantidade')::int;
			_nucleo = (_json->>'p_nucleo')::int;
			_galpao = (_json->>'p_galpao')::int;
			_lote = (_json->>'p_lote');
			_lote = CASE WHEN _nucleo IS NULL OR ((_lote IS NULL OR _lote = ' ' OR _lote = '""' OR _lote = '')) THEN NULL ELSE _lote END;
			-- VERIFICA SE EXISTE EVOLUÇÃO NA DATA ATUAL
			SELECT 	evolucao_rebanho_id 
			INTO 	_evolucao
			FROM 	sca_evolucao_rebanho
			WHERE 	exploracao_propriedade_id = _id_exploracao 
					AND produtor_id = _id_produtor 
					AND especie_id = _especie 
					AND usuario_digitacao_id = _id_usuario::INT 
					AND evr_data_evolucao = CURRENT_DATE
			LIMIT 1;					
			
			IF _evolucao IS NULL THEN -- SE NÃO EXISTE EVOLUÇÃO NA DATA ATUAL, INSERE UMA NOVA
				-- OBTEM ID DA EVOLUÇÃO
				_evolucao = nextval('sca_evolucao_rebanho_evolucao_rebanho_id_seq'::regclass);
				-- INSERE REGISTRO DE EVOLUÇÃO
				INSERT INTO public.sca_evolucao_rebanho(evolucao_rebanho_id, exploracao_propriedade_id, produtor_id, unidade_local_id, especie_id, usuario_digitacao_id, evr_data_evolucao, evr_hora_evolucao, evr_data_hora_evolucao)
				VALUES (_evolucao, _id_exploracao, _id_produtor, _id_unidade, _especie,  _id_usuario::INT, CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP);
			END IF;
			
			-- VERIFICA SE ESTRATIFICAÇÃO JÁ FOI EVOLUIDO
			SELECT 	
				evolucao_rebanho_id
			FROM  	
				sca_evolucao_estratificacao
			WHERE 	
				evolucao_rebanho_id = _evolucao AND	estratificacao_anterior_id = _estratificacao 
			INTO 	_REC_SALDOS;				

			-- VALIDA SALDO DA EXPLORAÇÃO
			IF _REC_SALDOS.evolucao_rebanho_id IS NOT NULL THEN
				IF _especie IN (1,2) THEN
					RAISE EXCEPTION 'ESTRATIFICAÇÃO JÁ EVOLUÍDA!';
				END IF;
			END IF;					
			
			-- VERIFICA SE EXISTE SALDO
			SELECT 	
				saldo_estratificacao_id, COALESCE(sld_saldo,0) as saldo
			FROM  	
				sca_saldo_estratificacao
			WHERE 	
				exploracao_propriedade_id = _id_exploracao AND
				estratificacao_id = _estratificacao AND				
				CASE WHEN _nucleo IS NULL THEN nucleo_producao_id is null ELSE nucleo_producao_id = _nucleo END AND
				CASE WHEN _galpao IS NULL THEN galpao_id is null ELSE galpao_id = _galpao END AND
				CASE WHEN _lote IS NULL THEN sld_lote is null ELSE sld_lote = _lote END				
			INTO 	_REC_SALDOS;				

			-- VALIDA SALDO DA EXPLORAÇÃO
			IF _REC_SALDOS.saldo_estratificacao_id IS NULL THEN
				IF _especie IN (1,2) THEN
					RAISE EXCEPTION 'SALDO INEXISTENTE!';
				ELSE
					RAISE EXCEPTION 'SALDO INEXISTENTE PARA O NÚCLEO/SÍTIO INFORMADO!';
				END IF;
			END IF;			
			
			--	VALIDA SALDO APTO PARA EVOLUÇÃO
			IF _especie IN (1,2) THEN
				-- OBTEM SALDO EVOLUIDO
				/*
				 ---- Descontinuado para utilizar a consulta baseada na carencia definida no cadastro do grupo especie
				SELECT 
					sum(ee.ere_quantidade)
				INTO _saldo_evoluido
				FROM 	
					sca_evolucao_rebanho er
					INNER JOIN sca_evolucao_estratificacao ee ON ee.evolucao_rebanho_id = er.evolucao_rebanho_id
				WHERE 
					er.exploracao_propriedade_id = _id_exploracao
					AND ee.estratificacao_nova_id = _estratificacao
					AND current_date - er.evr_data_evolucao < 121;
				*/
				
				-- Baseado na carencia definida no cadastro do grupo de especie
				-- DEFINE SALDO APTO (Saldo Atual - [Saldo Nascimento + Saldo Evoluido + Saldo Recebido em carência]
				_saldo_apto = public.fn_comunicacao_animais_evolucao_saldo_apto(_id_exploracao, _estratificacao);
				
				-- VALIDA SALDO APTO DA EXPLORAÇÃO
				IF _saldo_apto::INT < _quantidade::INT  THEN
					RAISE EXCEPTION 'Não há saldo disponível, pois a saldo em carência excede o saldo da faixa etária a ser evoluída!';
				END IF;
			ELSE
				-- SUINOS
				IF _REC_SALDOS.saldo::INT < _quantidade::INT  THEN
					RAISE EXCEPTION 'Não há saldo disponível para evoluir!';
				END IF;

			END IF;
			
			-- INSERE ESTRATIFICAÇÃO DA EVOLUÇÃO
			INSERT INTO public.sca_evolucao_estratificacao(
				evolucao_rebanho_id, estratificacao_anterior_id, estratificacao_nova_id, ere_quantidade, ere_tipo_saldo, nucleo_producao_id, galpao_id, ere_lote)
			VALUES (_evolucao, _estratificacao, _estratificacao_nova, _quantidade, 'N', _nucleo, _galpao, _lote);
			
			-- ATUALIZA SALDO DA EXPLORAÇÃO - ESTRATIFICACAO ANTERIOR
			UPDATE 	public.sca_saldo_estratificacao
			SET 	
				sld_saldo = _REC_SALDOS.saldo - _quantidade, 
				sld_data_atualizacao = NOW()
			WHERE 	
				saldo_estratificacao_id =_REC_SALDOS.saldo_estratificacao_id;

			-- VERIFICA SE EXISTE SALDO - ESTRATIFICACAO NOVA
			SELECT 	
				saldo_estratificacao_id, COALESCE(sld_saldo,0) as saldo
			FROM  	
				sca_saldo_estratificacao
			WHERE 	
				exploracao_propriedade_id = _id_exploracao::INT AND
				estratificacao_id = _estratificacao_nova::INT AND				
				CASE WHEN _nucleo IS NULL THEN nucleo_producao_id is null ELSE nucleo_producao_id = _nucleo END AND
				CASE WHEN _galpao IS NULL THEN galpao_id is null ELSE galpao_id = _galpao END AND
				CASE WHEN _lote IS NULL THEN sld_lote is null ELSE sld_lote = _lote END				
			INTO 	_REC_SALDOS;
			
			-- ATUALIZA SALDO DA EXPLORAÇÃO
			IF _REC_SALDOS.saldo_estratificacao_id IS NULL THEN
				-- INSERE SALDO COM A NOVA ESTRATIFICACAO
				INSERT INTO public.sca_saldo_estratificacao
				(exploracao_propriedade_id, estratificacao_id, sld_saldo, nucleo_producao_id, galpao_id, sld_lote, sld_data_atualizacao)
				VALUES 
				(_id_exploracao,  _estratificacao_nova, _quantidade, _nucleo, _galpao, _lote, NOW());

			-- ATUALIZA SALDO
			ELSIF _REC_SALDOS.saldo_estratificacao_id IS NOT NULL THEN
				-- ATUALIZA SALDO DA EXPLORAÇÃO
				UPDATE 	public.sca_saldo_estratificacao
				SET 	
					sld_saldo = _REC_SALDOS.saldo + _quantidade::INT, 
					sld_data_atualizacao = NOW()
				WHERE 	
					saldo_estratificacao_id =_REC_SALDOS.saldo_estratificacao_id;
			END IF;
		END IF;	
		
		-- REMOVER
		IF _id_aux IS NOT NULL AND _id_aux <> 0 THEN
			-- VERIFICA LANÇAMENTO DE COMUNICAÇÃO DE EVOLUÇÃO
			SELECT	
				exploracao_propriedade_id, estratificacao_anterior_id, estratificacao_nova_id, ere_quantidade, ere_tipo_saldo, nucleo_producao_id, galpao_id, ere_lote, especie_id
			FROM 
				public.sca_evolucao_estratificacao
				Inner Join sca_evolucao_rebanho On sca_evolucao_rebanho.evolucao_rebanho_id = sca_evolucao_estratificacao.evolucao_rebanho_id 
			WHERE 
			--	sca_evolucao_rebanho.evolucao_rebanho_id = _id_aux
			--	And estratificacao_anterior_id = _id_estratificacao_anterior
				evolucao_estratificacao_id = _id_aux
			INTO _REC;

			IF FOUND THEN 
				_id_exploracao = _REC.exploracao_propriedade_id;
				-- VERIFICA SE EXISTE SALDO NA ESTRATIFICAÇÃO NOVA
				SELECT 	
					saldo_estratificacao_id, COALESCE(sld_saldo,0) as saldo
				FROM  	
					sca_saldo_estratificacao
				WHERE 	
					exploracao_propriedade_id = _REC.exploracao_propriedade_id AND
					estratificacao_id = _REC.estratificacao_nova_id AND
					CASE WHEN _REC.nucleo_producao_id IS NULL THEN nucleo_producao_id is null ELSE nucleo_producao_id = _REC.nucleo_producao_id END AND
					CASE WHEN _REC.galpao_id IS NULL THEN galpao_id is null ELSE galpao_id = _REC.galpao_id END AND
					CASE WHEN ((_REC.ere_lote IS NULL OR _REC.ere_lote = ' ' OR _REC.ere_lote = '""' OR _REC.ere_lote = '') ) THEN sld_lote is null ELSE sld_lote = _REC.ere_lote END
				INTO 	_REC_SALDOS;	

				IF (_REC_SALDOS.saldo < _REC.ere_quantidade) THEN
					RAISE EXCEPTION 'Não há saldo disponível para excluir a evolução. Houve movimentação na exploração.';
				ELSE
					IF _REC.especie_id NOT IN (1,2) THEN
						-- ATUALIZA SALDO DA EXPLORAÇÃO
						UPDATE 	
							public.sca_saldo_estratificacao
						SET 	
							sld_saldo = sld_saldo - _REC.ere_quantidade, 
							sld_data_atualizacao = NOW()
						WHERE 	
							saldo_estratificacao_id =_REC_SALDOS.saldo_estratificacao_id;	

						-- OBTEM REGISTRO DE SALDO DA ESTRATIFICAÇÃO ANTERIOR
						SELECT 	
							saldo_estratificacao_id
						INTO
							_id_saldo_estratificacao_anterior
						FROM  	
							sca_saldo_estratificacao
						WHERE 	
							exploracao_propriedade_id = _REC.exploracao_propriedade_id AND
							estratificacao_id = _REC.estratificacao_anterior_id AND
							CASE WHEN _REC.nucleo_producao_id IS NULL THEN nucleo_producao_id is null ELSE nucleo_producao_id = _REC.nucleo_producao_id END AND
							CASE WHEN _REC.galpao_id IS NULL THEN galpao_id is null ELSE galpao_id = _REC.galpao_id END AND
							CASE WHEN ((_REC.ere_lote IS NULL OR _REC.ere_lote = ' ' OR _REC.ere_lote = '""' OR _REC.ere_lote = '') ) THEN sld_lote is null ELSE sld_lote = _REC.ere_lote END;	

						-- ATUALIZA SALDO DA EXPLORAÇÃO
						UPDATE 	
							public.sca_saldo_estratificacao
						SET 	
							sld_saldo = sld_saldo + _REC.ere_quantidade, 
							sld_data_atualizacao = NOW()
						WHERE 	
							saldo_estratificacao_id = _id_saldo_estratificacao_anterior;						
					END IF;
				END IF;
				--DELETE FROM public.sca_evolucao_estratificacao WHERE evolucao_rebanho_id = _id_aux And estratificacao_anterior_id = _id_estratificacao_anterior;
				DELETE FROM public.sca_evolucao_estratificacao WHERE evolucao_estratificacao_id = _id_aux;
			END IF;
		END IF;		
		-- Monta colunas da grade
		_colunas = 'ID;60;right;true;int;;true;;Id;
@Código;60;right;true;int;;;;Codigo;
@<i class="fas fa-print"></i>;50;center;true;text;;;;Print;
@<i class="fas fa-trash-alt"></i>;50;center;true;text;;;;Excluir;
@Dt. Inclusão;150;center;true;text;false;false;true;Data;;	
@Espécie;120;left;true;text;false;false;true;Especie;;
@Faixa Etária;180;left;true;text;false;false;true;Estratificacao;;
@Qtde.;60;right;true;int;false;false;true;Quantidade;;
@Núcleo/Sítio;100;left;true;text;false;false;true;Nucleo;;
@Galpão;75;left;true;text;false;false;true;Galpao;;
@Lote;60;left;true;text;false;false;true;Lote;;';				
		-- Monta JSON de retorno
		SELECT to_json(rows)  INTO _ret
		FROM (
			SELECT COALESCE(array_to_json(array_agg(x)),'[]') As "rows"		
			FROM (
				SELECT
					--concat(sca_evolucao_rebanho.evolucao_rebanho_id, '_',estratificacao_anterior_id) As "Id",
					evolucao_estratificacao_id As "Id",
					sca_evolucao_rebanho.evolucao_rebanho_id As "Codigo",
					concat('<i class="fas fa-print" onclick="mkxFlowExecute(''Comunicacao de Animais - Imprimir'',[',sca_evolucao_rebanho.evolucao_rebanho_id,',4]);"></i>') as "Print",
					concat('<i class="fas fa-trash-alt text-danger" onclick="mkxFlowExecute(''Comunicacao de Animais - Cancelar'',[',sca_evolucao_estratificacao.evolucao_estratificacao_id,',4, 0]);"></i>') as "Excluir",						
					To_Char(evr_data_evolucao, 'dd/MM/yyyy HH24:MI:SS') As "Data",
					sca_especie.esp_nome As "Especie",
					Concat(sca_estratificacao.est_nome, ' - ', sca_estratificacao.sexo_id) As "Estratificacao",
					ere_quantidade As "Quantidade",
					sca_nucleo_producao.npr_identificacao As "Nucleo",
					sca_galpao.glp_identificacao As "Galpao",
					sca_evolucao_estratificacao.ere_lote As "Lote"
				FROM
  					sca_evolucao_estratificacao 
					Inner Join sca_evolucao_rebanho On sca_evolucao_rebanho.evolucao_rebanho_id = sca_evolucao_estratificacao.evolucao_rebanho_id 
					Inner Join sca_especie On sca_especie.especie_id = sca_evolucao_rebanho.especie_id
					Inner Join sca_estratificacao On sca_estratificacao.estratificacao_id = sca_evolucao_estratificacao.estratificacao_anterior_id
					Left Join sca_nucleo_producao On sca_nucleo_producao.nucleo_producao_id = sca_evolucao_estratificacao.nucleo_producao_id
					Left Join sca_galpao On sca_galpao.galpao_id = sca_evolucao_estratificacao.galpao_id
				WHERE
					sca_evolucao_rebanho.exploracao_propriedade_id = _id_exploracao
				--ORDER BY 1 DESC
				ORDER BY evr_data_evolucao DESC
			) x
		) AS  rows;
	END IF;

	IF _ret IS NOT NULL THEN 
		_ret = FORMAT('{"%s":%s}','rows', _ret);
	ELSE
		_ret = null;
	END IF;
	_ret = _ret ||'£'||_colunas;
	-- OBTEM RETORNO
	RETURN COALESCE(_ret,'');	
END;
$function$
;
