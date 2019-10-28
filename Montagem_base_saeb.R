#Base final
diretorio <- "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Saeb"
setwd(diretorio)
list.files(diretorio, pattern = "1999") %>% map_df(~ read.csv2(.)) -> saeb1999
saeb1999 %>% select(c(MASCARA, ANO, SERIE, DISC, ESTRATO, UPA, PESO_AC, PROFIC)) %>% 
  rename(ID_ESCOLA = MASCARA, DISCIPLINA = DISC, ESTRATO_AM = ESTRATO, UP_AM = UPA) -> saeb1999_filtro
rm(saeb1999)

saeb1999_filtro$ID_ESCOLA %<>% as.character()
saeb1999_filtro$ANO %<>% as.character()
saeb1999_filtro$SERIE %<>% as.character()
saeb1999_filtro[saeb1999_filtro$SERIE == "3", "SERIE"] <- "11"
saeb1999_filtro$ESTRATO_AM %<>% as.character()
saeb1999_filtro$UP_AM %<>% as.character()


list.files(diretorio, pattern = "2001") %>% map_df(~ read.csv2(.)) -> saeb2001
saeb2001 %>% select(c(MASCARA, ANO, SERIE, DISC, ESTRATO, UPA, PESO_AC, RESP_BL1, RESP_BL2, RESP_BL3, PROFIC)) %>%
  rename(ID_ESCOLA = MASCARA, DISCIPLINA = DISC, ESTRATO_AM = ESTRATO, UP_AM = UPA) -> saeb2001_filtro
rm(saeb2001)

saeb2001_filtro$ID_ESCOLA %<>% as.character()
saeb2001_filtro$ANO %<>% as.character()
saeb2001_filtro$SERIE %<>% as.character()
saeb2001_filtro$ESTRATO_AM %<>% as.character()
saeb2001_filtro$UP_AM %<>% as.character()

setDT(saeb2001_filtro)[, MAIS3_ITENS := 
                         ifelse((str_count(RESP_BL1, pattern = " ") + str_count(RESP_BL2, pattern = " ") + 
                             str_count(RESP_BL3, pattern = " ")) > 36, "Remover", "Nao_remover")]
saeb2001_filtro %>% select(ID_ESCOLA, ANO, SERIE, DISCIPLINA, ESTRATO_AM, UP_AM, PESO_AC, PROFIC, MAIS3_ITENS) -> saeb2001_filtro1


list.files(diretorio, pattern = "2003") %>% map_df(~ read.csv2(.)) -> saeb2003
saeb2003 %>% select(c(MASCARA, ANO, SERIE, DISC, ESTRATO, UPA, PESO_AC, RESP_BL1, RESP_BL2, RESP_BL3, PROFIC)) %>%
  rename(ID_ESCOLA = MASCARA, DISCIPLINA = DISC, ESTRATO_AM = ESTRATO, UP_AM = UPA) -> saeb2003_filtro
rm(saeb2003)

saeb2003_filtro$ID_ESCOLA %<>% as.character()
saeb2003_filtro$ANO %<>% as.character()
saeb2003_filtro$SERIE %<>% as.character()
saeb2003_filtro$ESTRATO_AM %<>% as.character()
saeb2003_filtro$UP_AM %<>% as.character()

setDT(saeb2003_filtro)[, MAIS3_ITENS := 
                         ifelse((str_count(RESP_BL1, pattern = " ") + str_count(RESP_BL2, pattern = " ") + 
                                   str_count(RESP_BL3, pattern = " ")) > 36, "Remover", "Nao_remover")]
saeb2003_filtro %>% select(ID_ESCOLA, ANO, SERIE, DISCIPLINA, ESTRATO_AM, UP_AM, PESO_AC, PROFIC, MAIS3_ITENS) -> saeb2003_filtro1


list.files(diretorio, pattern = "2005") %>% map_df(~ read.csv2(.)) -> saeb2005
saeb2005 %>% select(-c(ANO_MASCARA, TURMA, NOMETURMA, TURMA_APLI, ALUNO, EXTRA, ALUNO_VALI, DEP_ADM, LOCAL, REDE, CODUF, REGIAO, CAPITAL, PESO_EC, PESO_TC, 
                       CADERNO, BLOCO1, BLOCO2, BLOCO3, GAB_BL1, GAB_BL2, GAB_BL3, PROFIC_SAEB)) %>%
  rename(ID_ESCOLA = MASCARA, DISCIPLINA = DISC, ESTRATO_AM = ESTRATO, PROFIC = PROFIC_25050) -> saeb2005_filtro
rm(saeb2005)


saeb2005_filtro$ID_ESCOLA %<>% as.character()
saeb2005_filtro$ANO %<>% as.character()
saeb2005_filtro$SERIE %<>% as.character()
saeb2005_filtro$ESTRATO_AM %<>% as.character()

setDT(saeb2005_filtro)[, RESP_CONCAT := 
                         unite(saeb2005_filtro, RESP_CONCAT, sep = "", -c(1:6, 46:49))[, "RESP_CONCAT"]]
saeb2005_filtro %>% select(ID_ESCOLA, ANO, SERIE, DISCIPLINA, ESTRATO_AM, PESO_AC, PROFIC,  RESP_CONCAT) -> saeb2005_filtro1
rm(saeb2005_filtro)

saeb2005_filtro1[ , MAIS3_ITENS := ifelse(str_count(saeb2005_filtro1$RESP_CONCAT, pattern = "[^ABCDE]") > 36, "Remover", "Nao_remover") ]
saeb2005_filtro1 %>% select(ID_ESCOLA, ANO, SERIE, DISCIPLINA, ESTRATO_AM, PESO_AC, PROFIC, MAIS3_ITENS) -> saeb2005_filtro2

saeb1999_2005DF0 <- rbind(saeb1999_filtro, saeb2001_filtro1, saeb2003_filtro1, saeb2005_filtro2, fill = TRUE)
saveRDS(saeb1999_2005DF0, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Saeb\\TEMP\\saeb1999_2005DF0")
rm(list=c("saeb1999_filtro", "saeb2001_filtro", "saeb2003_filtro", "saeb2003_filtro1", "saeb2005_filtro1", "saeb2005_filtro2"))
write.csv2(saeb1999_2005DF0, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Saeb\\saeb1999_2005.csv", 
           row.names = FALSE)

saeb1999_2005_munic <- left_join(saeb1999_2005DF0, escolas1999_2017.Pub.Ativas, by = c("ID_ESCOLA" = "ID_ESCOLA", "ANO" = "ANO"))
saeb1999_2005_munic <- saeb1999_2005_munic[!is.na(saeb1999_2005_munic$COD_MUNIC), ]
head(saeb1999_2005_munic)
write.csv2(saeb1999_2005_munic[, -c(1, 5, 6, 9, 10, 12)], 
           "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Saeb\\saeb1999_2005_munic.csv", 
           row.names = FALSE)
