##Local do arquivo##
getwd()


## Pacotes principais ##
if (!require("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}
library(tidyverse)

if (!require("kableExtra", quietly = TRUE)) {
  install.packages("kableExtra")
}
library(kableExtra)

if (!require("scales", quietly = TRUE)) {
  install.packages("scales")
}
library(scales)

if (!require("gridExtra", quietly = TRUE)) {
  install.packages("gridExtra")
}
library(gridExtra)

print("Ambiente RStudio configurado e pronto!")

## Pacotes de dados ##
if (!require("microdatasus", quietly = TRUE)) {
  install.packages("microdatasus")
}
library(microdatasus)

print("Tudo certo até aqui!")



#--------------------------------------------------------------------------------------------------------------

#Aqui começa a solicitação de dados. Serão usados dados do SINASC do RJ dos anos 2022 e 2023


#------------------------------ OPÇÃO 1 ---------------------------------#


#Dados sem tratamento

dados_2022 <- fetch_datasus(year_start = 2022, year_end = 2022, uf = "RJ",information_system = "SINASC")

dados_2023 <- fetch_datasus(year_start = 2023, year_end = 2023, uf = "RJ",information_system = "SINASC")

#Empilhar as bases

dados_gerais <- bind_rows(dados_2022, dados_2023)
glimpse(dados_gerais)
View(dados_gerais)



#------------------------------ OPÇÃO 2 ---------------------------------#



#No caso do DATASUSA não funcionar, rode esse código, se já tiver os dados na pasta

caminho_arquivo <- file.path(
  getwd(),
  "dados_gerais_RJ_2022_2023.csv"
)

# Verificar se o arquivo existe
if (!file.exists(caminho_arquivo)) {
  stop("Arquivo dados_gerais_RJ_2022_2023.csv não encontrado na pasta principal do projeto.")
}

# Importar os dados
dados_gerais <- read.csv(
  caminho_arquivo,
  fileEncoding = "UTF-8"
)

# Verificação dos dados
glimpse(dados_gerais)
View(head(dados_gerais, 100))



#--------------------------------------------------------------------------------------------------------------




## Tratamento dos dados ##

dados_limpos <- dados_gerais %>%
  mutate(
    CODMUNNASC = as.character(CODMUNNASC),   # município como caractere
    IDADEMAE   = as.numeric(IDADEMAE),       # idade da mãe
    PESO       = as.numeric(PESO),           # peso ao nascer (gramas)
    GESTACAO   = as.numeric(GESTACAO),       # semanas de gestação
    APGAR1     = as.numeric(APGAR1),         # Apgar 1º minuto
    APGAR5     = as.numeric(APGAR5),         # Apgar 5º minuto
    PARTO      = as.character(PARTO),        # tipo de parto
    SEXO       = as.character(SEXO),         # sexo do recém-nascido
    RACACOR    = as.character(RACACOR),      # raça/cor
    CONSULTAS  = as.numeric(CONSULTAS),      # número de consultas pré-natal
    
    # Tratamento da data
    DTNASC_char = as.character(DTNASC),
    
    # Limpar a data: remover espaços e barras
    DTNASC_limpo = str_replace_all(DTNASC_char, "[^0-9]", ""),
    
    # Extrair o ano baseado no tamanho da string
    ano = case_when(
      # Formato DDMMYYYY (8 dígitos) - ano nos últimos 4
      str_length(DTNASC_limpo) == 8 ~ as.numeric(substr(DTNASC_limpo, 5, 8)),
      
      # Formato DMMYYYY ou DMYYYY (7 dígitos) - ano nos últimos 4
      str_length(DTNASC_limpo) == 7 ~ as.numeric(substr(DTNASC_limpo, 4, 7)),
      
      # Formato DDMMYY ou DMMYY (6 dígitos) - ano nos últimos 2 (assumindo 20xx)
      str_length(DTNASC_limpo) == 6 ~ as.numeric(paste0("20", substr(DTNASC_limpo, 5, 6))),
      
      # Formato D M YYYY (com espaços) - extrair o último grupo de números
      TRUE ~ as.numeric(str_extract(DTNASC_char, "[0-9]{4}$"))
    ),
    
    # Opcional: criar data completa no formato Date
    data_completa = case_when(
      # Se temos dia, mês e ano
      !is.na(ano) & str_length(DTNASC_limpo) >= 6 ~ {
        dia = case_when(
          str_length(DTNASC_limpo) == 8 ~ substr(DTNASC_limpo, 1, 2),
          str_length(DTNASC_limpo) == 7 ~ substr(DTNASC_limpo, 1, 1),
          TRUE ~ substr(DTNASC_limpo, 1, 2)
        )
        mes = case_when(
          str_length(DTNASC_limpo) == 8 ~ substr(DTNASC_limpo, 3, 4),
          str_length(DTNASC_limpo) == 7 ~ substr(DTNASC_limpo, 2, 3),
          TRUE ~ substr(DTNASC_limpo, 3, 4)
        )
        as.Date(paste(ano, mes, dia, sep = "-"), format = "%Y-%m-%d")
      },
      TRUE ~ NA_Date_
    )
  ) %>%
  select(-DTNASC_char, -DTNASC_limpo)

# Verificar o resultado
glimpse(dados_limpos)

# Verificar o ano extraído
dados_limpos %>%
  select(DTNASC, ano, data_completa) %>%
  head(20)

# Verificar quantos NAs temos
dados_limpos %>%
  summarise(
    total = n(),
    nas_ano = sum(is.na(ano)),
    perc_nas_ano = round(nas_ano / total * 100, 2)
  )




#--------------------------------------------------------------------------------------------------------------

#-------------------------------------# Para a análise que será feita #---------------------------------------#


#Seleção de colunas que serão utilizadas

tabela_codificada <- dados_limpos %>%
  select(
    ESCMAE2010,  # escolaridade da mãe
    IDADEMAE,    # idade da mãe
    IDANOMAL,    # anomalia congênita
    LOCNASC,     # local do nascimento
    PARTO,       # tipo de parto
    PESO,        # peso ao nascer
    RACACOR,     # raça/cor da mãe
    GESTACAO,    # semanas de gestação
    SEXO,        # sexo do RN
    ano          # ano
  )

glimpse(tabela_codificada)
view(tabela_codificada)

#Decodificação do banco de dados

dados_tratados <- tabela_codificada %>%
  filter(!is.na(ano)) %>%
  mutate(
    
    # 1. SEXO
    sexo_desc = case_when(
      SEXO == "1" ~ "Masculino",
      SEXO == "2" ~ "Feminino",
      SEXO == "0" ~ "Ignorado",
      TRUE ~ "Sem informação"
    ),
    
    # 2. TIPO DE PARTO
    parto_desc = case_when(
      PARTO == "1" ~ "Vaginal",
      PARTO == "2" ~ "Cesáreo",
      PARTO == "9" ~ "Ignorado",
      TRUE ~ "Sem informação"
    ),
    
    # 3. LOCAL DO NASCIMENTO
    localnasc_desc = case_when(
      LOCNASC == "1" ~ "Hospital",
      LOCNASC == "2" ~ "Outros estabelecimentos de saúde",
      LOCNASC == "3" ~ "Domicílio",
      LOCNASC == "4" ~ "Outros",
      LOCNASC == "5" ~ "Aldeia indígena",
      LOCNASC == "9" ~ "Ignorado",
      TRUE ~ "Sem informação"
    ),
    
    # 4. RAÇA/COR DA MÃE
    racacor_desc = case_when(
      RACACOR == "1" ~ "Branca",
      RACACOR == "2" ~ "Preta",
      RACACOR == "3" ~ "Amarela",
      RACACOR == "4" ~ "Parda",
      RACACOR == "5" ~ "Indígena",
      RACACOR == "9" ~ "Ignorado",
      TRUE ~ "Sem informação"
    ),
    
    # 5. ESCOLARIDADE DA MÃE (ESCMAE2010 - Censo 2010)
    escolaridade_desc = case_when(
      ESCMAE2010 == "0" ~ "Sem escolaridade",
      ESCMAE2010 == "1" ~ "Ensino Fundamental I (1ª a 4ª série)",
      ESCMAE2010 == "2" ~ "Ensino Fundamental II (5ª a 8ª série)",
      ESCMAE2010 == "3" ~ "Ensino Médio",
      ESCMAE2010 == "4" ~ "Ensino Superior incompleto",
      ESCMAE2010 == "5" ~ "Ensino Superior completo",
      ESCMAE2010 == "9" ~ "Ignorado",
      TRUE ~ "Sem informação"
    ),
    
    # 6. FAIXA ETÁRIA DA MÃE
    faixa_etaria_desc = case_when(
      IDADEMAE < 15 ~ "< 15 anos",
      IDADEMAE >= 15 & IDADEMAE < 20 ~ "15 a 19 anos",
      IDADEMAE >= 20 & IDADEMAE < 30 ~ "20 a 29 anos",
      IDADEMAE >= 30 & IDADEMAE < 35 ~ "30 a 34 anos",
      IDADEMAE >= 35 & IDADEMAE < 40 ~ "35 a 39 anos",
      IDADEMAE >= 40 & IDADEMAE < 45 ~ "40 a 44 anos",
      IDADEMAE >= 45 ~ "45 anos ou mais",
      TRUE ~ "Idade ignorada"
    ),
    
    # 7. PRESENÇA DE ANOMALIA CONGÊNITA
    anomalia_desc = case_when(
      IDANOMAL == "1" ~ "Com anomalia",
      IDANOMAL == "2" ~ "Sem anomalia",
      IDANOMAL == "9" ~ "Ignorado",
      TRUE ~ "Sem informação"
    ),
    
    # 8. BAIXO PESO
    baixo_peso_desc = case_when(
      PESO < 2500 ~ "Baixo peso (<2500g)",
      PESO >= 2500 & PESO < 4000 ~ "Peso adequado (2500g a 3999g)",
      PESO >= 4000 ~ "Peso elevado (>=4000g)",
      TRUE ~ "Peso ignorado"
    ),
    
    # 9. PREMATURIDADE
    prematuro_desc = case_when(
      GESTACAO %in% c(1, 2) ~ "Prematuridade extrema",
      GESTACAO %in% c(3, 4) ~ "Pré-termo",
      GESTACAO == 5 ~ "A termo",
      GESTACAO == 6 ~ "Pós-termo",
      GESTACAO == 9 ~ "Ignorado",
      TRUE ~ "Sem informação"
    )
  )


glimpse(dados_tratados)


#Tabela decodificada#

tabela_decodificada <- dados_tratados %>%
  select(
    ano,
    sexo_desc,
    parto_desc,
    localnasc_desc,
    racacor_desc,
    faixa_etaria_desc,
    anomalia_desc,
    baixo_peso_desc,
    prematuro_desc
  )

glimpse(tabela_decodificada)
View(tabela_decodificada)


#Para salvar as tabelas em CSV

write.csv(dados_gerais,"dados_gerais_RJ_2022_2023.csv", row.names = FALSE)
write.csv(tabela_codificada, "dados_codificados.csv", row.names = FALSE)
write.csv(tabela_decodificada, "dados_decodificados.csv", row.names = FALSE)
cat("\n✅ Arquivos salvos com sucesso!\n")


#--------------------------------------------------------------------------------------------------------------

#-------------------------------------# Para o boletim que será feito #---------------------------------------#


#Agora tratando os dados para o boletim

if (!require("writexl")) install.packages("writexl")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("scales")) install.packages("scales")

library(writexl)
library(ggplot2)
library(scales)


# 1. PERFIL DE NASCIMENTOS - TABELAS DE NÚMEROS BRUTOS
# =====================================================

# 1.1 Total de nascimentos por ano
tab_total_nasc <- dados_tratados %>%
  group_by(ano) %>%
  summarise(Total = n(), .groups = "drop") %>%
  group_by(ano) %>%
  mutate(Percentual = round(Total / sum(Total) * 100, 2)) %>%
  ungroup()

# 1.2 Total de nascimentos por sexo, por ano
tab_sexo <- dados_tratados %>%
  group_by(ano, sexo_desc) %>%
  summarise(Total = n(), .groups = "drop") %>%
  group_by(ano) %>%
  mutate(Percentual = round(Total / sum(Total) * 100, 2)) %>%
  ungroup()

# 1.3 Total de nascimentos por tipo de parto, por ano
tab_parto <- dados_tratados %>%
  group_by(ano, parto_desc) %>%
  summarise(Total = n(), .groups = "drop") %>%
  group_by(ano) %>%
  mutate(Percentual = round(Total / sum(Total) * 100, 2)) %>%
  ungroup()

# 1.4 Total de nascimentos por local do nascimento, por ano
tab_local <- dados_tratados %>%
  group_by(ano, localnasc_desc) %>%
  summarise(Total = n(), .groups = "drop") %>%
  group_by(ano) %>%
  mutate(Percentual = round(Total / sum(Total) * 100, 2)) %>%
  ungroup()

# =====================================================
# 2. PERFIL DA MÃE - TABELAS DE NÚMEROS BRUTOS
# =====================================================

# 2.1 Total de nascimentos por faixa etária da mãe, por ano
tab_idade <- dados_tratados %>%
  group_by(ano, faixa_etaria_desc) %>%
  summarise(Total = n(), .groups = "drop") %>%
  group_by(ano) %>%
  mutate(Percentual = round(Total / sum(Total) * 100, 2)) %>%
  ungroup()

# 2.2 Total de nascimentos por raça/cor da mãe, por ano
tab_raca <- dados_tratados %>%
  group_by(ano, racacor_desc) %>%
  summarise(Total = n(), .groups = "drop")%>%
  group_by(ano) %>%
  mutate(perc = round(Total / sum(Total) * 100, 2)) %>%
  ungroup()

# 2.3 Total de nascimentos por escolaridade da mãe, por ano
tab_escolaridade <- dados_tratados %>%
  group_by(ano, escolaridade_desc) %>%
  summarise(Total = n(), .groups = "drop") %>%
  group_by(ano) %>%
  mutate(Percentual = round(Total / sum(Total) * 100, 2)) %>%
  ungroup()





# =====================================================
# 3. PERFIL DO RECÉM-NASCIDO - TABELAS DE NÚMEROS BRUTOS
# =====================================================

# 3.1 Total de presença de anomalia congênita 
tab_anomalia <- dados_tratados %>%
  group_by(ano, anomalia_desc) %>%
  summarise(Total = n(), .groups = "drop") %>%
  group_by(ano) %>%
  mutate(Percentual = round(Total / sum(Total) * 100, 2)) %>%
  ungroup()

# 3.2 Total de nascimentos com baixo peso ao nascer 
tab_baixo_peso <- dados_tratados %>%
  group_by(ano, baixo_peso_desc) %>%
  summarise(Total = n(), .groups = "drop") %>%
  group_by(ano) %>%
  mutate(Percentual = round(Total / sum(Total) * 100, 2)) %>%
  ungroup()

# 3.3 Total de nascimentos prematuros 
tab_prematuro <- dados_tratados %>%
  group_by(ano, prematuro_desc) %>%
  summarise(Total = n(), .groups = "drop") %>%
  group_by(ano) %>%
  mutate(Percentual = round(Total / sum(Total) * 100, 2)) %>%
  ungroup() %>%
  rename(prematuro_desc = prematuro_desc)


# =====================================================
# 4. VISUALIZAÇÃO DE TODAS AS TABELAS
# =====================================================

# Lista com todas as tabelas
todas_tabelas <- list(
  "1.1 Total de Nascimentos" = tab_total_nasc,
  "1.2 Nascimentos por Sexo" = tab_sexo,
  "1.3 Nascimentos por Tipo de Parto" = tab_parto,
  "1.4 Nascimentos por Local" = tab_local,
  "2.1 Faixa Etaria da Mae" = tab_idade,
  "2.2 Raca_Cor da Mae" = tab_raca,
  "2.3 Escolaridade da Mae" = tab_escolaridade,
  "3.1 Anomalia Congenita" = tab_anomalia,
  "3.2 Baixo Peso ao Nascer" = tab_baixo_peso,
  "3.3 Prematuridade" = tab_prematuro
)

# Visualizar todas no console
cat("\n\n📊 RELATÓRIO DE NASCIMENTOS - RJ 2022/2023\n")
cat(paste(rep("=", 70), collapse = ""), "\n\n")

for(i in seq_along(todas_tabelas)) {
  cat("\n", names(todas_tabelas)[i], "\n")
  cat(paste(rep("-", 50), collapse = ""), "\n")
  print(todas_tabelas[[i]])
  cat("\n")
}





#______________________________Ultima atualização 29/05/2026 - 16:13 - por SGM __________________________________#