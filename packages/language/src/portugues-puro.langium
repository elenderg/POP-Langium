grammar PortuguesPuro

entry Programa:
  (
      DeclaracoesDeTipos+=DeclaracaoDeTipo
    | DeclaracoesDeVariaveisGlobais+=DeclaracaoDeVariavelGlobal    
    | ImplementacaoDeRotinas_e_Funcoes+=Rotinas_e_Funcoes
  )+
  ;

// ============================================================================
// ROTINAS, FUNÇÕES BOOLIANAS E FUNÇÕES DE CAMPOS CALCULADOS
// ============================================================================

Rotinas_e_Funcoes: 
  CabecalhosDeRotinas_e_Funcoes
  CorpoDeRotinas_e_Funcoes+=EtapasDaRotina*
  ;

CabecalhosDeRotinas_e_Funcoes:
    CabecalhoPrincipalDaRotina
  | CabecalhoAlternativoDaRotina
  | CabecalhoPrincipalDaFuncaoBooliana
  | CabecalhoAlternativoDaFuncaoBooliana
  | CabecalhoPrincipalDaFuncaoComputadora
  | CabecalhoAlternativoDaFuncaoComputadora
  ;

CabecalhoPrincipalDaRotina:
  'Rotina'?
  'para'
  'que'
  'se'
  Cabecalho=CabecalhoComDoisPontos  
  ;

CabecalhoAlternativoDaRotina:
  'Rotina'?
  'para'
  'que'
  'se'
  Cabecalho=CabecalhoComPontoEVirgula
  ;

CabecalhoPrincipalDaFuncaoBooliana:
  'Função'?
  'para'
  'que'
  'se'
  'determine'
  'se'
  Cabecalho=CabecalhoComDoisPontos  
  ;

CabecalhoAlternativoDaFuncaoBooliana:
  'Função'?
  'para'
  'que'
  'se'
  'determine'
  'se'
  Cabecalho=CabecalhoComPontoEVirgula
  ;

CabecalhoPrincipalDaFuncaoComputadora:
  'Função'?
  'para'
  'que'
  'se'
  'atribua'
  ArtigoDefinido
  CampoCalculado=Identificador
  PossessivoAbrangente
  EstruturaPrincipal=Identificador  
  'para'
  ArtigoIndefinido
  TipoAlvo=Identificador
  DOIS_PONTOS
  ;

CabecalhoAlternativoDaFuncaoComputadora:
  'Função'?
  'para'
  'que'
  'se'
  'atribua'
  ArtigoDefinido
  CampoCalculado=Identificador
  PossessivoAbrangente
  EstruturaPrincipal=Identificador
  'para'
  ArtigoIndefinido
  TipoAlvo=Identificador
  PONTO_E_VIRGULA
  ;

PossessivoAbrangente returns string:
    'dum'
  | 'duns'  
  | 'duma'
  | 'dumas'
  ;

Qualificador:
  ABRE_PARENTESES
  TextoQualificador+=Identificador
  FECHA_PARENTESES
  ;

EtapasDaRotina:
  ( InvocacaoExterna  
  | InvocacaoIndireta   
  | AvaliacaoCondicional 
  | ExpressaoCondicional 
  | ClausulaDeDecodificacao 
  | ClausulaDeDirecionamento
  | ClausulaDePreservacao 
  | ClausulaDeEmpilhamento  
  | InstrucoesDeLaco
  | InstrucoesDeRetorno
  | InvocacaoInterna
  )
  PONTO_FINAL
  ;

ClausulaDeEmpilhamento:
  'Empilhe'  
  (Variavel | ValorLiteral)
  ;

ClausulaDePreservacao:
  'Preserve'  
  Variavel
  ;

ClausulaDeDecodificacao:
  'Decodifique'
  HexadecimalLiteral
  ;

ClausulaDeDirecionamento:
  (
      'Aponte'
    | 'Direcione'
    | 'Redirecione'
  )
  Artigo
  NomeDoTipo='ponteiro'
  'para'
  ArtigoDefinido
  'rotina'
  NomeDaRotina=InvocacaoInterna
  ;

ExpressaoCondicional:    
  Variavel
  VerboCondicional=(Verbos|Identificador)
  OperadorDeComparacao?
  (Variavel | ValorLiteral)
  |
  InvocacaoInterna;


AvaliacaoCondicional:
  'Se'
  ExpressaoCondicional
  VIRGULA
  BlocoCondicional
  ;

CabecalhoComDoisPontos:
  NomeDaRotina=Identificador
  (
    ListaDeParametros+=Parametros
  )?
  (Qualificador)?
  DOIS_PONTOS
  ;

CabecalhoComPontoEVirgula:
  NomeDaRotina=Identificador
  (
    ListaDeParametros+=Parametros
  )?
  (Qualificador)?
  PONTO_E_VIRGULA
  ;

InvocacaoInterna:
  NomeDaRotina=Identificador
  Complemento+=Complementos*
  (
    ListaDeArgumentos+=Argumentos
    Complemento+=(Complementos|Artigo|Contracao)*
    Outro+=Identificador
  )*
  (Qualificador)?
  ;

Argumentos:  
  (Variavel | VariavelPrecedidaDeContracao)
  (Denominacao NomeDoParametro=Identificador)?
  
  ;

Parametros:
  Complemento+=Complementos*
  ArtigoIndefinido 
  TipoDoParametro=Identificador
  (Denominacao NomeDoParametro=Identificador)?
  Complemento+=(Complementos|ArtigoDefinido|Contracao)*
  ;

Complementos:
  (
      Preposicao
    | Conjuncao    
    | PronomeRelativo
    | AdverbioIgnoravel
    | VerboAuxiliar=Verbos    
  )
  ;


BlocoCondicional:
  InvocacaoInterna
  (PONTO_E_VIRGULA DemaisInvocacoes+=InvocacaoInterna)* 
  ;


InstrucoesDeRetorno:
    'Retorne' // para retornos do tipo void, implícito
  | 'Diga' BoolianoLiteral   // para retornos boolianos ('sim' ou 'não')
  ;

InstrucoesDeLaco returns string:
    'Itere'
  | 'Reitere'
  | 'Pare'
  ;

InvocacaoIndireta:
  'Processe'  
  Ponteiro=Variavel  
  (
    'com'
    ListaDeArgumentos+=ArgumentosEncadeados
  )?
  (
    'retornando'
    Artigo
    NomeDaVariavel=Identificador
  )?
  ;

InvocacaoExterna:
  'Processe'
  NomeDaDLL=STRING
  NomeDaFuncao=STRING
  (
    'com'
    ListaDeArgumentos+=ArgumentosEncadeados
  )?
  (
    'retornando'
    Artigo
    NomeDaVariavel=Identificador
  )?
  ;

ArgumentosEncadeados:
  PrimeiroArgumento=(
      ValorLiteral 
    | Variavel
  )
  ( 
    'e' 
    (
        Valor+=ValorLiteral 
      | Variavel+=Variavel
    ) 
  )*
  ;

Variavel:
  Artigo
  NomeDaVariavel=Identificador
  (Acessores+=Acessor)*
  ;

VariavelPrecedidaDeContracao:
  Contracao
  NomeDaVariavel=Identificador
  (Acessores+=Acessor)*
  ;

Acessor:
  Possessivo 
  NomeDaEstrutura=Identificador
  ;

Possessivo returns string:
    PossessivoAbrangente 
  | PossessivoAdjacente;

Artigo returns string:
    ArtigoDefinido 
  | ArtigoIndefinido;

// ============================================================================
// DECLARAÇÃO DE VARIÁVEIS GLOBAIS
// ============================================================================

DeclaracaoDeVariavelGlobal: 
    DeclaracaoDeVariavelGlobalComTipoSimples
  | DeclaracaoDeVariavelGlobalComTipoComInicializacao
  | DeclaracaoDeVariavelGlobalSemTipoComInicializacao
  | DeclaracaoDeVariavelGlobalComTipoEstruturado
  ;

DeclaracaoDeVariavelGlobalComTipoSimples:
  ArtigoDefinido
  NomeDaVariavelGlobal=Identificador
  OperadorDeAtribuicao
  ArtigoIndefinido
  NomeDoTipoBase=Identificador
  PONTO_FINAL
  ;

DeclaracaoDeVariavelGlobalComTipoComInicializacao:
  ArtigoDefinido
  NomeDaVariavelGlobal=Identificador
  OperadorDeAtribuicao
  ArtigoIndefinido
  NomeDoTipoBase=Identificador
  'igual'
  'a'
  ValorDaVariavel=ValorLiteral
  PONTO_FINAL
  ;

DeclaracaoDeVariavelGlobalSemTipoComInicializacao:
  ArtigoDefinido
  NomeDaVariavelGlobal=Identificador
  OperadorDeAtribuicao  
  ValorDaVariavel=ValorLiteral
  PONTO_FINAL
  ;

DeclaracaoDeVariavelGlobalComTipoEstruturado:
  ArtigoDefinido
  NomeDaVariavelGlobal=Identificador
  OperadorDeAtribuicao
  ArtigoIndefinido
  NomeDoTipoBase=Identificador
  'com'
  ListaDeCampos+=Campo
  PONTO_FINAL
  ;

// ============================================================================
// DECLARAÇÃO DE TIPOS
// ============================================================================

DeclaracaoDeTipo:
  (  DeclaracaoDeTipoSimples
  | DeclaracaoDePonteiro
  | DeclaracaoDeTipoEscalar
  | DeclaracaoDeTipoEstruturado
  )
  PONTO_FINAL
  ;

DeclaracaoDeTipoSimples:
  ArtigoIndefinido
  NomeDoTipoDerivado=Identificador
  OperadorDeAtribuicao
  ArtigoIndefinido
  NomeDoTipoBase=Identificador
  ;

DeclaracaoDePonteiro:
  ArtigoIndefinido
  NomeDoTipoDerivado=Identificador
  OperadorDeAtribuicao
  ArtigoIndefinido
  NomeDoTipoBase='ponteiro'
  'para'
  ArtigoIndefinido
  NomeDoTipoApontado=Identificador  
  ;

DeclaracaoDeTipoEscalar:
  ArtigoIndefinido
  NomeDoTipoEscalar=Identificador
  OperadorDeAtribuicao
  FatorDeEscala=NumeroLiteral
  TipoBase=Identificador  
  ;

DeclaracaoDeTipoEstruturado:
  DeclaracaoDeTipoSimples
  'com'
  ListaDeCampos+=Campo  
  ;


Campo:
  (CampoComum | ArrayDeBytes) Pausa?
;

CampoComum:
  ArtigoIndefinido
  TipoBase=Identificador
  (
    Denominacao
    NomeDoCampo=Identificador
  )?
  (referencia='(referência)')?  
  ;

ArrayDeBytes: 
  NumeroLiteral 
  TipoBase=(
      'byte' 
    | 'bytes'
    )
  ;

Pausa returns string:
    ConjuncoesComuns 
  | ','
  ;


Denominacao returns string:
    'denominado'
  | 'denominada'
  | 'denominados'
  | 'denominadas'
  ;


OperadorDeAtribuicao returns string:
    PALAVRA_EH
  | PALAVRA_SAO
  ;

Contracao returns string:
    'à'     // para a
  | 'ao'    // para o
  | 'aos'     // para os
  | 'às'    // para as
  | 'no'    // em o
  | 'na'    // em a
  | 'nos'     // em os
  | 'nas'     // em as
  | 'num'     // em um
  | 'nuns'    // em uns
  | 'numa'    // em uma
  | 'numas'   // em umas
  | 'neste'   // em este
  | 'nesta'   // em esta
  | 'nestes'  // em estes
  | 'nestas'  // em estas
  | 'nesse'   // em esse
  | 'nessa'   // em essa
  | 'nesses'  // em esses
  | 'nessas'  // em essas
  | 'pelo'    // por o
  | 'pela'    // por a
  | 'pelos'   // por os
  | 'pelas'   // por as
  ;

OperadorDeComparacao returns string:
      'igual'   // 'a'
//  | 'igual'   // 'ao' 
    | 'diferente' // 'de' 
//  | 'diferente' 'desse'
//  | 'diferente' 'dessa'
//  | 'diferente' 'desses'
//  | 'diferente' 'dessas'
//  | 'diferente' 'deste'
//  | 'diferente' 'desta'
//  | 'diferente' 'destes'
//  | 'diferente' 'destas'
  | 'maior' // ('que'|'do' 'que') 
  | 'menor' // ('que'|'do' 'que') 
  ;

OperadorDeConcatenacao returns string:
  // Exemplos: o nome junto com o sobrenome
    'junto' 'com' 
  | 'juntamente' 'com' 
  | 'seguido' 'de' 
  | 'seguida' 'de' 
  | 'acompanhado' 'de' 
  | 'acompanhada' 'de' /*
  |  'com'         */
  ;

OperadorDeCoercaoDeTipo returns string:
  // Exemplo: o número tal qual um byte
   'tal' ('como'|'qual');

ValorLiteral: 
  StringLiteral
  | NumeroLiteral 
  | FracaoLiteral
  | NumeroMistoLiteral
  | HexadecimalLiteral
  | BoolianoLiteral
  | PonteiroLiteral
  ;

StringLiteral: texto=STRING;

NumeroLiteral: 
  sinal='-'? 
  valor=INTEIRO
  ;

FracaoLiteral: 
  numerador=NumeroLiteral 
  '/' 
  denominador=INTEIRO
  ;

NumeroMistoLiteral: 
  parteInteira=NumeroLiteral 
  ('+'|'-') 
  parteFracionaria=FracaoLiteral
  ;

HexadecimalLiteral: valor=NUMERO_HEXADECIMAL;

BoolianoLiteral: valor= ( 'sim' | 'não' );

PonteiroLiteral: valor='inexistente';

OperadorAritmetico returns string:
    'mais' 
  | 'menos' 
  | 'vezes' 
  | 'multiplicado' /*
  (
      'por'
    | 'pelo'
    | 'pela'
    | 'pelos'
    | 'pelas'
  )               */
  | 'dividido'    /*
  (
      'por'
    | 'pelo'
    | 'pela'
    | 'pelos'
    | 'pelas'
  )               */
  ;



// ============================================================================
// ARTIGOS E PRONOMES
// ============================================================================
ArtigoIndefinido returns string:
    'um' 
  | 'uns' 
  | 'uma' 
  | 'umas';


ArtigoDefinido returns string:
    'o' 
  | 'a' 
  | 'os'
  | 'as'
  | 'este' 
  | 'esta' 
  | 'estes' 
  | 'estas'
  ;


PossessivoAdjacente returns string:
    'deste' 
  | 'desta' 
  | 'destes' 
  | 'destas'
  ;

PronomeRelativo returns string:
  'que'  | 'qual' | 'quais' |
  'cujo' | 'cuja' | 'cujos' | 'cujas';

// Advérbios
AdverbioNegacao returns string:
  'não';

AdverbioIgnoravel returns string:
  'já' | 'ainda';

// Conjunções

ConjuncoesComuns returns string:
    'e' 
  | 'ou' 
  ;

Conjuncao returns string:
    ConjuncoesComuns
  | 'nem'
  ;



// Preposições (principais - lista completa seria muito extensa)
Preposicao returns string:
  // Conectivas
     A_PREPOSICAO | DE_PREPOSICAO 
  | 'para' | 'em' | 'com' | 'por'
  // Posição
  | 'acima' | 'abaixo' | 'debaixo' | 'sobre' | 'sob'
  | 'entre' | 'dentre' | 'próximo' | 'perto'
  // Temporais
  | 'antes' | 'depois' | 'durante'
  | 'desde' | 'após'   | 'enquanto' | 'até' 
  // Modo
  | 'como' | 'segundo' | 'mediante' | 'via' | 'usando' | 'através'
  // Compostas
  | 'partindo' | 'dentro' | 'acerca'
  // Relação
  | 'referente' | 'pertencente' | 'pertinente' | 'relativo'
  | 'relativa'  | 'concernente' | 'atinente'
  // Orientação
  | 'aproado'  | 'aproada'   | 'aproando' | 'orientado' | 'orientada' | 'orientando' 
  | 'voltado'  | 'voltada'   | 'virado'   | 'virada'    | 'virando'
  // Comparação
  | 'tal' | 'tão' | 'tanto' | 'quanto' | 'quão' | 'qual'
  | 'parecido' | 'parecida' | 'semelhante' | 'similar'
  // Restrição
  | 'sem' | 'só' | 'somente' | 'unicamente' | 'exclusivamente' | 'apenas'
  // Especiais
  | 'ante' | 'perante' | 'contra' | 'versus' | 'cerca'
  | 'aproximadamente' | 'algum' | 'fora' | 'menores'
  // Dimensão
  | 'alta' | 'alto' | 'comprido' | 'comprida' | 'largo' | 'larga'
  // Resultado
  | 'gerando' | 'resultando' | 'retornando' | 'devolvendo'
  | 'dando' | 'dado' | 'dada'
  // Início
  | 'começando' | 'iniciando'
  // Pronominais
  | 'cujo' | 'cuja' | 'cujos' | 'cujas' 
  ;

// ============================================================================
// VERBOS
// ============================================================================

Verbos returns string:
    VerboSer 
  | VerboEstar 
  | VerboTer 
  | VerboHaver 
  | VerboConter 
  | VerboPossuir 
  | VerboPoder 
  | VerboDever 
  | VerboExistir 
  | VerboCaber 
  | VerboComecar 
  | VerboTerminar 
  | OutrosVerbos;

VerboSer returns string:
    OperadorDeAtribuicao 
  | 'for' 
  | 'forem' 
  | 'foi' 
  | 'foram' 
  | 'será' 
  | 'serão' 
  | 'ser'
  ;

VerboEstar returns string:
    'está' 
  | 'estão' 
  | 'estiver' 
  | 'estiverem' 
  | 'estava' 
  | 'estavam' 
  | 'estará' 
  | 'estarão' 
  | 'estamos' 
  | 'estar';

VerboTer returns string: 'tem' | 'têm' | 'ter' | 'tiver';

VerboHaver returns string: 'há' | 'houver'| 'houverem';

VerboConter returns string: 'contém' | 'conter' | 'contiver';

VerboPossuir returns string: 'possui' | 'possuem' | 'possuir';

VerboPoder returns string:
    'pode' 
  | 'podem' 
  | 'podemos' 
  | 'poderia' 
  | 'puder' 
  | 'puderem';

VerboDever returns string: 'deve' | 'devem' | 'deveria' | 'deveriam';

VerboExistir returns string: 'existe' | 'existem' | 'existir';

VerboCaber returns string: 'cabe' | 'couber';

VerboComecar returns string: 'começa' | 'começar' | 'inicia' | 'iniciar';

VerboTerminar returns string:  'finaliza' | 'finalizar' | 'termina' | 'terminar';

OutrosVerbos returns string:
    'excede'  | 'excedem'  | 'necessita' | 'necessitar' | 'parecer'
  | 'parece'  | 'requer'   | 'supera'    | 'superam'    | 'superar';


Identificador: nome=IDENTIFICADOR; // Aviso: Esta regra precisa ficar por último, por ser a mais genérica possível.

// ============================================================================
// TERMINAIS
// ============================================================================

terminal OUTROS_VERBOS: 
    'excede'  | 'excedem'  | 'necessita' | 'necessitar' | 'parecer'
  | 'parece'  | 'requer'   | 'supera'    | 'superam'    | 'superar';


terminal PALAVRA_EH: 'é';
terminal PALAVRA_SAO: 'são';


// Espaços em branco e comentários
hidden terminal ESPACO: /\s+/;
// Comentário de linha (uma ou mais barras invertidas)
hidden terminal COMENTARIO: /\\+[^\r\n]*/;
// Comentário inline (entre colchetes)
hidden terminal OBSERVACAO: /\[[^\]]*\]/;

// Identificador genérico (para abreviações e outros usos)
terminal IDENTIFICADOR: 
  /[_a-zA-ZÀ-ÿ][_a-zA-ZÀ-ÿ0-9]*/;

// Número inteiro
terminal INTEIRO returns number: 
  /[0-9]+/;

// Número Hexadecimal (ex: $FF, $A0, $DEADBEEF)
terminal NUMERO_HEXADECIMAL returns string:
  /\$[0-9a-fA-F]+/;

// String literal (entre aspas duplas, com escape "")
terminal STRING: 
  /"(""|[^"])*"/;

terminal PONTO_FINAL: '.';
terminal VIRGULA: ',';
terminal PONTO_E_VIRGULA: ';';
terminal DOIS_PONTOS: ':';
terminal ASTERISCO: '*';
terminal BARRA: '/';
terminal MENOS: '-';
terminal MAIS: '+';
terminal BARRA_INVERTIDA: '\\';
terminal ABRE_PARENTESES: '(';
terminal FECHA_PARENTESES: ')';

terminal DE_PREPOSICAO: /\bde\b(?=\s+\b(um|uma|uns|umas|este|esta|estes|estas|esse|essa|esses|essas))\b/;
terminal A_PREPOSICAO: /\ba\b(?=\s+\b(um|uma|uns|umas|partir|este|esta|estes|estas|esse|essa|esses|essas)\b)/;
