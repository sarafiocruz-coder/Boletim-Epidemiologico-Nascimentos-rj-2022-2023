# Boletim Epidemiológico: Perfil dos Nascimentos no Estado do Rio de Janeiro, 2022–2023

![R](https://img.shields.io/badge/Language-R-blue)
![Status](https://img.shields.io/badge/Status-Em%20desenvolvimento-yellow)
![License](https://img.shields.io/badge/License-a%20definir-lightgrey)

## Sobre o projeto

Este projeto apresenta a análise descritiva do perfil epidemiológico dos nascidos vivos de mães residentes no Estado do Rio de Janeiro, nos anos de 2022 e 2023, utilizando dados do Sistema de Informações sobre Nascidos Vivos (SINASC/DATASUS).

O processamento foi desenvolvido em R. O fluxo de execução está organizado em duas etapas: primeiro, a execução do script de extração, tratamento e organização dos dados; em seguida, a renderização do documento R Markdown que utiliza os resultados produzidos pelo script.

## Estrutura do repositório

```text
boletim-epidemiologico-nascimentos-rj-2022-2023/
│
├── Documetos/
│   ├── dados_decodificados_compactado    # dados gerais tratados
│   └── dados_gerais_RJ_2022_2023         # dados brutos
│       
│
├── scripts/
│   ├── Script_boletim_SINASC_SGM.R      
│   ├── boletim_html.Rmd
│   └── resumo_estendido.Rmd
│
├── outputs/
│   ├── tabelas/
│   ├── boletim_html.html
│
├── README.md

```

**Observação:** os nomes dos arquivos compactados podem variar conforme os arquivos efetivamente disponibilizados no repositório. Mantenha os nomes e caminhos consistentes com os utilizados no script.

## Dados

### Fonte

Os dados utilizados são provenientes do Sistema de Informações sobre Nascidos Vivos (SINASC), disponibilizado pelo Departamento de Informática do Sistema Único de Saúde (DATASUS), para o Estado do Rio de Janeiro, nos anos de 2022 e 2023.

### Organização e acesso

Os arquivos de dados estão organizados na pasta `data/` e disponibilizados em formato `.zip` devido ao tamanho dos arquivos.

Para utilizar os dados localmente:

1. Acesse `data/originais/` e baixe o arquivo compactado com os dados originais.
2. Extraia o conteúdo do arquivo ZIP para a pasta `data/originais/`.
3. Caso utilize a base tratada, baixe também o arquivo ZIP disponível em `data/tratados/` e extraia seu conteúdo para essa pasta.
4. Confira se os nomes dos arquivos extraídos correspondem aos caminhos definidos no script.

O arquivo ZIP precisa ser extraído antes da leitura pelo R. O R não lê automaticamente um CSV que esteja compactado em ZIP apenas porque o arquivo foi baixado para a pasta.

**Limite do GitHub:** arquivos individuais com mais de 100 MB não podem ser enviados normalmente para um repositório GitHub. Se algum ZIP ultrapassar esse limite, será necessário utilizar Git LFS ou disponibilizar o arquivo em um serviço de armazenamento externo, registrando o link e as instruções nesta seção.

## Como executar a análise

### 1. Preparar o ambiente

- Instale o [R](https://cran.r-project.org/).
- Instale o [RStudio](https://posit.co/download/rstudio-desktop/).
- Baixe ou clone este repositório para o computador.
- Extraia os arquivos de dados ZIP que forem necessários.

### 2. Executar o script de processamento

Abra o arquivo:

`scripts/Script_boletim_SINASC_SGM.R`

Execute o script integralmente no RStudio, do início ao fim. Essa etapa realiza a obtenção/leitura dos dados, o tratamento das variáveis e a construção das tabelas utilizadas nos documentos.

Ao final da execução, o script deve disponibilizar os objetos de análise e gerar os arquivos de saída previstos, incluindo a planilha com as tabelas e o arquivo `outputs/objetos_analise.RData`.

**Esta etapa deve ser concluída antes de executar os documentos R Markdown.**

### 3. Gerar o boletim em HTML

Depois de executar o script, abra:

`scripts/boletim_html.Rmd`

No RStudio, selecione **Knit** para gerar o boletim HTML. Salve o arquivo gerado na pasta `outputs/`.

### 4. Gerar o resumo estendido

Em seguida, abra:

`scripts/resumo_estendido.Rmd`

Selecione **Knit** no RStudio. O resumo estendido utiliza os objetos gerados na etapa de processamento, sem executar novamente a extração e o tratamento dos microdados.

O arquivo HTML gerado deve ser armazenado em `outputs/`.

## Tabelas e resultados

As dez tabelas produzidas pela análise são organizadas em uma única planilha Excel, com uma aba para cada tabela:

1. Total de nascimentos;
2. Nascimentos por sexo;
3. Nascimentos por tipo de parto;
4. Nascimentos por local de ocorrência;
5. Faixa etária materna;
6. Raça/cor materna;
7. Escolaridade materna;
8. Anomalias congênitas;
9. Peso ao nascer;
10. Idade gestacional/prematuridade.

A planilha deve ser salva em `outputs/tabelas/tabelas_nascimentos.xlsx`. Os gráficos devem ser organizados em `outputs/figuras/`, e os documentos finais em HTML devem permanecer diretamente em `outputs/`.

## Pacotes utilizados

O script utiliza pacotes do R para extração, leitura, tratamento, organização, análise e apresentação dos dados. Entre os pacotes identificados no código estão:

- `microdatasus`
- `read.dbc`
- `tidyverse`
- `ggplot2`
- `scales`
- `writexl`
- `kableExtra`
- `gridExtra`
- `knitr`

A instalação de pacotes deve ser realizada conforme as instruções do próprio script e as necessidades do ambiente R utilizado.

## Reprodutibilidade

Para reproduzir os resultados, é necessário executar as etapas na ordem indicada: script de processamento, boletim HTML e resumo estendido. Os documentos R Markdown dependem dos objetos e arquivos gerados pelo script.

As versões do R e dos pacotes devem ser registradas quando a versão final do projeto for publicada, para facilitar a reprodução em outros computadores.

## Limitações

A análise utiliza dados secundários do SINASC e está sujeita à qualidade e à completitude dos registros da Declaração de Nascido Vivo. As frequências e percentuais apresentados descrevem os registros disponíveis e não devem ser interpretados, isoladamente, como medidas de incidência ou risco populacional.

## Licença

A licença de uso e compartilhamento do projeto deverá ser definida antes da publicação final.
