#Salvando as importações como um único arquivo: regiões em conjunto
matriculas2009completo <- ffdfappend(x = NULL, dat = MATRICULA_CO2009.CSV)
matriculas2009completo %<>% ffdfappend(MATRICULA_NORDESTE2009.CSV) 
matriculas2009completo %<>% ffdfappend(MATRICULA_NORTE2009.CSV) 
matriculas2009completo %<>% ffdfappend(MATRICULA_SUDESTE2009.CSV)
matriculas2009completo %<>% ffdfappend(MATRICULA_SUL2009.CSV)
save.ffdf(dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP\\CENSO2009_MATRICULAS_COMPLETO", 
          matriculas2009completo)



matriculas2009filtros <-  subset.ffdf(matriculas2009completo, select = c("ANO_CENSO", "PK_COD_MATRICULA", "FK_COD_ALUNO", "FK_COD_MOD_ENSINO", "FK_COD_ETAPA_ENSINO", 
                                                                         "PK_COD_TURMA", "COD_UNIFICADA", "PK_COD_ENTIDADE", "COD_MUNICIPIO_ESCOLA", 
                                                                         "ID_DEPENDENCIA_ADM_ESC", "FK_COD_TIPO_TURMA"))
save.ffdf(matriculas2009filtros, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP\\CENSO2009_MATRICULAS_FILTROS2009")
rm(list=c("MATRICULA_CO2009.CSV", "MATRICULA_NORDESTE2009.CSV", "MATRICULA_NORTE2009.CSV", "MATRICULA_SUDESTE2009.CSV", "MATRICULA_SUL2009.CSV", 
           "matriculas2009completo"))

matriculas2009filtradas <- matriculas2009filtros
dim(matriculas2009filtradas)
total.matriculas2009.DF0 <- subset.ffdf(matriculas2009filtradas, ID_DEPENDENCIA_ADM_ESC != 4 & FK_COD_TIPO_TURMA != 4 & FK_COD_TIPO_TURMA != 5)
dim(total.matriculas2009.DF0)
save.ffdf(total.matriculas2009.DF0, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total_matriculas2009", 
          overwrite = TRUE)

matriculas2009.ativas <- merge.ffdf(total.matriculas2009.DF0, escolas1999_2017.Pub.Ativas.ff, by.x = c("ANO_CENSO", "PK_COD_ENTIDADE"), by.y = c("ANO", "ID_ESCOLA"),
                                    trace = 2)
dim(matriculas2009.ativas)

matriculas2009.ativas.mun <- subset.ffdf(matriculas2009.ativas[!duplicated.ff(matriculas2009.ativas$PK_COD_MATRICULA), ], 
                                         select = c("ANO_CENSO", "PK_COD_MATRICULA", "FK_COD_ALUNO","FK_COD_MOD_ENSINO", "FK_COD_ETAPA_ENSINO", "COD_MUNIC", 
                                                    "PK_COD_ENTIDADE", "DEP"))

save.ffdf(matriculas2009.ativas.mun, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\matriculas-ativas-munic2009", 
          overwrite = TRUE)
rm(total.matriculas2009.DF0)

# Total de matrículas, por município e etapa de ensino
matriculas2009 <- as.data.table(subset.ffdf(matriculas2009.ativas.mun, select = c("PK_COD_MATRICULA", "FK_COD_ETAPA_ENSINO", "COD_MUNIC", "PK_COD_ENTIDADE")))
matriculas2007$PK_COD_ENTIDADE %<>% as.character()
rm(matriculas2009.ativas.mun)
saveRDS(matriculas2009, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\matriculas2009DT")

matriculas2009$PK_COD_ENTIDADE %<>% as.character()
matriculas2009$COD_MUNIC %<>% as.character()

matriculas2009 <- left_join(matriculas2009, escolas2009, by = c("PK_COD_ENTIDADE" = "ID_ESCOLA", "COD_MUNIC" = "COD_MUNIC"))
matriculas2009[, PK_COD_MATRICULA := NULL]
matriculas2009$FK_COD_ETAPA_ENSINO %<>% as.character()
matriculas2009$LOC %<>% as.character()

saveRDS(matriculas2009, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\matriculas2009DT_sub")
saveRDS(escolas2009, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\escolas2009DT")

total.matriculas.2009 <- matriculas2009[, .(MATRICULAS = .N), by = .(COD_MUNIC, FK_COD_ETAPA_ENSINO, LOC)]

saveRDS(total.matriculas.2009, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total.matriculas2009DT")
rm(matriculas2009)


#total.matriculas.munic2009 <- table.ff(matriculas2009.ativas.mun$COD_MUNIC)
#total.matriculas.munic2009 <- cbind(read.table(text = names(total.matriculas.munic2009)), total.matriculas.munic2009)
#setDT(total.matriculas.munic2009)[, ANO := "2009"]
#total.matriculas.munic2009 %>% rename(MUNICIPIO = Var1, TOTAL_MATRICULAS = Freq) %>% select(ANO, MUNICIPIO, TOTAL_MATRICULAS) -> total.matriculas.munic2009
#rm(matriculas2009.ativas.mun)
