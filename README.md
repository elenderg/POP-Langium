# Servidor de Linguagem para Português Puro

Este repositório contém a implementação do **Servidor de Linguagens (LSP)** para a linguagem de programação **Português Puro**, construída com **Langium**.
A estrutura utiliza um workspace monorepo para organizar a gramática, o servidor, a CLI opcional e a extensão para VS Code.

## Estrutura do Workspace

Os pacotes estão presentes no diretório `packages/`.

### Pacotes disponíveis

* **[packages/language](./packages/language/README.md)**
  Pacote principal. Contém:

  * Gramática da linguagem (arquivo `.langium`)
  * Construção da AST
  * Serviços personalizados (validação, formatação, indexação)
  * Geração de código, caso aplicável

* **[packages/cli](./packages/cli/README.md)** *(opcional)*
  Disponível se a opção CLI foi habilitada na criação do projeto.
  Inclui:

  * Executável da linguagem via linha de comando
  * Funções como validação de arquivos `.pop`, geração de AST, e comandos auxiliares

* **[packages/extension](./packages/extension/langium-quickstart.md)** *(opcional)*
  Pacote da extensão do VS Code.
  Inclui:

  * Código do cliente LSP
  * Configurações da extensão
  * Ativação e comunicação com o servidor de linguagem

---

## Arquivos na raiz do repositório

Alguns arquivos de configuração ficam diretamente no diretório raiz:

* **[package.json](./package.json)**
  Manifesto principal do workspace. Define dependências, scripts e metadados globais.

* **[tsconfig.json](./tsconfig.json)**
  Configuração base do compilador TypeScript para todo o workspace.

* **[tsconfig.build.json](./tsconfig.build.json)**
  Configuração utilizada especificamente durante o processo de *build* de todos os pacotes.

* **[.gitignore](./.gitignore)**
  Define os arquivos e diretórios ignorados pelo Git.

---
