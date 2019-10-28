#2017
#Salvando as importações como um único arquivo: regiões em conjunto
matriculas2017completo <- ffdfappend(x = NULL, dat = MATRICULA_CO2017.CSV)
matriculas2017completo %<>% ffdfappend(MATRICULA_NORDESTE2017.CSV) 
matriculas2017completo %<>% ffdfappend(MATRICULA_NORTE2017.CSV) 
matriculas2017completo %<>% ffdfappend(MATRICULA_SUDESTE2017.CSV)
matriculas2017completo %<>% ffdfappend(MATRICULA_SUL2017.CSV)
save.ffdf(dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP\\CENSO2017_MATRICULAS_COMPLETO", 
          matriculas2017completo)



matriculas2017filtros <-  subset.ffdf(matriculas2017completo, select = c("NU_ANO_CENSO", "ID_MATRICULA", "CO_PESSOA_FISICA", "TP_ETAPA_ENSINO", 
                                                                         "ID_TURMA", "TP_UNIFICADA", "CO_ENTIDADE", "CO_UF", "CO_MUNICIPIO", 
                                                                         "TP_DEPENDENCIA", "TP_LOCALIZACAO", "TP_TIPO_TURMA"))

save.ffdf(matriculas2017filtros, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP\\CENSO2017_MATRICULAS_FILTROS2017")
rm(list=c("MATRICULA_CO2017.CSV", "MATRICULA_NORDESTE2017.CSV", "MATRICULA_NORTE2017.CSV", "MATRICULA_SUDESTE2017.CSV", "MATRICULA_SUL2017.CSV", 
          "matriculas2017completo"))

matriculas2017filtradas <- matriculas2017filtros
dim(matriculas2017filtradas)
total.matriculas2017.DF0 <- subset.ffdf(matriculas2017filtradas, TP_DEPENDENCIA != 4 & TP_TIPO_TURMA != 4 & TP_TIPO_TURMA != 5)
dim(total.matriculas2017.DF0)
save.ffdf(total.matriculas2017.DF0, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total_matriculas2017", 
          overwrite = TRUE)

matriculas2017.ativas <- merge.ffdf(total.matriculas2017.DF0, escolas1999_2017.Pub.Ativas.ff, by.x = c("NU_ANO_CENSO", "CO_ENTIDADE"), by.y = c("ANO", "ID_ESCOLA"),
                                    trace = 2)
dim(matriculas2017.ativas)

matriculas2017.ativas.mun <- subset.ffdf(matriculas2017.ativas[!duplicated.ff(matriculas2017.ativas$ID_MATRICULA), ], 
                                         select = c("NU_ANO_CENSO", "ID_MATRICULA", "CO_PESSOA_FISICA","TP_TIPO_TURMA", "TP_ETAPA_ENSINO", "CO_MUNICIPIO", 
                                                    "CO_ENTIDADE", "TP_DEPENDENCIA"))

save.ffdf(matriculas2017.ativas.mun, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\matriculas-ativas-munic2017", 
          overwrite = TRUE)
rm(total.matriculas2015.DF0)

# Total de matrículas, por município e etapa de ensino
matriculas2017 <- as.data.table(matriculas2017.ativas.mun)
rm(matriculas2017.ativas.mun)
saveRDS(matriculas2017, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\matriculas2017DT")

matriculas2017$CO_ENTIDADE %<>% as.character()
matriculas2017$CO_MUNICIPIO %<>% as.character()

matriculas2017 <- left_join(matriculas2017, escolas2017, by = c("CO_ENTIDADE" = "ID_ESCOLA", "CO_MUNICIPIO" = "COD_MUNIC"))

total.matriculas.2017 <- setDT(matriculas2017)[, .(MATRICULAS = .N), by = .(CO_MUNICIPIO, TP_ETAPA_ENSINO, LOC)]

saveRDS(total.matriculas.2017, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total.matriculas2017DT")
rm(matriculas2017)

#total.matriculas.munic2017 <- table(matriculas2017.ativas.mun$CO_MUNICIPIO)
#total.matriculas.munic2017 <- cbind(read.table(text = names(total.matriculas.munic2017)), total.matriculas.munic2017)
#setDT(total.matriculas.munic2017)[, ANO := "2017"]
#total.matriculas.munic2017 %>% rename(MUNICIPIO = Var1, TOTAL_MATRICULAS = Freq) %>% select(ANO, MUNICIPIO, TOTAL_MATRICULAS) -> total.matriculas.munic2017
#rm(matriculas2017.ativas.mun)