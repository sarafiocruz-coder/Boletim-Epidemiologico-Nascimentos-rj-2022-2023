# 🩺 Boletim Epidemiológico: Perfil dos Nascimentos no Estado do Rio de Janeiro, 2022–2023

![R](https://img.shields.io/badge/R-276DC3?style=flat-square&logo=r&logoColor=white)
![Status](https://img.shields.io/badge/Status-Em%20Desenvolvimento-success?style=flat-square)
![Licença](https://img.shields.io/badge/Licença-CC--BY%204.0-lightgrey?style=flat-square)

## 📌 Sobre o Projeto

Este repositório contém os códigos e materiais utilizados na elaboração do boletim epidemiológico desenvolvido no âmbito da **Residência Multiprofissional em Vigilância em Saúde**.

O projeto tem como objetivo descrever o perfil epidemiológico dos nascidos vivos de mães residentes no Estado do Rio de Janeiro, nos anos de 2022 e 2023, utilizando informações provenientes do Sistema de Informações sobre Nascidos Vivos (SINASC).

Foram analisadas características dos nascimentos, do perfil materno e dos recém-nascidos, por meio de frequências absolutas e relativas, tabelas e gráficos elaborados na linguagem R.

---

## 📂 Estrutura do Repositório

O projeto está organizado da seguinte forma:

```text
📦 boletim-Epidemiologico-Nascimentos-rj-2022-2023
 ┣ 📂 scripts
 ┃ ┣ 📜 Script_boletim_SINASC_SGM.R
 ┃ ┗ 📜 boletim_html.Rmd
 ┗ 📜 README.md
```

**Descrição dos arquivos:**

- `Script_boletim_SINASC_SGM.R`: script responsável pela obtenção, processamento e organização dos dados, além da elaboração das tabelas utilizadas no boletim.
- `boletim_html.Rmd`: documento responsável pela apresentação dos resultados, tabelas, gráficos e textos do boletim epidemiológico.
- `README.md`: documento com informações sobre o projeto e orientações para sua execução.

---

## 💾 Preparação dos dados

Antes de executar o projeto, é necessário realizar o download dos arquivos de dados disponibilizados na pasta `scripts` deste repositório.

**Siga as orientações:**

1. Acesse a pasta `scripts` no GitHub.
2. Localize os arquivos de dados disponibilizados nessa pasta.
3. Faça o download desses arquivos para o computador.
4. Salve os arquivos baixados diretamente na pasta **Downloads** do computador.
5. Mantenha os nomes originais dos arquivos, sem renomeá-los.

**Atenção:** os arquivos de dados devem ser mantidos na pasta `Downloads` para que o script consiga localizá-los durante a execução. Os arquivos de código `.R` e `.Rmd` devem permanecer na pasta `scripts` do projeto.

---

## ⚙️ Requisitos para execução

Para executar o projeto, é necessário ter instalado:

- [R](https://cran.r-project.org/);
- [RStudio](https://posit.co/download/rstudio-desktop/).

Também é necessário instalar os pacotes utilizados na elaboração do boletim.

No RStudio, execute:

```r
install.packages(c(
  "tidyverse",
  "ggplot2",
  "knitr",
  "kableExtra",
  "scales",
  "gridExtra",
  "plotly",
  "Microdatasus"
))
```

---

## ▶️ Como executar o projeto

Após realizar o download do repositório e preparar os arquivos de dados, siga as etapas:

1. Abra o RStudio.
2. Abra o arquivo `boletim_html.Rmd`, localizado na pasta `scripts`.
3. Verifique se os arquivos de dados foram salvos na pasta `Downloads`.
4. Abra o arquivo `.Rmd` no RStudio.
5. Clique na opção **Knit** para executar o documento.

Durante a execução, o script principal será acionado para realizar o processamento dos dados e disponibilizar as tabelas utilizadas na elaboração do boletim.

Ao final, será gerado um documento em formato HTML contendo os resultados da análise epidemiológica.

---

## 📊 Conteúdo do Boletim

O boletim apresenta a análise descritiva do perfil dos nascimentos no Estado do Rio de Janeiro, contemplando:

**1. Perfil dos nascimentos**
- Número de nascidos vivos por ano;
- Sexo do recém-nascido;
- Tipo de parto;
- Local de ocorrência do nascimento.

**2. Perfil materno**
- Faixa etária materna;
- Raça/cor materna;
- Escolaridade materna.

**3. Perfil do recém-nascido**
- Presença de anomalias congênitas;
- Peso ao nascer;
- Idade gestacional e prematuridade.

Os resultados são apresentados por meio de tabelas, gráficos e descrição dos principais achados epidemiológicos.

---

## 📚 Fonte dos dados

Sistema de Informações sobre Nascidos Vivos (SINASC), disponibilizado pelo Departamento de Informática do Sistema Único de Saúde (DATASUS), Ministério da Saúde.

**Período analisado:** 2022 e 2023.

**Abrangência geográfica:** Estado do Rio de Janeiro, considerando os nascidos vivos de mães residentes no estado.

---

## 👩‍💻 Elaboração

Sara Gonçalves Matias

Residente de Vigilância em Saúde – Fiocruz Brasília.

