# Pacote da Linguagem (Obrigatório)

Este pacote contém a definição central da linguagem **Português Puro** e todos os componentes necessários para que o Langium gere a gramática, a AST, os serviços padrão e as extensões específicas da linguagem.

Para compreender o fluxo completo de desenvolvimento com Langium, consulte o guia oficial:
[https://langium.org/docs/learn/workflow/write_grammar/](https://langium.org/docs/learn/workflow/write_grammar/)

---

## Conteúdo do diretório

### Arquivos de Configuração

* **[package.json](./package.json)**
  Manifesto do pacote da linguagem. Define dependências, scripts de build e metadados locais.

* **[tsconfig.json](./tsconfig.json)**
  Configuração de TypeScript específica deste pacote. Estende o arquivo de configuração base localizado na raiz do workspace.  [base config](../../tsconfig.json)

---

### Fontes da Linguagem

* **[src/portugues-puro.langium](src/portugues-puro.langium)**
  Arquivo de gramática da linguagem Português Puro.
  Define regras sintáticas, estrutura da AST, keywords, tokens e a forma geral de todos os constructos da linguagem.

* **[src/portugues-puro-module.ts](src/portugues-puro-module.ts)**
  Módulo de injeção de dependências da linguagem.
  Use este arquivo para registrar serviços personalizados, substituir implementações padrão e configurar extensões como validação, indexação e completions.

* **[src/portugues-puro-validator.ts](src/portugues-puro-validator.ts)**
  Exemplo de validador.
  Deve ser adaptado para implementar as regras semânticas reais da linguagem Português Puro (por exemplo: checagem de tipos, escopos, uso de identificadores, etc.).

* **[src/index.ts](src/index.ts)**
  Define o que é exportado por este pacote.
  Pacotes como a CLI ou a extensão do VS Code consomem estes exports para inicializar o servidor de linguagem.

---

### Arquivos Gerados pelo Langium

Estes arquivos são recriados quando o comando `langium generate` é executado.

* **[src/generated/ast.ts](src/generated/ast.ts)**
  Representação tipada da AST resultante da gramática.

* **[src/generated/grammar.ts](src/generated/grammar.ts)**
  Versão programática da gramática em formato JavaScript/TypeScript, utilizada internamente pelo parser.

* **[src/generated/module.ts](src/generated/module.ts)**
  Declaração automática dos serviços básicos da linguagem, que pode ser estendida no módulo personalizado.

---

### Realce de Sintaxe

* **[src/syntaxes/portugues-puro.monarch.ts](src/syntaxes/portugues-puro.monarch.ts)**
  Definição de realce Monarch, usada por editores que suportam esse formato (incluindo a extensão VS Code).

* **[syntaxes/portugues-puro.tmLanguage.json](syntaxes/portugues-puro.tmLanguage.json)**
  Definição de sintaxe TextMate, utilizada para temas e realce avançado.

---

## Arquivos de Teste (se a opção de testes foi selecionada)

* **[tsconfig.test.json](./tsconfig.test.json)**
  Configuração TypeScript específica para testes.

* **[test/linking.test.ts](test/linking.test.ts)**
  Testes voltados para resolução de símbolos, escopos e linking.

* **[test/parsing.test.ts](test/parsing.test.ts)**
  Testes de parsing, cobrindo regras gramaticais básicas e casos limítrofes.

* **[test/validating.test.ts](test/validating.test.ts)**
  Testes de validação semântica da linguagem.

---
