# Workspace overview

Depending on the selection during the project generation you will have one or more packages contained in the packages directory.
Please check the specific projects here:

- [packages/language](./packages/language/README.md) This package is always available and contains the language definition.
- [packages/cli](./packages/cli/README.md) *Optional* Is only available if you chose to use the command-line interface.
- [packages/extension](./packages/extension/langium-quickstart.md) *Optional* Contains the VSCode extension if you chose to create it.

## What's in the folder?

Some file are contained in the root directory as well.

- [package.json](./package.json) - The manifest file the main workspace package
- [tsconfig.json](./tsconfig.json) - The base TypeScript compiler configuration
- [tsconfig.build.json](./package.json) - Configuration used to build the complete source code.
- [.gitignore](.gitignore) - Files ignored by git

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
