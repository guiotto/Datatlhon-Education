# Montagem da base de escolas
#Escolas entre 1999-2005
escolas1999_2005.DF0 <- matriculas1999_2005[, c("ANO", "UF", "SIGLA_UF", "COD_MUNIC", "MUNIC", "ID_ESCOLA", "DEP", "LOC", "COD_FUNC")]
escolas1999_2005 %>% rename(FUNC = COD_FUNC) %>% select(-UF) -> escolas1999_2005
escolas1999_2005[, FUNC := ifelse(FUNC == "Ativo", "EM ATIVIDADE", ifelse(FUNC == "Extinto", "EXTINTA", "PARALISADA"))]
escolas1999_2005[, COD_UF := substr(COD_MUNIC, 1, 2)]
escolas1999_2005[, COD_MUNIC2 := substr(COD_MUNIC, 8, 12)]
escolas1999_2005[, COD_MUNIC.CONC := paste(COD_UF, COD_MUNIC2, sep = "")]

                 


dim(escolas1999_2005)
saveRDS(escolas1999_2005, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Saeb\\TEMP\\escolas1999_2005")

escolasDF0[, .N, by = ANO]

#Escolas 2007-17
censo2007_17dir <- "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP\\ESCOLAS"
setwd(censo2007_17dir)

escolas2007.DF0 <- read.csv2("ESCOLAS2007.csv", header = TRUE, sep = "|")
escolas2007.DF0 %>% select(ANO_CENSO, PK_COD_ENTIDADE, DESC_SITUACAO_FUNCIONAMENTO, FK_COD_ESTADO, FK_COD_MUNICIPIO, ID_DEPENDENCIA_ADM, 
                           ID_LOCALIZACAO) -> escolas2007.DF1
escolas2007.DF1 %<>% rename(ANO = ANO_CENSO, ID_ESCOLA = PK_COD_ENTIDADE, FUNC = DESC_SITUACAO_FUNCIONAMENTO, COD_UF = FK_COD_ESTADO, COD_MUNIC = FK_COD_MUNICIPIO,
                           DEP = ID_DEPENDENCIA_ADM, LOC = ID_LOCALIZACAO)

escolas2009.DF0 <- read.csv2("ESCOLAS2009.csv", header = TRUE, sep = "|")
escolas2009.DF0 %>% select(ANO_CENSO, PK_COD_ENTIDADE, DESC_SITUACAO_FUNCIONAMENTO, FK_COD_ESTADO, FK_COD_MUNICIPIO, ID_DEPENDENCIA_ADM, 
                           ID_LOCALIZACAO) -> escolas2009.DF1
escolas2009.DF1 %<>% rename(ANO = ANO_CENSO, ID_ESCOLA = PK_COD_ENTIDADE, FUNC = DESC_SITUACAO_FUNCIONAMENTO, COD_UF = FK_COD_ESTADO, COD_MUNIC = FK_COD_MUNICIPIO,
                          DEP = ID_DEPENDENCIA_ADM, LOC = ID_LOCALIZACAO)
setDT(escolas2009.DF1)[, FUNC := ifelse(FUNC == 1, "EM ATIVIDADE", ifelse(FUNC == 2, "PARALISADA", "EXTINTA"))]

escolas2011.DF0 <- read.csv2("ESCOLAS2011.csv", header = TRUE, sep = "|")
escolas2011.DF0 %>% select(ANO_CENSO, PK_COD_ENTIDADE, DESC_SITUACAO_FUNCIONAMENTO, FK_COD_ESTADO, FK_COD_MUNICIPIO, ID_DEPENDENCIA_ADM, 
                           ID_LOCALIZACAO) -> escolas2011.DF1
escolas2011.DF1 %<>% rename(ANO = ANO_CENSO, ID_ESCOLA = PK_COD_ENTIDADE, FUNC = DESC_SITUACAO_FUNCIONAMENTO, COD_UF = FK_COD_ESTADO, COD_MUNIC = FK_COD_MUNICIPIO,
                           DEP = ID_DEPENDENCIA_ADM, LOC = ID_LOCALIZACAO)
setDT(escolas2011.DF1)[, FUNC := ifelse(FUNC == 1, "EM ATIVIDADE", ifelse(FUNC == 2, "PARALISADA", "EXTINTA"))]


escolas2013.DF0 <- read.csv2("ESCOLAS2013.csv", header = TRUE, sep = "|")
escolas2013.DF0 %>% select(ANO_CENSO, PK_COD_ENTIDADE, DESC_SITUACAO_FUNCIONAMENTO, FK_COD_ESTADO, FK_COD_MUNICIPIO, ID_DEPENDENCIA_ADM, 
                           ID_LOCALIZACAO) -> escolas2013.DF1
escolas2013.DF1 %<>% rename(ANO = ANO_CENSO, ID_ESCOLA = PK_COD_ENTIDADE, FUNC = DESC_SITUACAO_FUNCIONAMENTO, COD_UF = FK_COD_ESTADO, COD_MUNIC = FK_COD_MUNICIPIO,
                           DEP = ID_DEPENDENCIA_ADM, LOC = ID_LOCALIZACAO)
setDT(escolas2013.DF1)[, FUNC := ifelse(FUNC == 1, "EM ATIVIDADE", ifelse(FUNC == 2, "PARALISADA", "EXTINTA"))]


escolas2015.DF0 <- read.csv2("ESCOLAS2015.csv", header = TRUE, sep = "|")  
escolas2015.DF0 %>% select(NU_ANO_CENSO, CO_ENTIDADE, TP_SITUACAO_FUNCIONAMENTO, CO_UF, CO_MUNICIPIO, TP_DEPENDENCIA, 
                           TP_LOCALIZACAO) -> escolas2015.DF1
escolas2015.DF1 %<>% rename(ANO = NU_ANO_CENSO, ID_ESCOLA = CO_ENTIDADE, FUNC = TP_SITUACAO_FUNCIONAMENTO, COD_UF = CO_UF, COD_MUNIC = CO_MUNICIPIO,
                           DEP = TP_DEPENDENCIA, LOC = TP_LOCALIZACAO)
setDT(escolas2015.DF1)[, FUNC := ifelse(FUNC == 1, "EM ATIVIDADE", ifelse(FUNC == 2, "PARALISADA", "EXTINTA"))]


escolas2017.DF0 <- read.csv2("ESCOLAS2017.csv", header = TRUE, sep = "|")
escolas2017.DF0 %>% select(NU_ANO_CENSO, CO_ENTIDADE, TP_SITUACAO_FUNCIONAMENTO, CO_UF, CO_MUNICIPIO, TP_DEPENDENCIA, 
                           TP_LOCALIZACAO) -> escolas2017.DF1
escolas2017.DF1 %<>% rename(ANO = NU_ANO_CENSO, ID_ESCOLA = CO_ENTIDADE, FUNC = TP_SITUACAO_FUNCIONAMENTO, COD_UF = CO_UF, COD_MUNIC = CO_MUNICIPIO,
           DEP = TP_DEPENDENCIA, LOC = TP_LOCALIZACAO)
setDT(escolas2017.DF1)[, FUNC := ifelse(FUNC == 1, "EM ATIVIDADE", ifelse(FUNC == 2, "PARALISADA", "EXTINTA"))]


escolas2007_2017 <- rbind(escolas2007.DF1, escolas2009.DF1, escolas2011.DF1, escolas2013.DF1, escolas2015.DF1, escolas2017.DF1)
escolas2007_2017[, DEP := ifelse(DEP == 1, "Federal", ifelse(DEP == 2, "Estadual", ifelse(DEP == 3, "Municipal", "Particular")))]
escolas2007_2017[, LOC := ifelse(LOC == 1, "Urbana", "Rural")]

saveRDS(escolas2007_2017, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\base_escolas2007-17")
rm(list=c("escolas2007.DF0", "escolas2007.DF1", "escolas2009.DF0", "escolas2009.DF1", "escolas2011.DF0", "escolas2011.DF1", "escolas2013.DF0", "escolas2013.DF1",
          "escolas2015.DF0", "escolas2015.DF1", "escolas2017.DF0", "escolas2017.DF1"))

#Na hora de rodar, reorganizar as coisas
escolas1999_2017.DF0 <- rbind(escolas1999_2005.DF1, escolas2007_2017)
saveRDS(escolas1999_2017.DF0, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\base_escolas1999-2017")

escolas1999_2017.Pub.Ativas <- copy(escolas1999_2017.DF0)
dim(escolas1999_2017.Pub.Ativas)
escolas1999_2017.Pub.Ativas <- escolas1999_2017.DF0[escolas1999_2017.DF0$DEP != "Particular" & 
                                                      escolas1999_2017.DF0$FUNC == "EM ATIVIDADE", ]
escolas1999_2017.Pub.Ativas$ANO %<>% as.character()
escolas1999_2017.Pub.Ativas$ID_ESCOLA %<>% as.character()
rm(escolas1999_2017.DF0)
dim(escolas1999_2017.Pub.Ativas)

escolas2007 <- escolas1999_2017.Pub.Ativas[escolas1999_2017.Pub.Ativas$ANO == "2007", c("ID_ESCOLA", "LOC", "COD_MUNIC")]
escolas2009 <- escolas1999_2017.Pub.Ativas[escolas1999_2017.Pub.Ativas$ANO == "2009", c("ID_ESCOLA", "LOC", "COD_MUNIC")]
escolas2011 <- escolas1999_2017.Pub.Ativas[escolas1999_2017.Pub.Ativas$ANO == "2011", c("ID_ESCOLA", "LOC", "COD_MUNIC")]
escolas2013 <- escolas1999_2017.Pub.Ativas[escolas1999_2017.Pub.Ativas$ANO == "2013", c("ID_ESCOLA", "LOC", "COD_MUNIC")]
escolas2015 <- escolas1999_2017.Pub.Ativas[escolas1999_2017.Pub.Ativas$ANO == "2015", c("ID_ESCOLA", "LOC", "COD_MUNIC")]
escolas2017 <- escolas1999_2017.Pub.Ativas[escolas1999_2017.Pub.Ativas$ANO == "2017", c("ID_ESCOLA", "LOC", "COD_MUNIC")]

escolas1999_2017.Pub.Ativas.ff <- escolas1999_2017.Pub.Ativas
escolas1999_2017.Pub.Ativas.ff$ANO %<>% as.factor()
escolas1999_2017.Pub.Ativas.ff$ID_ESCOLA %<>% as.factor()
escolas1999_2017.Pub.Ativas.ff$COD_MUNIC %<>% as.factor()
escolas1999_2017.Pub.Ativas.ff$COD_UF %<>% as.factor()
escolas1999_2017.Pub.Ativas.ff <- as.ffdf(escolas1999_2017.Pub.Ativas.ff)

                            