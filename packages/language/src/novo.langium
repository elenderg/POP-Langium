grammar PortuguesPuro

entry Programa:
    (
          declaracoesDeTipos+=DeclaracaoDeTipo
        | declaracoesDeVariaveisGlobais+=DeclaracaoDeVariavelGlobal    
        | implementacaoDeRotinas_e_Funcoes+=Rotinas_e_Funcoes
    )+;

// ============================================================================
// SISTEMA DE TIPOS E VARIÁVEIS (COM REFERÊNCIAS CRUZADAS)
// ============================================================================

DeclaracaoDeTipo:
    ( DeclaracaoDeTipoSimples | DeclaracaoDePonteiro | DeclaracaoDeTipoEscalar | DeclaracaoDeTipoEstruturado )
    PONTO_FINAL;

DeclaracaoDeTipoSimples:
    ArtigoIndefinido nome=IDENTIFICADOR OperadorDeAtribuicao ArtigoIndefinido tipoBase=[DeclaracaoDeTipo:IDENTIFICADOR];

DeclaracaoDePonteiro:
    ArtigoIndefinido nome=IDENTIFICADOR OperadorDeAtribuicao ArtigoIndefinido 'ponteiro' 'para' ArtigoIndefinido tipoApontado=[DeclaracaoDeTipo:IDENTIFICADOR];

DeclaracaoDeTipoEscalar:
    ArtigoIndefinido nome=IDENTIFICADOR OperadorDeAtribuicao fatorDeEscala=NumeroLiteral tipoBase=[DeclaracaoDeTipo:IDENTIFICADOR];

DeclaracaoDeTipoEstruturado:
    ArtigoIndefinido nome=IDENTIFICADOR OperadorDeAtribuicao ArtigoIndefinido tipoBase=[DeclaracaoDeTipo:IDENTIFICADOR] 'com' (listaDeCampos+=Campo)+;

Campo:
    (CampoComum | ArrayDeBytes) (Pausa)?;

CampoComum:
    ArtigoIndefinido tipoBase=[DeclaracaoDeTipo:IDENTIFICADOR] (Denominacao nome=IDENTIFICADOR)? (referencia='(referência)')?;

ArrayDeBytes: 
    tamanho=NumeroLiteral tipoBase=('byte' | 'bytes');

// ============================================================================
// VARIÁVEIS E ATRIBUIÇÃO
// ============================================================================

DeclaracaoDeVariavelGlobal:
    ArtigoDefinido nome=IDENTIFICADOR OperadorDeAtribuicao 
    (
          (ArtigoIndefinido tipoBase=[DeclaracaoDeTipo:IDENTIFICADOR] ('igual' 'a' valor=ValorLiteral)?)
        | (valor=ValorLiteral) // Inferência de tipo
        | (ArtigoIndefinido tipoBase=[DeclaracaoDeTipo:IDENTIFICADOR] 'com' listaDeCampos+=Campo)
    ) PONTO_FINAL;

Variavel:
    (Artigo | Contracao) elemento=[DeclaracaoDeVariavelGlobal:IDENTIFICADOR] (acessores+=Acessor)*;

Acessor:
    Possessivo nomeDaEstrutura=IDENTIFICADOR;


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

// ============================================================================
// ROTINAS E FUNÇÕES
// ============================================================================

Rotinas_e_Funcoes: 
    cabecalho=CabecalhosDeRotinas_e_Funcoes
    (corpoDeEtapas+=EtapasDaRotina)*;

CabecalhosDeRotinas_e_Funcoes:
      CabecalhoRotina 
    | CabecalhoFuncaoBooliana 
    | CabecalhoFuncaoComputadora;

CabecalhoRotina:
    PALAVRA_ROTINA? 'para' 'que' PALAVRA_SE nome=IDENTIFICADOR (listaDeParametros+=Parametro)* (Qualificador)? (DOIS_PONTOS | PONTO_E_VIRGULA);

CabecalhoFuncaoBooliana:
    'Função'? 'para' 'que' PALAVRA_SE 'determine' PALAVRA_SE nome=IDENTIFICADOR (listaDeParametros+=Parametro)* (Qualificador)? (DOIS_PONTOS | PONTO_E_VIRGULA);

CabecalhoFuncaoComputadora:
    'Função'? 'para' 'que' PALAVRA_SE 'atribua' ArtigoDefinido campoCalculado=IDENTIFICADOR PossessivoAbrangente estruturaPrincipal=IDENTIFICADOR 'para' ArtigoIndefinido tipoAlvo=[DeclaracaoDeTipo:IDENTIFICADOR] (DOIS_PONTOS | PONTO_E_VIRGULA);

Parametro:
    (Complementos)* ArtigoIndefinido tipoDoParametro=[DeclaracaoDeTipo:IDENTIFICADOR] (Denominacao nome=IDENTIFICADOR)? (Complementos | ArtigoDefinido | Contracao)*;

// ============================================================================
// INSTRUÇÕES (ESTRUTURA DE CONTROLE)
// ============================================================================

EtapasDaRotina:
    ( 
      AvaliacaoCondicional | ExpressaoCondicional | ClausulaDeDirecionamento | 
      ClausulaDePreservacao | ClausulaDeEmpilhamento | InstrucoesDeLaco | 
      InstrucoesDeRetorno | InvocacaoInterna 
      // | InvocacaoIndireta 
      // | InvocacaoExterna 
    ) PONTO_FINAL;

AvaliacaoCondicional:
    PALAVRA_SE condicao=ExpressaoCondicional VIRGULA (acoes+=InvocacaoInterna (PONTO_E_VIRGULA acoes+=InvocacaoInterna)*);

ExpressaoCondicional:
    esquerda=(Variavel | ValorLiteral) verbo=(Verbos | IDENTIFICADOR) operador=OperadorDeComparacao? direita=(Variavel | ValorLiteral);

InvocacaoInterna:
    rotina=[Rotinas_e_Funcoes:IDENTIFICADOR] (complementos+=Complementos | argumentos+=Argumentos | adverbios+=AdverbioNegacao)* (qualificador=Qualificador)?;

Argumentos:
    valor=(Variavel | ValorLiteral) (Denominacao nomeDoParametro=IDENTIFICADOR)? (OperadorDeCoercaoDeTipo ArtigoIndefinido tipo=[DeclaracaoDeTipo:IDENTIFICADOR])?;

// ============================================================================
// AUXILIARES E TERMINAIS
// ============================================================================

Qualificador: ABRE_PARENTESES texto+=IDENTIFICADOR FECHA_PARENTESES;

InstrucoesDeRetorno: 
    (token='Retorne') | (token='Diga' valor=BoolianoLiteral);

InstrucoesDeLaco:
    token=('Itere' | 'Reitere' | 'Pare');

ClausulaDeEmpilhamento: 'Empilhe' valor=(Variavel | ValorLiteral);
ClausulaDePreservacao: 'Preserve' variavel=Variavel;

ClausulaDeDirecionamento:
    ('Aponte' | 'Direcione' | 'Redirecione') Artigo 'ponteiro' 'para' ArtigoDefinido PALAVRA_ROTINA alvo=[Rotinas_e_Funcoes:IDENTIFICADOR];

// Terminais de Valor
ValorLiteral: StringLiteral | NumeroLiteral | HexadecimalLiteral | BoolianoLiteral | PonteiroLiteral;
StringLiteral: valor=STRING;
NumeroLiteral: valor=INTEIRO;
HexadecimalLiteral: valor=NUMERO_HEXADECIMAL;
BoolianoLiteral: valor=SIM | valor=NAO;
PonteiroLiteral: valor='inexistente';

// Fragmentos e Regras de String (Açúcar Sintático)
Artigo returns string: ArtigoDefinido | ArtigoIndefinido;
ArtigoDefinido returns string: 'o' | 'a' | 'os' | 'as' | 'este' | 'esta' | 'estes' | 'estas';
ArtigoIndefinido returns string: 'um' | 'uns' | 'uma' | 'umas';
Possessivo returns string: PossessivoAbrangente | 'deste' | 'desta' | 'destes' | 'destas';
PossessivoAbrangente returns string: 'dum' | 'duns' | 'duma' | 'dumas';
Denominacao returns string: 'denominado' | 'denominada' | 'denominados' | 'denominadas';
OperadorDeAtribuicao returns string: PALAVRA_EH | PALAVRA_SAO;
OperadorDeCoercaoDeTipo returns string: 'tal' ('como' | 'qual');
OperadorDeComparacao returns string: 'igual' | 'diferente' | 'maior' | 'menor';
Pausa returns string: 'e' | 'ou' | VIRGULA;

// Simplificação de verbos e preposições para o parser
Verbos returns string: 'ser' | 'está' | 'tem' | 'há' | 'contém' | 'pode' | 'deve' | 'existe';
Preposicao returns string: 'de' | 'para' | 'em' | 'com' | 'por' | 'até' | 'como';
Conjuncao returns string: 'e' | 'ou' | 'nem';
PronomeRelativo returns string: 'que' | 'qual' | 'cujo';
AdverbioIgnoravel returns string: 'já' | 'ainda';
AdverbioNegacao returns string: 'não';


Complementos returns string: Preposicao | Conjuncao | PronomeRelativo | AdverbioIgnoravel | Verbos;

// Terminais (ORDEM É IMPORTANTE)
terminal PALAVRA_EH: 'é';
terminal PALAVRA_SAO: 'são';
terminal PALAVRA_ROTINA: 'Rotina';
terminal PALAVRA_SE: 'Se';
terminal SIM: 'sim';
terminal NAO: 'não';

terminal IDENTIFICADOR: /[_a-zA-ZÀ-ÿ][_a-zA-ZÀ-ÿ0-9]*/;
terminal INTEIRO returns number: /[0-9]+/;
terminal NUMERO_HEXADECIMAL: /\$[0-9a-fA-F]+/;
terminal STRING: /"(""|[^"])*"/;

terminal PONTO_FINAL: '.';
terminal VIRGULA: ',';
terminal PONTO_E_VIRGULA: ';';
terminal DOIS_PONTOS: ':';
terminal ABRE_PARENTESES: '(';
terminal FECHA_PARENTESES: ')';

hidden terminal ESPACO: /\s+/;
hidden terminal COMENTARIO: /\\+[^\r\n]*/;
hidden terminal OBSERVACAO: /\[[^\]]*\]/;

