#2015
#Salvando as importações como um único arquivo: regiões em conjunto
matriculas2015completo <- ffdfappend(x = NULL, dat = MATRICULA_CO2015.CSV)
matriculas2015completo %<>% ffdfappend(MATRICULA_NORDESTE2015.CSV) 
matriculas2015completo %<>% ffdfappend(MATRICULA_NORTE2015.CSV) 
matriculas2015completo %<>% ffdfappend(MATRICULA_SUDESTE2015.CSV)
matriculas2015completo %<>% ffdfappend(MATRICULA_SUL2015.CSV)
save.ffdf(dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP\\CENSO2015_MATRICULAS_COMPLETO", 
          matriculas2015completo)



matriculas2015filtros <-  subset.ffdf(matriculas2015completo, select = c("NU_ANO_CENSO", "ID_MATRICULA", "CO_PESSOA_FISICA", "TP_ETAPA_ENSINO", 
                                                                         "ID_TURMA", "TP_UNIFICADA", "CO_ENTIDADE", "CO_UF", "CO_MUNICIPIO", 
                                                                         "TP_DEPENDENCIA", "TP_LOCALIZACAO", "TP_TIPO_TURMA"))
save.ffdf(matriculas2015filtros, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP\\CENSO2015_MATRICULAS_FILTROS2015")
rm(list=c("MATRICULA_CO2015.CSV", "MATRICULA_NORDESTE2015.CSV", "MATRICULA_NORTE2015.CSV", "MATRICULA_SUDESTE2015.CSV", "MATRICULA_SUL2015.CSV", 
          "matriculas2015completo"))

matriculas2015filtradas <- matriculas2015filtros
dim(matriculas2015filtradas)
total.matriculas2015.DF0 <- subset.ffdf(matriculas2015filtradas, TP_DEPENDENCIA != 4 & TP_TIPO_TURMA != 4 & TP_TIPO_TURMA != 5)
dim(total.matriculas2015.DF0)
save.ffdf(total.matriculas2015.DF0, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total_matriculas2015", 
          overwrite = TRUE)

matriculas2015.ativas <- merge.ffdf(total.matriculas2015.DF0, escolas1999_2017.Pub.Ativas.ff, by.x = c("NU_ANO_CENSO", "CO_ENTIDADE"), by.y = c("ANO", "ID_ESCOLA"),
                                    trace = 2)
dim(matriculas2015.ativas)

matriculas2015.ativas.mun <- subset.ffdf(matriculas2015.ativas[!duplicated.ff(matriculas2015.ativas$ID_MATRICULA), ], 
                                         select = c("NU_ANO_CENSO", "ID_MATRICULA", "CO_PESSOA_FISICA","TP_TIPO_TURMA", "TP_ETAPA_ENSINO", "CO_MUNICIPIO", 
                                                    "CO_ENTIDADE", "TP_DEPENDENCIA"))
dim(matriculas2015.ativas.mun)

save.ffdf(matriculas2015.ativas.mun, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\matriculas-ativas-munic2015", 
          overwrite = TRUE)
rm(total.matriculas2015.DF0)

# Total de matrículas, por município e etapa de ensino
matriculas2015 <- as.data.table(matriculas2015.ativas.mun)
rm(matriculas2015.ativas.mun)
saveRDS(matriculas2015, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\matriculas2015DT")

matriculas2015$CO_ENTIDADE %<>% as.character()
matriculas2015$CO_MUNICIPIO %<>% as.character()

matriculas2015 <- left_join(matriculas2015, escolas2015, by = c("CO_ENTIDADE" = "ID_ESCOLA", "CO_MUNICIPIO" = "COD_MUNIC"))

total.matriculas.2015 <- setDT(matriculas2015)[, .(MATRICULAS = .N), by = .(CO_MUNICIPIO, TP_ETAPA_ENSINO, LOC)]

saveRDS(total.matriculas.2015, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total.matriculas2015DT")
rm(matriculas2015)

#total.matriculas.munic2015 <- table.ff(matriculas2015.ativas.mun$CO_MUNICIPIO)
#total.matriculas.munic2015 <- cbind(read.table(text = names(total.matriculas.munic2015)), total.matriculas.munic2015)
#setDT(total.matriculas.munic2015)[, ANO := "2015"]
#total.matriculas.munic2015 %>% rename(MUNICIPIO = Var1, TOTAL_MATRICULAS = Freq) %>% select(ANO, MUNICIPIO, TOTAL_MATRICULAS) -> total.matriculas.munic2015
#rm(matriculas2015.ativas.mun)
