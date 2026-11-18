# 🩺 Boletim Epidemiológico: Perfil dos Nascimentos no Estado do Rio de Janeiro, 2022–2023

![R](https://img.shields.io/badge/R-276DC3?style=flat-square&logo=r&logoColor=white)
![Status](https://img.shields.io/badge/Status-Em%20Desenvolvimento-success?style=flat-square)
![Licença](https://img.shields.io/badge/Licen%C3%A7a-a%20definir-lightgrey?style=flat-square)

## 📌 Sobre o Projeto

Este repositório contém os códigos e materiais utilizados na elaboração do boletim epidemiológico desenvolvido no âmbito 
da **Residência Multiprofissional em Vigilância em Saúde**.

O objetivo principal deste projeto é **descrever o perfil epidemiológico dos nascidos vivos de 
mães residentes no Estado do Rio de Janeiro nos anos de 2022 e 2023**, segundo características dos nascimentos 
(sexo, tipo de parto, local de ocorrência), das mães (faixa etária, raça/cor, escolaridade) e dos recém-nascidos 
(peso ao nascer, idade gestacional, anomalias congênitas), a partir do Sistema de Informações sobre Nascidos Vivos 
(SINASC/DATASUS).

**Contexto:** boletim elaborado por residente de Vigilância em Saúde (Fiocruz Brasília) para a Subsecretaria de Vigilância em Saúde / DIVEP, Secretaria de Saúde do Distrito Federal. Documento dinâmico em R Markdown, em HTML com gráficos interativos (Plotly).

**Fonte dos dados:** SINASC/DATASUS (Declaração de Nascido Vivo), UF RJ. **Período:** 2022–2023 (ano obtido da data de nascimento). A base utilizada é o arquivo local `dados_gerais_RJ_2022_2023.csv` (356.515 registros, 61 colunas, dados sem tratamento); a data e a forma exata da extração não estão documentadas nos arquivos originais.

> ⚠️ **Situação de validação:** esta versão foi organizada sem acesso a R. A execução do código e a geração do HTML **ainda precisam ser realizadas e conferidas** (ver `docs/RELATORIO_ALTERACOES_VALIDACAO.md`). Há também pontos de auditoria pendentes de decisão, em especial a decodificação da escolaridade materna (`docs/AUDITORIA_RESULTADOS.md`).

---

## 📂 Estrutura do Repositório

```text
📦 boletim-epidemiologico-nascimentos-rj-2022-2023
 ┣ 📂 dados_brutos        # Base original do SINASC (NÃO versionada; ignorada pelo Git)
 ┣ 📂 data                # Dados tratados e processados (gerados pelo script)
 ┣ 📂 scripts             # Scripts em R ordenados por etapa de execução
 ┃ ┣ 📜 00_instalar_pacotes.R
 ┃ ┣ 📜 Script_boletim_SINASC_SGM.R
 ┃ ┗ 📜 99_renderizar_boletim.R
 ┣ 📂 outputs             # Produtos finais
 ┃ ┣ 📂 graficos
 ┃ ┣ 📂 tabelas           # 10 tabelas do boletim (.csv e .xlsx)
 ┃ ┗ 📂 boletim           # Boletim em HTML (e PDF, se gerado)
 ┣ 📂 docs                # Dicionário de dados, auditoria, relatório de alterações, guia de publicação
 ┣ 📂 backup_originais    # Cópias dos arquivos originais (local; ignorada pelo Git)
 ┣ 📜 boletim_html.Rmd    # Documento dinâmico principal do boletim
 ┣ 📜 .gitignore
 ┣ 📜 boletim-epidemiologico-nascimentos-rj-2022-2023.Rproj
 ┗ 📜 README.md
```

### Descrição das pastas e arquivos

| Item | Descrição |
|---|---|
| `dados_brutos/` | Contém `dados_gerais_RJ_2022_2023.csv`.
| `data/` | `dados_codificados.csv` (10 variáveis, códigos originais) e `dados_decodificados.csv` (9 variáveis, rótulos). Criados ao rodar o script. |
| `scripts/00_instalar_pacotes.R` | Instala os pacotes necessários (executar uma vez). |
| `scripts/Script_boletim_SINASC_SGM.R` | Leitura da base, limpeza (ano de nascimento), decodificação das variáveis, geração das 10 tabelas (`tab_*`) e exportação para `data/` e `outputs/tabelas/`. É chamado pelo `.Rmd` via `source()`. |
| `scripts/99_renderizar_boletim.R` | Compila o boletim e grava o HTML em `outputs/boletim/`. |
| `boletim_html.Rmd` | Boletim: introdução, metodologia (com fonte, recortes, indicadores e pacotes), resultados, considerações finais e referências. |
| `outputs/tabelas/` | Tabelas finais (CSV por tabela e um `.xlsx` com todas). |
| `outputs/boletim/` | Boletim final (HTML interativo). |
| `docs/DICIONARIO_DADOS.md` | Dicionário de dados. |
| `docs/AUDITORIA_RESULTADOS.md` | Conferência entre texto, tabelas e gráficos e achados pendentes. |
| `docs/auditoria/` | Script Python de reprodução independente e suas tabelas. Não faz parte do fluxo do boletim. |
| `docs/RELATORIO_ALTERACOES_VALIDACAO.md` | Alterações feitas, testes realizados/não realizados e pendências. |
| `docs/GUIA_PUBLICACAO_GITHUB_OSF_ZENODO.md` | Passo a passo e checklist de publicação. |

### Produtos gerados
Tabelas em `outputs/tabelas/`; dados tratados em `data/`; boletim em `outputs/boletim/boletim_html.html`. O boletim possui botão "Exportar para PDF" (impressão do navegador); um PDF também pode ser gerado conforme `scripts/99_renderizar_boletim.R`.

---

## 📦 Pacotes e requisitos

- **R** (≥ 4.1 recomendado) e **RStudio**; **Pandoc** (acompanha o RStudio).
- Pacotes CRAN: `tidyverse` (inclui `dplyr`, `ggplot2`), `knitr`, `rmarkdown`, `kableExtra`, `scales`, `gridExtra`, `plotly`, `writexl`.
- Apenas para a Opção 1 do script (download direto do DATASUS): `read.dbc` e `microdatasus` (GitHub).
- Memória: a base tem ~78 MB; recomenda-se ≥ 4 GB de RAM.
- As versões usadas aparecem automaticamente na seção "Fonte dos dados, recortes e pacotes utilizados" do boletim.

## 🚀 Instalação

1. Baixe/clone o repositório e descompacte, se for ZIP.
2. Coloque `dados_gerais_RJ_2022_2023.csv` na pasta `dados_brutos/` (já incluída no ZIP de entrega; **não está no GitHub**). Alternativamente, ative a Opção 1 do script (comentada) para baixar do DATASUS.
3. Abra o RStudio e abra `boletim-epidemiologico-nascimentos-rj-2022-2023.Rproj` (isso define a raiz do projeto como diretório de trabalho — **essencial** para os caminhos relativos).
4. No console: `source("scripts/00_instalar_pacotes.R")`.

## ▶️ Execução e reprodução do boletim

**Opção A (recomendada):** no console, `source("scripts/99_renderizar_boletim.R")`. O HTML será criado em `outputs/boletim/boletim_html.html`.

**Opção B:** abra `boletim_html.Rmd` e clique em **Knit → Knit to HTML** (a chave `knit:` do cabeçalho direciona a saída a `outputs/boletim/`).

**Somente processamento/tabelas:** `source("scripts/Script_boletim_SINASC_SGM.R")` — gera `data/` e `outputs/tabelas/`.

**Conferência rápida:** `nrow(dados_gerais)` deve resultar em 356.515; os totais por ano devem ser 180.369 (2022) e 176.145 (2023); 1 registro sem data de nascimento é esperado.

**Problemas comuns:** erro "Arquivo … não encontrado" → o projeto não foi aberto pelo `.Rproj` ou a base não está em `dados_brutos/`; erro em `knit:` → compile pelo script 99 ou remova a chave `knit:` do cabeçalho.

## 🔒 Privacidade e segurança dos dados

Os microdados do SINASC não trazem nome nem documento, mas contêm datas (nascimento do bebê e da mãe), estabelecimento e códigos que, combinados, podem aumentar o risco de reidentificação. Por isso a base bruta fica fora do Git (`.gitignore`) e apenas dados tratados e agregados, com autorização da coordenação, devem ser publicados (LGPD – Lei nº 13.709/2018). Nenhum dado é enviado a serviços externos pelo código.

## 📚 Referências
Ver seção de Referências do boletim (SINASC/MS; DATASUS; pacote microdatasus; CID-11/OMS).

## 📄 Licença
**A definir.** O modelo da residência sugere CC-BY 4.0, mas a licença ainda precisa ser confirmada pela autora/coordenação antes da publicação.

## ✍️ Autoria
Elaboração: Sara Gonçalves Matias – Residente de Vigilância em Saúde, Fiocruz Brasília. Contato institucional: divep.svs@saude.df.gov.br.
Ajustes de organização e reprodutibilidade realizados conforme o Roteiro de Reprodutibilidade e Ciência Aberta (PRMVS 2026).
