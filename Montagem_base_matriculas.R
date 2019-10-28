#Montagem base do total de matrículas
#MATRICULAS ENTRE 1997 E 2005
matriculasDF0.1997_2005 <- readRDS("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\matriculas1999_2005")
matriculasDF1.1997_2005 <- copy(matriculasDF0.1997_2005)
matriculasDF1.1997_2005[, COD_MUNIC := paste(substr(COD_MUNIC, 1, 2), substr(COD_MUNIC, 8, 12), sep = "")]
matriculasDF1.1997_2005[, TOTAL_MATRICULAS := MAT_ENS.INF + MAT_EF + MAT_EM + MAT_EJA]
matriculasDF1.1997_2005$ID_ESCOLA %<>% as.character()
matriculasDF1.1997_2005$ANO %<>% as.character()
dim(matriculasDF1.1997_2005)

matriculasDF2.1997_2005 <- matriculasDF1.1997_2005[matriculasDF1.1997_2005$COD_FUNC == "Ativo" & matriculasDF1.1997_2005$DEP != "Particular", ]
dim(matriculasDF2.1997_2005)
matriculasDF3.1997_2005 <- matriculasDF2.1997_2005[, .(TOTAL_MATRICULAS = sum(TOTAL_MATRICULAS)), by = .(ANO, COD_MUNIC)]


#MATRICULAS ENTRE 2007 E 2017
total.matriculas.2007 <- readRDS("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total.matriculas2007DT")
setDT(total.matriculas.2007)[, ANO := "2007"]
total.matriculas.2007 %<>% rename(ETAPA_ENSINO = FK_COD_ETAPA_ENSINO)

total.matriculas.2009 <- readRDS("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total.matriculas2009DT")
setDT(total.matriculas.2009)[, ANO := "2009"]
total.matriculas.2009 %<>% rename(ETAPA_ENSINO = FK_COD_ETAPA_ENSINO)

total.matriculas.2011 <- readRDS("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total.matriculas2011DT")
setDT(total.matriculas.2011)[, ANO := "2011"]
total.matriculas.2011 %<>% rename(ETAPA_ENSINO = FK_COD_ETAPA_ENSINO)

total.matriculas.2013 <- readRDS("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total.matriculas2013DT")
setDT(total.matriculas.2013)[, ANO := "2013"]
total.matriculas.2013 %<>% rename(ETAPA_ENSINO = FK_COD_ETAPA_ENSINO)

total.matriculas.2015 <- readRDS("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total.matriculas2015DT")
setDT(total.matriculas.2015)[, ANO := "2015"]
total.matriculas.2015 %<>% rename(COD_MUNIC = CO_MUNICIPIO, ETAPA_ENSINO = TP_ETAPA_ENSINO)

total.matriculas.2017 <- readRDS("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total.matriculas2017DT")
setDT(total.matriculas.2017)[, ANO := "2017"]
total.matriculas.2017 %<>% rename(COD_MUNIC = CO_MUNICIPIO, ETAPA_ENSINO = TP_ETAPA_ENSINO)

total.matriculas2007_2017 <- rbind(total.matriculas.2007, total.matriculas.2009, total.matriculas.2011, total.matriculas.2013, total.matriculas.2015, 
                                   total.matriculas.2017)

municipiosDF1 <- readRDS("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\codigos_municipios")

total.matriculas2007_2017 <- merge(total.matriculas2007_2017, municipiosDF1, by = "COD_MUNIC", all.x = TRUE)
total.matriculas2007_2017 %<>% select(ANO, UF, COD_MESO, COD_MICRO, COD_MUNIC, NOME_UF, MESORREGIAO, MICRORREGIAO, MUNIC, LOC, ETAPA_ENSINO, MATRICULAS)

write.csv2(total.matriculas2007_2017, 
           "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\total_matriculas_2007-2017.csv", 
           row.names = FALSE)
rm(total.matriculas.2007, total.matriculas.2009, total.matriculas.2011, total.matriculas.2013, total.matriculas.2015, total.matriculas.2017)


#Matriculas por etapa de ensino
total.matriculas2007_2017.etapas <- copy(total.matriculas2007_2017)
setDT(total.matriculas2007_2017.etapas)[total.matriculas2007_2017.etapas$ETAPA_ENSINO == "1", CRECHE := MATRICULAS]

total.matriculas2007_2017.etapas[total.matriculas2007_2017.etapas$ETAPA_ENSINO == "2", PRE.ESC := MATRICULAS]

total.matriculas2007_2017.etapas[total.matriculas2007_2017.etapas$ETAPA_ENSINO %in% c(seq(4, 7, 1), seq(15, 18, 1)), EF_1 := MATRICULAS]

total.matriculas2007_2017.etapas[total.matriculas2007_2017.etapas$ETAPA_ENSINO %in% c(seq(8, 11, 1), seq(19, 21, 1), 41), EF_2 := MATRICULAS]

total.matriculas2007_2017.etapas[total.matriculas2007_2017.etapas$ETAPA_ENSINO %in% c(seq(25, 29, 1), seq(35, 38, 1)), EM := MATRICULAS]

total.matriculas2007_2017.etapas[total.matriculas2007_2017.etapas$ETAPA_ENSINO %in% seq(30, 34, 1), EM_I := MATRICULAS]

total.matriculas2007_2017.etapas[total.matriculas2007_2017.etapas$ETAPA_ENSINO %in% c(65, 67, 69, 70, 71, 73, 74), EJA := MATRICULAS]

total.matriculas2007_2017.etapas[is.na(total.matriculas2007_2017.etapas),] <- 0

total.matriculas2007_2017.etapas.loc <- total.matriculas2007_2017.etapas[, lapply(.SD, sum), .SDcols = c("CRECHE", "PRE.ESC", "EF_1", "EF_2", "EM", "EM_I", "EJA"), by = .(ANO, COD_MUNIC, LOC)]

write.csv2(total.matriculas2007_2017.etapas.loc, 
           "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\total_matriculas_2007-2017_etapa_loc.csv", 
           row.names = FALSE)


#matriculas2007_17 <- rbind(total.matriculas.munic2007, total.matriculas.munic2009, total.matriculas.munic2011, total.matriculas.munic2013, total.matriculas.munic2015, 
#                           total.matriculas.munic2017)
#matriculas2007_17 %<>% rename(COD_MUNIC = MUNICIPIO)
#saveRDS(matriculas2007_17, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\matriculas.pub.ativas.1997_2017")
#rm(total.matriculas.munic2007, total.matriculas.munic2009, total.matriculas.munic2011, total.matriculas.munic2013, total.matriculas.munic2015, 
#   total.matriculas.munic2017)

#BASE FINAL COM AS MATRÍCULAS DE TODO O PERÍODO 1997-2017
#matriculas1997_2017 <- rbind(matriculasDF3.1997_2005, matriculas2007_17)

#matriculas1997_2017 <- merge(matriculas1997_2017, municipiosDF2)
#saveRDS(matriculas1997_2017, 
#        file = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\matriculas.ativas1997_2017")
#rm(matriculas2007_17, matriculasDF0.1997_2005, matriculasDF0.1999_2005, matriculasDF1.1997_2005, matriculasDF1.1999_2005, matriculasDF2.1997_2005, 
#   matriculasDF2.1999_2005, matriculasDF3.1997_2005)
   