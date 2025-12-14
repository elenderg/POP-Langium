


export function pluralizar(palavra: string): string {
    let plural = palavra;

    // -------------------------------------------------
    // Exceções absolutas
    // -------------------------------------------------
    if (palavra === "caráter") {
        return "carateres";
    }

    if (palavra === "júnior") {
        return "juniores";
    }

    if (palavra === "sênior") {
        return "seniores";
    }

    // -------------------------------------------------
    // Advérbios invariáveis
    // -------------------------------------------------
    if (palavra === "muito") return plural;
    if (palavra === "pouco") return plural;
    if (palavra === "mais") return plural;
    if (palavra === "menos") return plural;
    if (palavra === "bastante") return plural;
    if (palavra === "quase") return plural;
    if (palavra === "demais") return plural;
    if (palavra === "bem") return plural;
    if (palavra === "deveras") return plural;
    if (palavra === "mal") return plural;
    if (palavra === "melhor") return plural;
    if (palavra === "pior") return plural;

    // -------------------------------------------------
    // Regras por sufixo
    // -------------------------------------------------
    if (terminaCom(palavra, "ão")) {
        return pluralizarStringTerminadaEmAo(palavra);
    }

    if (terminaCom(palavra, "d")) {
        return pluralizarOutrasLetras(palavra);
    }

    if (terminaCom(palavra, "l")) {
        return pluralizarStringTerminadaEmL(palavra);
    }

    if (terminaCom(palavra, "m")) {
        return palavra.slice(0, -1) + "ns";
    }

    // Preferencial para preservar acento
    if (terminaCom(palavra, "n")) {
        return palavra + "es";
    }

    if (terminaCom(palavra, "r")) {
        return pluralizarStringTerminadaEmR(palavra);
    }

    if (terminaCom(palavra, "s")) {
        return pluralizarStringTerminadaEmS(palavra);
    }

    if (terminaCom(palavra, "t")) {
        return pluralizarOutrasLetras(palavra);
    }

    if (terminaCom(palavra, "x")) {
        return pluralizarStringTerminadaEmX(palavra);
    }

    if (terminaCom(palavra, "z")) {
        return pluralizarStringTerminadaEmZ(palavra);
    }

    if (terminaCom(palavra, "#")) {
        return palavra + "s";
    }

    // -------------------------------------------------
    // Caso não termine em vogal nem consoante reconhecida
    // -------------------------------------------------
    if (!terminaEmVogalOuConsoante(palavra)) {
        return palavra + "s";
    }

    // -------------------------------------------------
    // Regra padrão
    // -------------------------------------------------
    return palavra + "s";
}

/*
function pluralizarStringTerminadaEmOutrasLetras(palavra: string): string {
    return palavra + "s";
}
*/

function terminaCom(palavra: string, sufixo: string): boolean {
    return palavra.endsWith(sufixo);
}

function terminaEmVogalOuConsoante(palavra: string): boolean {
    const ultimo = palavra.charAt(palavra.length - 1).toLowerCase();

    const vogais = "aeiouáéíóúâêôãõ";
    const consoantes = "bcdfghjklmnpqrstvwxyz";

    return vogais.includes(ultimo) || consoantes.includes(ultimo);
}

function pluralizarStringTerminadaEmAo(palavra: string): string {

    // -------------------------------------------------
    // Casos que formam plural apenas com "s" (-ãos)
    // -------------------------------------------------
    if (palavra === "cidadão") {
        return palavra + "s";
    }

    if (palavra === "irmão") {
        return palavra + "s";
    }

    if (palavra === "cristão") {
        return palavra + "s";
    }

    if (palavra === "refrão") {
        return palavra + "s";
    }

    if (palavra === "mão") {
        return palavra + "s";
    }

    if (palavra === "são") {
        return palavra + "s";
    }

    // -------------------------------------------------
    // Casos que formam plural em "ães"
    // (remove o 'o' final e adiciona "es")
    // -------------------------------------------------
    if (palavra === "pão") {
        return palavra.slice(0, -1) + "es";
    }

    if (palavra === "capitão") {
        return palavra.slice(0, -1) + "es";
    }

    if (palavra === "alemão") {
        return palavra.slice(0, -1) + "es";
    }

    if (palavra === "charlatão") {
        return palavra.slice(0, -1) + "es";
    }

    // -------------------------------------------------
    // Análise de acento em sílaba anterior
    // -------------------------------------------------
    const subtexto = palavra.slice(0, -2); // remove "ão"

    if (possuiVogalAcentuada(subtexto)) {
        // Exemplo: órgão -> órgãos
        return palavra + "s";
    }

    // -------------------------------------------------
    // Regra padrão: "ões"
    // -------------------------------------------------
    return palavra.slice(0, -2) + "ões";
}

function possuiVogalAcentuada(texto: string): boolean {
    const vogaisAcentuadas = "áéíóúâêôãõà";

    for (let i = 0; i < texto.length; i++) {
        if (vogaisAcentuadas.includes(texto[i])) {
            return true;
        }
    }

    return false;
}



function pluralizarStringTerminadaEmL(palavra: string): string {

    // palavras terminadas com "al"
    if (palavra.endsWith("al")) {
        return pluralizarStringTerminadaEmAl(palavra);
    }

    // palavras terminadas com "el"
    if (palavra.endsWith("el")) {
        return pluralizarStringTerminadaEmEl(palavra);
    }

    // palavras terminadas com "il"
    if (palavra.endsWith("il")) {
        return pluralizarStringTerminadaEmIl(palavra);
    }

    // palavras terminadas com "ol"
    if (palavra.endsWith("ol")) {
        return pluralizarStringTerminadaEmOl(palavra);
    }

    // palavras terminadas com "ul"
    if (palavra.endsWith("ul")) {
        return pluralizarStringTerminadaEmUl(palavra);
    }

    // Caso seja sigla (ex: URL, HTML, etc.)
    return palavra + "s";
}

function pluralizarStringTerminadaEmAl(palavra: string): string {

    // exceção explícita
    if (palavra === "mal") {
        return "males";
    }

    // remove o 'l'
    const base = palavra.slice(0, -1);

    // acrescenta "is"
    return base + "is";
}


function pluralizarStringTerminadaEmEl(palavra: string): string {

    // exceção explícita
    if (palavra === "pixel") {
        return "pixels";
    }

    // subtexto sem "el"
    const subtexto = palavra.slice(0, -2);

    // se houver vogal acentuada antes do sufixo
    if (possuiVogalAcentuada(subtexto)) {
        // remove apenas o 'l'
        const base = palavra.slice(0, -1);
        return base + "is";
    }

    // regra padrão: -el → -éis
    return subtexto + "éis";
}


function pluralizarStringTerminadaEmIl(palavra: string): string {

    // exceções explícitas
    switch (palavra) {
        case "canil":   return "canis";
        case "covil":   return "covis";
        case "funil":   return "funis";
        case "barril":  return "barris";
        case "fuzil":   return "fuzis";
        case "redil":   return "redis";
    }

    // subtexto sem "il"
    const subtexto = palavra.slice(0, -2);

    // se houver vogal acentuada antes do sufixo
    if (possuiVogalAcentuada(subtexto)) {
        return subtexto + "eis";
    }

    // regra padrão: remove o 'l' e acrescenta 's'
    const base = palavra.slice(0, -1);
    return base + "s";
}


function pluralizarStringTerminadaEmOl(palavra: string): string {

    // subtexto sem "ol"
    const subtexto = palavra.slice(0, -2);

    // se houver vogal acentuada antes do sufixo
    if (possuiVogalAcentuada(subtexto)) {
        // remove apenas o 'l'
        const base = palavra.slice(0, -1);
        return base + "is";
    }

    // regra padrão: -ol → -óis
    return subtexto + "óis";
}


function pluralizarStringTerminadaEmUl(palavra: string): string {

    // exceção explícita
    if (palavra === "cônsul") {
        return "cônsules";
    }

    // remove o 'l'
    const base = palavra.slice(0, -1);

    // acrescenta "is"
    return base + "is";
}



function pluralizarStringTerminadaEmR(palavra: string): string {

    // -------------------------------------------------
    // Regra para acentos em sílabas prévias
    // -------------------------------------------------

    // subtexto sem as duas últimas letras
    const subtexto = palavra.slice(0, -2);

    if (possuiVogalAcentuada(subtexto)) {
        return palavra + "es";
    }

    // -------------------------------------------------
    // Hiatos
    // -------------------------------------------------

    if (palavra.endsWith("air")) {
        const base = palavra.slice(0, -2);
        return base + "íres";
    }

    if (palavra.endsWith("aur")) {
        const base = palavra.slice(0, -2);
        return base + "úres";
    }

    // -------------------------------------------------
    // Regra padrão
    // -------------------------------------------------

    return palavra + "es";
}


function pluralizarStringTerminadaEmS(palavra: string): string {

    // -------------------------------------------------
    // Proparoxítonas / paroxítonas terminadas em "as", "es", "os"
    // -------------------------------------------------

    if (palavra.endsWith("as")) {
        return palavra + "es";
    }

    if (palavra === "pires") {
        return palavra;
    }

    if (palavra.endsWith("es")) {
        return palavra + "es";
    }

    if (palavra.endsWith("os")) {
        return palavra + "es";
    }

    // -------------------------------------------------
    // Hiatos acentuados
    // -------------------------------------------------

    if (palavra.endsWith("aís")) {
        return palavra + "es";
    }

    if (palavra.endsWith("aús")) {
        return palavra + "es";
    }

    // -------------------------------------------------
    // Oxítonas terminadas com acento
    // -------------------------------------------------

    if (palavra.endsWith("ás")) {
        return palavra.slice(0, -2) + "ases";
    }

    if (palavra.endsWith("âs")) {
        return palavra.slice(0, -2) + "ases";
    }

    if (palavra.endsWith("és")) {
        return palavra.slice(0, -2) + "eses";
    }

    if (palavra.endsWith("ês")) {
        return palavra.slice(0, -2) + "eses";
    }

    if (palavra.endsWith("ís")) {
        return palavra.slice(0, -2) + "ises";
    }

    if (palavra.endsWith("ós")) {
        return palavra.slice(0, -2) + "oses";
    }

    if (palavra.endsWith("ôs")) {
        return palavra.slice(0, -2) + "oses";
    }

    if (palavra.endsWith("ús")) {
        return palavra.slice(0, -2) + "uses";
    }

    // -------------------------------------------------
    // Palavras terminadas com "is" ou "us"
    // -------------------------------------------------

    if (palavra.endsWith("is")) {
        return pluralizarStringTerminadaEmIsOuUs(palavra);
    }

    if (palavra.endsWith("us")) {
        return pluralizarStringTerminadaEmIsOuUs(palavra);
    }

    // -------------------------------------------------
    // Casos invariáveis
    // -------------------------------------------------

    if (palavra.endsWith("ts")) {
        return palavra;
    }

    // -------------------------------------------------
    // Regra padrão
    // -------------------------------------------------

    return palavra + "es";
}

function pluralizarStringTerminadaEmIsOuUs(palavra: string): string {

    // -------------------------------------------------
    // Acentos em sílabas prévias
    // -------------------------------------------------

    const subtexto = palavra.slice(0, -2);

    if (possuiVogalAcentuada(subtexto)) {
        return palavra;
    }

    // -------------------------------------------------
    // Hiatos
    // -------------------------------------------------

    if (palavra.endsWith("ais")) {
        return palavra.slice(0, -2) + "íses";
    }

    if (palavra.endsWith("aus")) {
        return palavra.slice(0, -2) + "úses";
    }

    // -------------------------------------------------
    // Regra padrão
    // -------------------------------------------------

    return palavra + "es";
}


function pluralizarStringTerminadaEmX(palavra: string): string {

    // -------------------------------------------------
    // Exceções
    // -------------------------------------------------

    if (palavra === "fax") {
        return palavra + "es";
    }

    // -------------------------------------------------
    // Regra padrão
    // -------------------------------------------------

    return palavra + "s";
}


function pluralizarStringTerminadaEmZ(palavra: string): string {

    // -------------------------------------------------
    // Hiatos acentuados
    // -------------------------------------------------

    if (palavra.endsWith("aíz")) {
        return palavra + "es";
    }

    if (palavra.endsWith("aúz")) {
        return palavra + "es";
    }

    // -------------------------------------------------
    // Oxítonas terminadas com acento
    // -------------------------------------------------

    if (palavra.endsWith("áz")) {
        return palavra.slice(0, -2) + "azes";
    }

    if (palavra.endsWith("âz")) {
        return palavra.slice(0, -2) + "azes";
    }

    if (palavra.endsWith("éz")) {
        return palavra.slice(0, -2) + "ezes";
    }

    if (palavra.endsWith("êz")) {
        return palavra.slice(0, -2) + "ezes";
    }

    if (palavra.endsWith("íz")) {
        return palavra.slice(0, -2) + "izes";
    }

    if (palavra.endsWith("óz")) {
        return palavra.slice(0, -2) + "ozes";
    }

    if (palavra.endsWith("ôz")) {
        return palavra.slice(0, -2) + "ozes";
    }

    if (palavra.endsWith("úz")) {
        return palavra.slice(0, -2) + "uzes";
    }

    // -------------------------------------------------
    // Acentos em sílabas prévias
    // -------------------------------------------------

    const subtexto = palavra.slice(0, -2);

    if (possuiVogalAcentuada(subtexto)) {
        return palavra + "es";
    }

    // -------------------------------------------------
    // Hiatos não acentuados
    // -------------------------------------------------

    if (palavra.endsWith("aiz")) {
        return palavra.slice(0, -2) + "ízes";
    }

    if (palavra.endsWith("auz")) {
        return palavra.slice(0, -2) + "úzes";
    }

    // -------------------------------------------------
    // Regra padrão
    // -------------------------------------------------

    return palavra + "es";
}



function pluralizarOutrasLetras(palavra: string): string {
    // implementar depois
    return palavra + "s";
}
