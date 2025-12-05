# Estória de Usuário — Pesquisa de Comunicação de Evolução/Transferência

## Dados Gerais
- **Título da Tela:** Filtro de Pesquisa de Comunicação de Evolução/Transferência de Animais
- **Caminho (breadcrumb):** Comunicações > Comunicação de Evolução/Transferência > Pesquisa
- **EU COMO** fiscal veterinário responsável pelo acompanhamento das comunicações
- **DESEJO** localizar e validar rapidamente as comunicações registradas
- **COM O OBJETIVO** dar sequência às ações sanitárias (visualizar, cancelar, imprimir e exportar)

## Protótipo / Referência
Exibição de filtros dinâmicos no cabeçalho, botões de ação (Pesquisar, Limpar, Incluir) e painel de resultados com exportação (XLS/PDF/CSV/XML) e ações por linha (Visualizar, Cancelar, Imprimir).

## Campos
| Campo | Tipo | Opções | Estado inicial | Preenchimento | Visibilidade | Validações principais |
| --- | --- | --- | --- | --- | --- | --- |
| Adicionar filtro | Dropdown | Identificador, Produtor, Exploração, Espécie, Município, Usuário Digitação, Data da Comunicação, Situação | Placeholder “Selecionar” | Opcional | Sempre visível | Não permite filtros repetidos; deve disparar renderização do novo campo |
| Filtros ativos (dinâmicos) | Texto, Data, Combo conforme critério escolhido | Depende do critério | Desabilitado até adicionar o filtro | Condicional (obrigatório para que o filtro surta efeito) | Aparece conforme seleção | Cada tipo respeita máscara (datas, IDs, nomes) e limite de caracteres |
| Filtrar por (radio button) | Rádio | Todos os filtros / Qualquer um deles | Todos os filtros selecionado | Obrigatório | Sempre visível | Valida AND para 1ª opção e OR para a 2ª |

## Regras e Validações
- Ao clicar em “Pesquisar”, valida-se que os filtros obrigatórios adicionados estão preenchidos.
- “Limpar” remove todos os filtros, reseta o form e retorna a lista padrão.
- Permissões são checadas antes de navegar para Incluir, Visualizar, Cancelar ou Imprimir.
- Exportações respeitam os filtros aplicados e o layout “normal”.

## Botões / Ações
1. **Pesquisar** – executa a consulta com os filtros ativos e atualiza o painel `resultadoForm_resultadoForm`.
2. **Limpar** – limpa filtros (inclusive os dinâmicos) e recarrega grid sem filtros aplicados.
3. **Incluir** – direciona para `/comunicacaoevolucao/incluir?perm=incluir.comunicacaoEvolucao`.
4. **Exportar (XLS/PDF/CSV/XML)** – envia a requisição JSF correspondente para baixar os dados visíveis.
5. **Visualizar (linha)** – abre `/comunicacaoevolucao/visualizar/$?perm=pesquisar.comunicacaoEvolucao`.
6. **Cancelar (linha)** – habilitado em comunicações não canceladas; navega para `/comunicacaoevolucao/cancelar/$?perm=cancelar.comunicacaoEvolucao`.
7. **Imprimir (linha)** – invoca `imprimirComunicacaoEvolucao` e depois `null?perm=imprimir.comunicacaoEvolucao`.

## Observações
- A página precisa mostrar o título do resultado: “Resultado de Pesquisa por Comunicação de Evolução/Transferência”.
- Paginação com contador (ex.: “1 - 3 Total 3”) e opção de 10/20/50 registros.
- Colunas classificáveis por clique no cabeçalho, com ícones de ordenação.
- Botões usam ícones FontAwesome (`fa-search`, `fa-eraser`, `fa-plus`).

## Colunas exibidas no resultado
| Coluna | Descrição |
| --- | --- |
| Identificador | ID único da comunicação |
| Produtor | Nome do produtor responsável |
| Exploração | Código da exploração rural |
| Espécie | Espécie relacionada (ex.: Bovino, Equino) |
| Município do Estabelecimento Rural | Município cadastrado |
| Usuário Digitação | Nome do fiscal que registrou a comunicação |
| Data da Comunicação | Data em que foi registrada |
| Situação da Comunicação | Status (COMUNICADO, CANCELADO, etc.) |
| Ações | Botões para Visualizar, Cancelar (quando aplicável) e Imprimir |
