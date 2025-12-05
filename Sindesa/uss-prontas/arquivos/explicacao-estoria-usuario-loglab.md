Estória de Usuário Estória do Usuário 

Versão do template: 1.0 

2

REGISTRO DE ALTERAÇÕES DO DOCUMENTO 

Versão  Data  Assinatura  Descrição 

1.0  25/03/2024  Kerollaine Ribeiro  Criação do Documento 

2.0  20/11 /2024  Mônica Jabur  Atualização de documento Estória do Usuário  

> Versão do template: 1.0

3

SUMÁRIO 

Sumário ................................ ................................ ................................ ................................ ................................ ..... 3

1.  Modelo de Estória de Usuário ................................ ................................ ................................ ........................ 4

Onde Armazenar ................................ ................................ ................................ ................................ ...................... 4

Descrição de Estórias de Usuário ................................ ................................ ................................ .......................... 4

Protótipo de Tela ................................ ................................ ................................ ................................ ...................... 4

Critérios de Aceitação ................................ ................................ ................................ ................................ .............. 4

Título da Tela ................................ ................................ ................................ ................................ ........................ 4

Caminho de navegação (breadcrumb) ................................ ................................ ................................ ...................... 4

Campos ................................ ................................ ................................ ................................ ................................ .. 4

Regras / validações / AÇÕES não relacionadas apenas a um campo ................................ ................................ ........ 5

Botões (Ações) ................................ ................................ ................................ ................................ ....................... 6

Observações ................................ ................................ ................................ ................................ ........................... 6

2.  Estória do usuário Story point (sp) 1 ................................ ................................ ................................ .............. 8

3.  Estória de usuário story point (sp) 2 ................................ ................................ ................................ .............. 9

4.  Estória de usuário story point (sp) 3 ................................ ................................ ................................ ........... 11 

5.  Estória de usuário story point (sp) 5 ................................ ................................ ................................ ............ 13 

6.  Estória de usuário story point (sp) 8 ................................ ................................ ................................ ............ 15 

7.  Estoria de usuário story point (sp) 13 ................................ ................................ ................................ .......... 18 Estória do Usuário  

> Versão do template: 1.0

4

1.  MODELO  DE ESTÓRIA DE USUÁR IO 

ONDE ARMAZENAR 

 Criar no Azure do Projeto um Work Item do Tipo User Story ou equivalente. 

DESCRIÇÃO  DE ESTÓRI AS DE USUÁRIO 

 Título da História de Usuário deve ser claro. 

 EU COMO: descrever a persona do usuário que solicita a funcio nalidade ou parte da 

funcionalidade em questão (perfil do usuário e seu papel); 

 DESEJO: descrever a necessidade do usuário do sistema que resulta nesta estória ( finalidade ou 

funcionalidade); 

 COM O OBJETIVO: descrever o objetivo a ser atingido pelo usuá rio ao executar a funcionalidade e 

que o motiva a solicitá -la (benefício ou resultado desejado); 

PROTÓTIPO DE TELA 

 O protótipo de tela deve sempre ser construído, apenas não sendo necessário quando estamos 

falando de estórias de usuário de API ou procedure de banco ou outra ação semelhante. 

CRITÉRIOS DE ACEITAÇ ÃO 

TÍTULO DA TELA 

 Apresentar o Título da Tela, caso seja uma tela. 

CAMINHO DE NAVEGAÇÃO  (BREADCRUMB) 

 Apresentar o Caminho de Navegação para chegar ao recurso. Normalmente são os Menus do 

sistemas ou botões na tela. 

CAMPOS 

 Listar todos os Campos que: 

o Devem aparecer na tela; 

o Ou são afetados (alterados) mesmo sem aparecer; 

o Ou que seja Input da API ou Procedure. Estória do Usuário  

> Versão do template: 1.0

5

 Para cada um dos campos colocar as seguintes informações, quando aplicável em cada contexto: 

o Título: Deixar claro o Alias/Label do Campo, isso é o nome Correto que o campo deve ter. 

o Tipo do Campo: Texto, Número Inteiro, Número Decimal, Booleano, Data, Hora, Data/Hora. 

o Opções: Descrever as opções de preenchimento, se houver. Por exemplo, no Campo de 

Seleção Única (combo box) e Campo de Seleção Múltipla (combo box), informar de onde 

provêm as opções (objeto/entidade ou tabela). 

o Seleção: informar se pode selecionar uma ou mais de uma das opções. 

o Estado inicial: informar o estado “default”, por exemplo, se haverá um placeholder com 

“Selecione” e se o campo estará desabilitado. 

o Preenchimento do Campo: Apenas visualização, Opcional, Obrigatório ou Condicionado 

(isto é, obrigatório somente se algo acontecer). 

o Visibilidade: sempre visível na tela ou aparece de acordo com alguma condição? 

 Para cada um dos campos, também deve -se analisar algumas validações básicas: 

o Tamanho Mínimo: informar no caso de Texto. 

o Tamanho Máximo: informar no caso de Texto. 

o Valor Mínimo: opcional para Data e números. 

o Valor Máximo: opcional para Data e números. 

o Valor Mínimo ou Máximo condicional a outro campo: opcional para Data e números, comum 

em telas com campos Data de Início e Data de Fim, onde Data de Fim deve ser maior que 

Data de Início. 

o Valor Único: Informar se o cam po deve ter valor único e não pode ser repetido. 

o Lista de Valores Permitidos: Apresentar Valores permitidos, como, por exemplo, Categoria 

de Carteira de Motoristas, podendo ser apenas A, B, C, D e E. 

o Validação de Formato: se o campo deve seguir algum forma to/máscara, como CEP, CPF, 

CNPJ, etc. 

o Valor de Preenchimento Automático / Regra: apresentar a forma que um campo será 

preenchido automaticamente. Ex: data do dia, multiplicação entre campos, etc. 

o Validações Extras para os Campos: apresentação se possui alguma validação extra para o 

campo. 

REGRAS / VALIDAÇÕES  / AÇÕES NÃO RELACION ADAS APENAS A UM CAM PO Estória do Usuário  

> Versão do template: 1.0

6

 Listar as Regra / Validações / Ações que normalmente são mais complexas, pois utilizam mais de 

um campo ou mais de uma entidade/objeto. Neste tópico, lembra r de deixar clara a mensagem de 

erro a ser apresentada, pois, muito provavelmente, serão mensagens não contidas ainda na 

documentação básica do sistema. Normalmente, essas regras, validações ou ações são realizadas 

ao final da ação. 

BOTÕES (AÇÕES) 

 Listar t odos os botões/ações que deve haver, informando: 

o Nome/Label do Botão; 

o Classificar Tipo Ação: Link (acesso simples, como botão de cancelar), Ação Apenas em 

Tela (editando sub -entidades), Ações Práticas 

o Ação a ser realizada; 

o Para onde deverá ser encaminhada a tela; 

o Informar Regras/Validações que devem ser executadas, apenas em casos menos 

convencionais, pois um Salvar/Cadastrar normalmente deve executar todas as validações. 

OBSERVAÇÕES 

 É comum algumas telas possuírem gerenciamento de sub -entidades (Exemplo: u ma pessoa 

possuir uma entidade de contatos (com tipo e texto) e possuir endereço (tipo, rua, número, cidade, 

estado, cep, etc.). Nestes casos, é necessário apresentar os campos, mostrando claramente que é 

uma sub -entidade e também os botões ou ações que es tão relacionados a essas sub -entidades. 

 É relevante informar que não é necessário descrever as mensagem de erro para cada um dos tipos 

padrões de erros, pois os principais frameworks possuem um padrão para isso, que pode ser 

customizado no projeto ou os pr ojetos normalmente têm uma lista de erros que englobam essas 

validações mais simples, como Formato do Campo, Tamanho do Campo, Campo Único, etc. 

 Critérios a serem utilizados na criação e análise da história: 

o Deve agregar valor ao usuário. 

o Deve ter um obje tivo claro e sucinto. 

o Deve ser possível de estimar com precisão pelo time. 

o Deve ser testável e validável; 

o Conferir se COMO, DESEJO e OBJETIVO estão relacionados com os critérios de 

aceitação. 

o A história deve ser uma ação completa, seja uma alteração, seja uma construção. Estória do Usuário 

Versão do template: 1.0 

7Estória do Usuário  

> Versão do template: 1.0

8

2.  EST ÓRIA DO USUÁRIO  STORY  POINT  (SP) 1 

[Inserir Protótipo] 

## Menu de acesso a rotina:  Cadastro> Matriz Estruturante> 

Parametrização de  Modelos de Matriz Estruturante ( botão Ativar/Inativar) 

Critério de aceitação 1: 

 Se o usuário clicar em  ATIVAR/INATIVAR  o sistema deverá trazer um modal com a 

mensagem ” Confirma a Alteração de Status do Modelo de Matriz Estruturante? ” Caso o 

usuário  clique em  SIM , o sistema altera o status do registro. 

 Se o usuário clicar  CANCELAR  o sistema fecha o modal e retorna a tela de consulta. 

 O sistema deve registrar no histórico a ação do usuário    

> EU COMO [Tipo do usuário]
> DESEJO [Algum recurso; ação]
> COM O OBJETIVO
> [Benefício; valor ]

# Estória do Usuário  

> Versão do template: 1.0

9

3.  EST ÓRIA DE USUÁRIO STORY  POINT (SP) 2 

[Inserir Protótipo] 

## Menu de acesso a rotina:  Lançamentos> 

# Lançamento/Justificativa de Faltas>  Justificativa de 

# Faltas/Atestado  - Excluídos ;

Critério de aceitação 1: 

 O Título  da tela deverá ser:  Justificativa de Faltas/Atestado  - Excluidos ;     

> EU COMO [Tipo do usuário]
> DESEJO [Algum recurso; ação]
> COM O OBJETIVO [Benefício; valor ]

# Estória do Usuário  

> Versão do template: 1.0

10 

 O sistema deve controlar o ano logado; 

Critério de aceitação 2: 

 Deverá conter os seguintes filtros de consulta:  ANO, UNIDADE ESCOLAR, ALUNO e 

TURMA; 

 O filtro de consulta poderá ser  realizado pelos campos  UNIDADE ESCOLAR, ALUNO e 

TURMA , sendo o mesmo de seleção (combo), após filtrar o campo sistema carrega as 

informações na grid abaixo. 

 Pelo menos um dos campos de pesquisa deve ser preenchido para a seleção das 

informações na grid; 

 A Grid deverá mostrar as seguintes colunas:  UNIDADE, ALUNO, TURMA. 

DATAS(INICIO  – FIM) DATA EXCLUSÃO e USUÁRIO EXCLUSÃO; 

 O sistema deve paginar caso haja mais de 10 registros na consulta. 

 O sistema deve exibir a quantidade de registros que possui abaixo da  grid(tabela). 

 sistema deve verificar se existe algum vínculo, caso não existe vai deletar o registro. Se 

o usuário clicar  CANCELAR  o sistema fecha o modal e retorna a tela de consulta. Estória do Usuário 

Versão do template: 1.0 

11 

4.  EST ÓRIA DE USUÁRIO STORY  POINT (SP)  3

[Inserir Protótipo] 

## Menu de acesso a rotina:  Manutenção> Atribuição>Atribuição de 

## Servidores>Botão Atribuir> Botão Alterar ;

Critério de Aceitação 1: 

EU  COMO  [Tipo do  usuário] 

DESEJO  [Algum recurso; ação] 

COM O OBJETIVO  [Benefício; valor ] Estória do Usuário  

> Versão do template: 1.0

12 

o No  fieldset  "Servidor "

 Remover o campo  MATRICULA 

 Remover o campo  CARGO 

 Remover o campo  HABILITAÇÃO 

o Criar o  fieldset  "Vinculo Servidor "

 O campo  MATRICULA  deve ser somente leitura 

 O campo  CARGO  deve ser somente leitura 

 O campo  HABILITAÇÃO  deve ser somente leitura 

 O campo  TIPO  DE SERVIDOR  deve ser somente leitura 

 O campo  SITUAÇÃO FUNCIONAL  deve ser somente leitura 

Critério de Aceitação 2: 

 Ao entrar na funcionalidade o campo  "HABILITAÇÃO"  deve ser  OCULTADO  se 

o CARGO  for  diferente  de  PROFESSOR .

Critério de aceitação 3: 

 Ao selecionar o campo  HABILITAÇÃO  e este estiver  vazio, ao clicar em  salvar  o sistema 

deve emitir uma mensagem indicando que é obrigatório o preenchimento: 

o Cadastro incompleto! Por favor cadastre a Habilitação do servidor em: 

Manutenção > Servidor > Vínculo ( botão Alterar). Estória do Usuário 

Versão do template: 1.0 

13 

5.  EST ÓRIA DE USUÁRIO STORY  POINT (SP) 5 

[Inserir Protótipo] 

EU  COMO  [Tipo do usuário] 

DESEJO  [Algum recurso; ação] 

COM O OBJETIVO  [Benefício; valor ] Estória do Usuário  

> Versão do template: 1.0

14 

Menu de Acesso a Rotina > Configurações>>Matweb>>Protegido por Lei>> Botão 

CADASTRO 

Critério de aceitação 1:  Validar CPF  

> 

Ao clicar no botão  CADASTRO ( registro NOVO):  . 

> o

Se o número do CPF não for vazio (000.000.000 -00), o sistema deve validar se o CPF 

informado já existe.  

> 

Se existir um cadastro para o CPF informado, o sistema de ve apresentar a 

mensagem: "Atenção! Já existe cadastro para o CPF informado, favor 

verifique." e não permitir prosseguir com o cadastro . 

> 

Caso o número não exista, o sistema deve permitir prosseguir com o cadastro 

normalmente.  

> o

No campo TIPO DE CERTIDÃO inserir a seguinte validação:  

> 

Se no campo DATA DE NASCIMENTO o valor informado for maior 

que 02/03/2019 , o campo deverá vir preenchido por default com a

opção Certidão Nova (Nº Matrícula) e não permitir que o usuário selecione a 

outra. // utilizar a mes ma regra existente para cadastro de 

dependente  #38386  . 

> o

Não deverá permitir informar  certidão de nascimento já cadastrada . // Utilizar a 

mesma regra  existente  para o cadastro de aluno  (https://gestor -

educacao.loglabprojetos.com.br/aluno ) 

> 

Se existir a certidão, aprensentar a mensagem "  O número de Certidão já se 

encontra in formada para  Cod.Pessoa Fisica  - << cód. da pessoa>>/<< Nome 

da pessoa física>> . Favor verifique!  

> 

Caso contrário, permitir  SALVAR  normalmente .

Critério de aceitação 2: Carregar Campos do Fieldset CRIANÇA Estória do Usuário  

> Versão do template: 1.0

15  

> 

Se o cadastro for originado a partir do PRÉ CADASTRO MATRICULA WEB (#102801  ), o 

sistema deve carregar preenchidos os campos do Fieldset CRIANÇA.  

> 

Todos os campos do Fieldset CRIANÇA devem estar em modo de leitura (somente leitura).  

> 

Os demais campos devem permitir o preenchimento normal. 

Critério de aceitação 3: Validação do Campo ANO/FASE  

> 

Para os registros originados do PRÉ CADASTRO MATRICULA WEB oo 

campo ANO/FASE deverá se r criada a validação conforme situação de Matricula do 

aluno  #81596  , utilizando a regra de verificação da idade da criança:  

> o

Verificar a Idade do Aluno (Data Atual – Data de Nascimento).  

> o

Com base na idade do aluno, verificar em qual ANO/FASE ele se encontra.  

> o

Mostrar na droplist somente o ANO/FASE - TURMA correspondente à idade.  

> 

Para os regstros novos ( critério 1), manter a regra existente - listar todo s os anos/fase 

na droplist normalmente. 

Critério de aceitação 4: Manutenção de Campos e Regras Existentes  

> 

Padronizar o tamanho da tela para XXL  

> 

Todos os outros campos e regras existentes no sistema devem ser mantidos como estão. 

Critério de aceitação 5:  

> 

As validações citadas [ CRITÉRIO 1, 2, e 3] deverá serem aplicadas também para a tela 

de PRÉ CADASTRO DA CRIANÇA ( ao consultar) >> ação ABRIR .

6.  EST ÓRIA DE USUÁRIO STORY  POINT (SP) 8 Estória do Usuário 

Versão do template: 1.0 

16 

[Inserir Protótipo] 

Menu de acesso a rotina:  Movimentação> Aluno> Projeto Quem falta faz falta> Consultar 

Alunos Projeto (botão Imprimir> Selecionar tipo de Relatório = “PDF”) 

Critério de aceitação 1: 

 Deverá conter  O CABEÇALHO , contendo os seguintes campos: 

 BRASÃO MUNICIPAL; 

o Imagem cadastrada em  Configurações  -> Brasão Municipal ;

o Canto superior esquerdo. 

EU  COMO  [Tipo do usuário] 

DESEJO  [Algum recurso; ação] 

COM O OBJETIVO  [Benefício; valor ] Estória do Usuário  

> Versão do template: 1.0

17  

> 

PREFEITURA MUNICIPAL DE CUIABÁ;  

> 

SECRETARIA MUNICIPAL DE EDUCAÇÃO;  

> 

RELATÓRIO DE FALTAS  - ANO LETIVO LOGADO 

Critério de  aceitação 2:  

> 

O cabeçalho deve aparecer em todas as páginas que forem geradas. 

Critério de aceitação 3:  

> 

O sistema deve trazer as informações conforme foi selecionado no filtro para impressão do 

relatório, o sistema vai mostrar aba  IDENTIFICAÇÃO , contendo os  seguintes campos;  

> 

BIMESTRE:  Bimestre selecionado no filtro do relatório;  

> 

REGIÃO:  Nome da Região selecionada ou em Branco quando não selecionado;  

> 

TIPO DE UNIDADE:  Tipo de Unidade selecionada ou em Branco quando não selecionado;  

> 

UNIDADE:  Tipo de Unidade sel ecionada ou em Branco quando não selecionado; 

Critério de aceitação 4:  

> 

O sistema deve filtrar as informações conforme foi selecionado no filtro de pesquisa trazendo 

as seguintes colunas no relatório:  

> o

Nº  - Contador para identificar a ordem numérica;  

> o

Estudante  – Nome do Estudante;  

> o

Responsável  – responsável do estudante;  

> o

Ano/Fase  – Ano fase que o estudante está matriculado;  

> o

Turma  – Turma que o estudante está matriculado;  

> o

Faltas  – Quantidade de faltas por dia encontradas para o estudante;  

> o

Faltas  Justific adas  – faltas justificadas por dia para o estudante;  

> o

Celular  – Numero do celular do responsável pelo estudante;  

> o

Situação  – Ultima situação registrada no sistema. 

Critério de aceitação 5: Estória do Usuário 

Versão do template: 1.0 

18 

 Deve conter o seguinte rodapé:  SIGEEC  - Sistema de Gestão Educacional  da Escola 

Cuiabana. 

7.  ESTORIA DE USUÁRIO S TORY POINT (SP) 13 

EU  COMO  [Tipo do usuário] 

DESEJO  [Algum recurso; ação] Estória do Usuário 

Versão do template: 1.0 

19 

COM O OBJETIVO  [Benefício; valor ] Estória do Usuário  

> Versão do template: 1.0

20 

Menu de acesso da rotina: Manutenção>Aluno>Historico Escolar >Histórico Escolar 

(imprimir) 

Critérios de aceitação 1: 

 Para os campos AUTORIZAÇÃO, CRIAÇÃO, CREDENCIAMENTO , RENOVAÇÃO DE 

AUTORIZAÇAO E RENOVAÇÃO DE CREDENCIMENTO , deverá ser consideradas as 

informações cadastradas na UNIDADE 

ESCOLAR ( https://homologacao.siged.cuiaba.mt.gov.br/escola ) selecionada ao imprimir o 

relatório. 

 Incluir os campos para Telefone 1 e Telefone 2, conforme cadastro da UNIDADE 

ESCOLAR. // Nao deverá co nsiderar o campo numero de celular da unidade. Estória do Usuário  

> Versão do template: 1.0

21 

Critérios de aceitação 2:  

> 

Deverá criar o campo UF que mostrará a sigla do Estado de nascimento do estudante. 

Critérios de aceitação 3  

> 

Atualizar a base legal dos históricos escolares dos estudante para que c onste o que se 

segue:  

> 

CERTIFICAMOS que o ( a) estudante [ nome do estudante] está [ cursando/cursou] [trazer 

preenchido o ano/fase] o ano/fase do Ensino << trazer a Área de atuação>> <<t razer a 

Modalidade >> do Ano Letivo << Ano letivo>> , conforme dispõe a Lei 9.394/96, Lei 

11.114/05, Lei 11.274/06, Resolução CNE/CEB n° 7/10, Resolução CNE/CP nº 2/17, 

Resolução n° 39/2021/CMECUIABÁ -MT, Resolução Normativa n° 04/2021/CME/CUIABÁ -

MT, Resolução Normativa n° 05/2021/CME/CUIABÁ -MT e Resolução Normativa n° 

01/2022/ CME/CUIABÁ -MT.  

> 

O texto do histórico deve ser adequado com base na situação do 

estudante: cursando ou cursou : 

> o

se o aluno tiver com situação Aprovado ou Reprovado ou Reprovado(a) por 

Falta , , ENTURMADO(A), AVANÇADO(A), CLASSIFICADO(A), 

RECLASSIFICADO(A ) ou outros tipos de ajustes deverá adequar o texto 

para cursou.  

> 

Exemplo: CERTIFICAMOS que o ( a) estudante KARLOS EDUARDO 

CAMARGO MIRANDA cursou o 4° Ano/fase do Ensino Fundamental Anos 

Iniciais na Modalidade Ensino Regular do Ano Letivo 2022 , conforme dispõe 

a Lei 9.394/96, Lei 11.114/05, Lei 11.274/06, Resolução CNE/CEB n° 7/10, 

Resolução CNE/CP nº 2/17, Resolução n° 39/2021/CMECUIABÁ -MT, 

Resolução Normativa n° 04/2021/CME/CUIABÁ -MT, Resolução Normativa n° 

05/2021/CME/CUIABÁ -MT e Resolução Normativa n° 01/2022/CME/CUIABÁ -

MT. Estória do Usuário  

> Versão do template: 1.0

22 

o se o aluno tiver com situação TRANSFERIDO(A) deverá adequar o texto 

para cursando. 

 Exemplo: Exemplo: CERTIFCAMOS que o ( a) estudante KARLOS 

EDUARDO CAMARGO MIRANDA está cursando o 4° Ano/fase do Ensino 

Fundamental Anos Iniciais n a Modalidade Ensino Regular do Ano Letivo 

2022 , conforme dispõe a Lei 9.394/96, Lei 11.114/05, Lei 11.274/06, 

Resolução CNE/CEB n° 7/10, Resolução CNE/CP nº 2/17, Resolução n° 

39/2021/CMECUIABÁ -MT, Resolução Normativa n° 04/2021/CME/CUIABÁ -

MT, Resolução Normativa n° 05/2021/CME/CUIABÁ -MT e Resolução 

Normativa n° 01/2022/CME/CUIABÁ -MT. 

Critérios de aceitação 4 

 Listar todas as OBSERVAÇÕES registradas na tela de Lançamento Manual e geradas nas 

rotinas automáticas. 

 As observações deverão ser separadas por “ ;”

 Não considerar observações com a descrição " histórico automático " no relatório. 



Critérios de aceitação 5 

 Corrigir a ortografia Autenticação. 

Critérios de aceitação 6 

 Incluir na legenda de desempenho dos estudantes todos os conceitos cadastrados no 

histórico. 

 Permitir que as informações de conceito na legenda sejam campos adaptáveis , em vez de 

fixos. Estória do Usuário 

Versão do template: 1.0 

23 

 Listar apenas os tipos de conceitos selecionados pela unidade escolar ao inserir o histórico. 

 Validar que, uma vez cadastrado, a descrição do conceito não seja duplicada na legenda. 

Apresentar a Sigla do conceito e a descrição padronizada em letras maiúsculas .

Exemplo: PS = PROGRESSÃO SIMPLES