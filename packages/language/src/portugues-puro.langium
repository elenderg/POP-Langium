grammar PortuguesPuro

// ============================================================================
// INTERFACES SEMÂNTICAS
// ============================================================================

interface ElementoNomeado {
  nome: string
}

interface tipo{
  nome: string;
  tipo_base: string;
  tipo_estruturado?: boolean;
  campos?: campos_de_estrutura[]; // era Campo[]; 
  ponteiro?: boolean;
  tipo_apontado?: string;
  fator_de_escala?: number;
  denominador?: number
}

interface campos_de_estrutura extends tipo{    
  referencia?: string;
  sobreposicao?: boolean;
  array_de_bytes?: boolean
}

interface variavel_global extends tipo{
  valor: ValorLiteral
}

interface parametro{
  tipo: tipo;
  denominacao?: string;
}

interface argumento extends parametro{  
  valor: ValorLiteral  
}

interface InvocacaoDeRotina{
  nome:string;
  argumentos: argumento[]
}

/*
interface NomeDoTipo extends ElementoNomeado{}
interface NomeDoCampo extends ElementoNomeado{}
interface NomeDaVariavel extends ElementoNomeado{}
interface NomeDoParametro extends tipo{}
interface NomeDoArgumento extends tipo{}
interface NomeDaRotina extends ElementoNomeado{}

interface Literal {
  nome_interno: string;
  valor: ValorLiteral
}*/

// ============================================================================
// PROGRAMA
// ============================================================================

entry Programa:
  (
      DeclaracoesDeTipos+=DeclaracaoDeTipo
    | DeclaracoesDeVariaveisGlobais+=DeclaracaoDeVariavelGlobal    
    | ImplementacaoDeRotinas_e_Funcoes+=Rotinas_e_Funcoes
  )+
  ;


// ============================================================================
// DECLARAÇÃO DE TIPOS
// ============================================================================

// TODO: Fazer com que os tipos 'byte' e 'bytes' sejam reconhecidos como tipos primitivos
DeclaracaoDeTipo returns tipo: // returns tipo
  ARTIGO_INDEFINIDO
  nome=NomeComposto
  OperadorDeAtribuicao  
  (
    ARTIGO_INDEFINIDO
    tipo_base=NomeComposto
    ('com' campos+=Campo)?
  |  
    ARTIGO_INDEFINIDO
    tipo_base='ponteiro'
    'para'
    ARTIGO_INDEFINIDO
    tipo_apontado=NomeComposto
  |    
    fator_de_escala=INTEIRO
    tipo_base=NomeComposto
  )
    PONTO_FINAL
  ;

Campo returns campos_de_estrutura:
  (CampoComum | ArrayDeBytes)
  (Denominacao nome=NomeComposto)?
  Sobreposicao?
  (referencia='(referência)')? 
  Pausa?
;

CampoComum:
  ARTIGO_INDEFINIDO
  tipo_base=NomeComposto
  ;

ArrayDeBytes: 
  NumeroLiteral 
  tipo_base=('byte'|'bytes') 
  ;

Sobreposicao: 'sob' ARTIGO_DEFINIDO CampoSobreposto=NomeComposto;


Pausa returns string:
    ConjuncoesComuns 
  | VIRGULA
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

// ============================================================================
// DECLARAÇÃO DE VARIÁVEIS GLOBAIS
// ============================================================================

DeclaracaoDeVariavelGlobal:
    ARTIGO_DEFINIDO
    NomeDaVariavelGlobal=NomeComposto
    OperadorDeAtribuicao
  (    
    ARTIGO_INDEFINIDO
    tipo_base=[tipo:NomeComposto]
    (
      'igual' 'a' 
      ValorDaVariavel=ValorLiteral
    )?    
  |    
    ValorDaVariavel=ValorLiteral    
  |    
    ARTIGO_INDEFINIDO
    tipo_base=[tipo:NomeComposto]
    'com'
    ListaDeCampos+=Campo    
  )
    PONTO_FINAL
  ;

// ============================================================================
// ROTINAS, FUNÇÕES BOOLIANAS E FUNÇÕES DE CAMPOS CALCULADOS
// ============================================================================

Rotinas_e_Funcoes: 
  CabecalhosDeRotinas_e_Funcoes
  CorpoDeRotinas_e_Funcoes+=EtapasDaRotina*
  ;

CabecalhosDeRotinas_e_Funcoes:
   (CabecalhosAlternativosDaRotina+=CabecalhoAlternativoDaRotina* CabecalhoPrincipalDaRotina)
  |(CabecalhosAlternativosDaFuncaoBooliana+=CabecalhoAlternativoDaFuncaoBooliana* CabecalhoPrincipalDaFuncaoBooliana)
  |(CabecalhosAlternativosDaFuncaoComputadora+=CabecalhoAlternativoDaFuncaoComputadora* CabecalhoPrincipalDaFuncaoComputadora)
  ;

CabecalhoPrincipalDaRotina:
  ROTINA? 'para''que' SE
  //Cabecalho=CabecalhoComDoisPontos // era [CabecalhoComDoisPontos:IDENTIFICADOR] [RotinaSimbolo:IDENTIFICADOR]
  StringDoCabecalho=Cabecalho DOIS_PONTOS;

CabecalhoAlternativoDaRotina:
  ROTINA? 'para''que' SE
  //Cabecalho=CabecalhoComPontoEVirgula // era[CabecalhoComPontoEVirgula:IDENTIFICADOR]
  StringDoCabecalho=Cabecalho PONTO_E_VIRGULA;

CabecalhoPrincipalDaFuncaoBooliana:
  'Função'? 'para' 'que' SE 'determine' SE
  //Cabecalho=CabecalhoComDoisPontos // era [CabecalhoComDoisPontos:IDENTIFICADOR]  
  StringDoCabecalho=Cabecalho DOIS_PONTOS;

CabecalhoAlternativoDaFuncaoBooliana:
  'Função'? 'para' 'que' SE 'determine' SE
  //Cabecalho=CabecalhoComPontoEVirgula // era [CabecalhoComPontoEVirgula:IDENTIFICADOR]
  StringDoCabecalho=Cabecalho PONTO_E_VIRGULA;


CabecalhoPrincipalDaFuncaoComputadora:
  'Função'? 'para' 'que' SE 'atribua'  
  CampoCalculado=NomeComposto
  Possessivo
  EstruturaPrincipal=[tipo:NomeComposto]
  'para' ARTIGO_INDEFINIDO
  TipoAlvo=[tipo:NomeComposto]
  DOIS_PONTOS;

CabecalhoAlternativoDaFuncaoComputadora:
  'Função'? 'para' 'que' SE 'atribua'  
  CampoCalculado=NomeComposto
  Possessivo
  EstruturaPrincipal=[tipo:NomeComposto]
  'para' ARTIGO_INDEFINIDO
  TipoAlvo=[tipo:NomeComposto]
  PONTO_E_VIRGULA;


// ============================================================================
// CABEÇALHOS
// ============================================================================

Cabecalho:
  NomeDaRotina=NomeComposto
  (
    ListaDeParametros+=Parametros
  )?
  (Qualificador)?  
  ;
/*
CabecalhoComDoisPontos:
  NomeDaRotina=[RotinaSimbolo:IDENTIFICADOR]
  (
    ListaDeParametros+=Parametros
  )?
  (Qualificador)?
  DOIS_PONTOS
  ;

CabecalhoComPontoEVirgula:
  NomeDaRotina=[RotinaSimbolo:IDENTIFICADOR]
  (
    ListaDeParametros+=Parametros
  )?
  (Qualificador)?
  PONTO_E_VIRGULA
  ;
*/
Parametros:
  Complemento+=(Complementos|ARTIGO_DEFINIDO|Contracao)*  
  (ARTIGO_INDEFINIDO 
  tipo_base=[tipo:NomeComposto]
  (Denominacao NomeDoParametro=NomeComposto)?)
  Complemento+=(Complementos|ARTIGO_DEFINIDO|Contracao)*
  ;

PossessivoAbrangente returns string:
    'dum'
  | 'duns'  
  | 'duma'
  | 'dumas'
  ;

Complementos:
  (
      Preposicao
    | Conjuncao    
    | PronomeRelativo
    | AdverbioIgnoravel
    | VerboAuxiliar=Verbos
    | Outros=NomeComposto  
  )
  ;


Qualificador:
  ABRE_PARENTESES
  TextoQualificador+=NomeComposto
  FECHA_PARENTESES
  ;

EtapasDaRotina:
  ( InvocacaoExterna  
  | InvocacaoIndireta   
  | AvaliacaoCondicional 
  | ExpressaoCondicional 
  | ClausulaDeDecodificacao 
  | ClausulaDeRedirecionamento
  | ClausulaDePreservacao 
  | ClausulaDeEmpilhamento  
  | InstrucoesDeLaco
  | InstrucoesDeRetorno
  | InvocacaoInterna
  )
  PONTO_FINAL
  ;

ClausulaDeEmpilhamento: 'Empilhe' (Variavel | ValorLiteral);

ClausulaDePreservacao: 'Preserve'  Variavel;

ClausulaDeDecodificacao: 'Decodifique' HexadecimalLiteral;

ClausulaDeRedirecionamento:
  (
      'Aponte'
    | 'Direcione'
    | 'Redirecione'
  )
  Artigo
  tipo_base='ponteiro'
  'para'
  ARTIGO_DEFINIDO  
  (Alvo=CabecalhosDeRotinas_e_Funcoes)
  ;

ExpressaoCondicional:    
  Variavel
  VerboCondicional=(Verbos|NomeComposto)
  OperadorDeComparacao?
  (Variavel | ValorLiteral)
  |
  InvocacaoInterna;


AvaliacaoCondicional:
  SE
  ExpressaoCondicional
  VIRGULA
  BlocoCondicional
  ;

InvocacaoInterna:
  NomeDaRotina=NomeComposto
  Complemento+=Complementos*
  (
    ListaDeArgumentos+=Argumentos
    Complemento+=(
        Complementos
      | Artigo
      | Contracao
      | AdverbioIgnoravel
      | AdverbioNegacao
    )*
    Outro+=NomeComposto
  )*
  (Qualificador)?
  ;

Argumentos:  
  (
    Variavel=(Variavel|VariavelPrecedidaDeContracao)
  )  
  (
    Denominacao
    NomeDoArgumento=NomeComposto
  )?
  (
    OperadorDeCoercaoDeTipo // TODO: adicionar onde cabível
    ARTIGO_INDEFINIDO
    tipo_base=NomeComposto
  )
  Modificador+=ExpressaoAlgebrica*
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
  PonteiroParaRotina=Variavel  
  (
    'com'
    ListaDeArgumentos+=ArgumentosEncadeados
  )?
  (
    'retornando'
    Artigo
    NomeDaVariavel=NomeComposto
  )?
  ;

InvocacaoExterna:
  'Processe'
  NomeDaDLL=STRING_LITERAL
  NomeDaFuncao=STRING_LITERAL
  (
    'com'
    ListaDeArgumentos+=ArgumentosEncadeados
  )?
  (
    'retornando'
    Artigo
    NomeDaVariavel=NomeComposto
    Modificador+=ExpressaoAlgebrica*
  )?
  ;

ArgumentosEncadeados:
  PrimeiroArgumento=(
      ValorLiteral 
    | Variavel
  )
  Modificador+=ExpressaoAlgebrica*
  ( 
    'e' 
    (
        Valor+=ValorLiteral 
      | Variavel+=Variavel
    )
    Modificador+=ExpressaoAlgebrica*
  )*
  ;

Variavel:
  Artigo
  NomeDaVariavel=NomeComposto
  (Acessores+=Acessor)*
  ;

VariavelPrecedidaDeContracao:
  Contracao
  NomeDaVariavel=NomeComposto
  (Acessores+=Acessor)*
  ;

Acessor:
  Possessivo 
  NomeDaEstrutura=NomeComposto
  ;

Possessivo returns string:
    PossessivoAbrangente 
  | PossessivoAdjacente;

Artigo returns string:
    ARTIGO_DEFINIDO 
  | ARTIGO_INDEFINIDO;


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
  ( StringLiteral
  | NumeroLiteral 
  | FracaoLiteral
  | NumeroMistoLiteral
  | HexadecimalLiteral
  | BoolianoLiteral
  | PonteiroLiteral );

StringLiteral: texto=STRING_LITERAL;

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

ExpressaoAlgebrica:
  (Variavel|ValorLiteral)
  (OperadorAritmetico|OperadorDeConcatenacao)
  (Variavel|ValorLiteral)
  ;


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
terminal ARTIGO_INDEFINIDO returns string:
    'um' 
  | 'uns' 
  | 'uma' 
  | 'umas'
  | 'esse'
  | 'essa'
  | 'esses'
  | 'essas'
  ;


terminal ARTIGO_DEFINIDO returns string:
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

// Isso permite "grupo data hora" ou "data-hora" de forma controlada
NomeComposto returns string:  IDENTIFICADOR (ESPACO IDENTIFICADOR)*;
//Identificador: nome=IDENTIFICADOR; // Aviso: Esta regra precisa ficar por último, por ser a mais genérica possível.
/*
NovoIDENTIFICADOR returns string:  
    FORTE
    (   FORTE
      | CONTEXTUAL
      | ESPECIAL FORTE
      | ESPECIAL CONTEXTUAL
    )*
  ;
*/
// ============================================================================
// TERMINAIS
// ============================================================================
//terminal FORTE: /[A-Za-zÀ-ÿ#%&@_`~]/; // (podem iniciar e terminar identificadores)
//terminal CONTEXTUAL: /[0-9 \/-]/; // (nunca iniciam nem terminam identificadores)
//terminal ESPECIAL:  /[<=>^€‚„…†‡ˆ‰‹‘’“”˜•–—™š›¡¢£¤¥¦«¬®¯°±²³´·¸¹»¼½¾¿§¨©×÷]/; // (podem aparecer, mas nunca adjacentes entre si)
terminal PALAVRA_EH: 'é';
terminal PALAVRA_SAO: 'são';
terminal ROTINA: 'Rotina';
terminal SE: 'Se';
//terminal A_ISOLADO: /\bA\b/ | /\ba\b/;
//terminal E_ISOLADO: /\bE\b/ | /\be\b/;
//terminal O_ISOLADO: /\bO\b/ | /\bo\b/;
//cterminal ACENTO_ISOLADO: /\bÀ\b/ | /\bÉ\b/ | /\bé\b/ | /\bá\b/;

terminal IDENTIFICADOR: 
  /[A-Za-zÀ-ÿ#%&@_`~](?:[A-Za-zÀ-ÿ#%&@_`~]|[0-9\/-]|[<=>^€‚„…†‡ˆ‰‹‘’“”˜•–—™š›¡¢£¤¥¦«¬®¯°±²³´·¸¹»¼½¾¿§¨©×÷][A-Za-zÀ-ÿ#%&@_`~0-9 \/-])*[A-Za-zÀ-ÿ#%&@_`~]/;

// Espaços em branco e comentários
terminal ESPACO: /\s+/;
// Comentário de linha (uma ou mais barras invertidas)
hidden terminal COMENTARIO: /\\+[^\r\n]*/;
// Comentário inline (entre colchetes)
hidden terminal OBSERVACAO: /\[[^\]]*\]/;

// Identificador antigo genérico (para abreviações e outros usos)
//terminal IDENTIFICADOR3: /[_a-zA-ZÀ-ÿ#][_a-zA-ZÀ-ÿ0-9#]*/;




// Número inteiro
terminal INTEIRO returns number: 
  /[0-9]+/;

// Número Hexadecimal (ex: $FF, $A0, $DEADBEEF)
terminal NUMERO_HEXADECIMAL returns string:
  /\$[0-9a-fA-F]+/;

// String literal (entre aspas duplas, com escape "")
terminal STRING_LITERAL: /"(?:""|[^"\r\n])*"/;

terminal PONTO_FINAL: '.';
terminal VIRGULA: ',';
terminal PONTO_E_VIRGULA: ';';
terminal DOIS_PONTOS: ':'; /*
terminal ASTERISCO: '*';
terminal BARRA: '/';
terminal MENOS: '-';
terminal MAIS: '+';
terminal BARRA_INVERTIDA: '\\'; */
terminal ABRE_PARENTESES: '(';
terminal FECHA_PARENTESES: ')';

terminal DE_PREPOSICAO: /\bde\b(?=\s+\b(um|uma|uns|umas|este|esta|estes|estas|esse|essa|esses|essas))\b/;
terminal A_PREPOSICAO: /\ba\b(?=\s+\b(um|uma|uns|umas|partir|este|esta|estes|estas|esse|essa|esses|essas)\b)/;
