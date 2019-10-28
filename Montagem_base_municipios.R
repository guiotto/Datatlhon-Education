#Criando a base de municípios
library(readxl)
municipiosDF0 <- read_xls("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\codigo_municipios_ibge_sem_acento.xls")
dim(municipiosDF0)
municipiosDF1 <- copy(municipiosDF0)
municipiosDF1 %<>% mutate_all(toupper)
municipiosDF1 %<>% rename(UF = uF, NOME_UF = Nome_uF, COD_MESO = `Mesorregiao Geografica`, MESORREGIAO = Nome_Mesorregiao, COD_MICRO = `Microrregiao Geografica`,
                          MICRORREGIAO = Nome_Microrregiao,  COD_MUNIC = `Codigo Municipio Completo`, MUNIC = Nome_Municipio)
saveRDS(municipiosDF1, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\codigos_municipios")
rm(municipiosDF0)

