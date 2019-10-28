#2013
#Salvando as importações como um único arquivo: regiões em conjunto
matriculas2013completo <- ffdfappend(x = NULL, dat = MATRICULA_CO2013.CSV)
matriculas2013completo %<>% ffdfappend(MATRICULA_NORDESTE2013.CSV) 
matriculas2013completo %<>% ffdfappend(MATRICULA_NORTE2013.CSV) 
matriculas2013completo %<>% ffdfappend(MATRICULA_SUDESTE2013.CSV)
matriculas2013completo %<>% ffdfappend(MATRICULA_SUL2013.CSV)
save.ffdf(dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP\\CENSO2013_MATRICULAS_COMPLETO", 
          matriculas2013completo)



matriculas2013filtros <-  subset.ffdf(matriculas2013completo, select = c("ANO_CENSO", "PK_COD_MATRICULA", "FK_COD_ALUNO", "FK_COD_MOD_ENSINO", "FK_COD_ETAPA_ENSINO", 
                                                                         "PK_COD_TURMA", "COD_UNIFICADA", "PK_COD_ENTIDADE", "COD_MUNICIPIO_ESCOLA", 
                                                                         "ID_DEPENDENCIA_ADM_ESC", "FK_COD_TIPO_TURMA"))
save.ffdf(matriculas2013filtros, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP\\CENSO2013_MATRICULAS_FILTROS2013")
rm(list=c("MATRICULA_CO2013.CSV", "MATRICULA_NORDESTE2013.CSV", "MATRICULA_NORTE2013.CSV", "MATRICULA_SUDESTE2013.CSV", "MATRICULA_SUL2013.CSV", 
           "matriculas2013completo"))

matriculas2013filtradas <- matriculas2013filtros
dim(matriculas2013filtradas)
total.matriculas2013.DF0 <- subset.ffdf(matriculas2013filtradas, ID_DEPENDENCIA_ADM_ESC != 4 & FK_COD_TIPO_TURMA != 4 & FK_COD_TIPO_TURMA != 5)
dim(total.matriculas2013.DF0)
save.ffdf(total.matriculas2013.DF0, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total_matriculas2013", 
          overwrite = TRUE)

matriculas2013.ativas <- merge.ffdf(total.matriculas2013.DF0, escolas1999_2017.Pub.Ativas.ff, by.x = c("ANO_CENSO", "PK_COD_ENTIDADE"), by.y = c("ANO", "ID_ESCOLA"),
                                    trace = 2)
dim(matriculas2013.ativas)

matriculas2013.ativas.mun <- subset.ffdf(matriculas2013.ativas[!duplicated.ff(matriculas2013.ativas$PK_COD_MATRICULA), ], 
                                         select = c("ANO_CENSO", "PK_COD_MATRICULA", "FK_COD_MOD_ENSINO", "FK_COD_ETAPA_ENSINO", "COD_MUNIC", 
                                                    "PK_COD_ENTIDADE", "DEP"))

save.ffdf(matriculas2013.ativas.mun, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\matriculas-ativas-munic2013", 
          overwrite = TRUE)
rm(total.matriculas2013.DF0)

# Total de matrículas, por município e etapa de ensino
matriculas2013 <- as.data.table(matriculas2013.ativas.mun)
rm(matriculas2013.ativas.mun)
saveRDS(matriculas2013, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\matriculas2013DT")

matriculas2013$PK_COD_ENTIDADE %<>% as.character()
matriculas2013$COD_MUNIC %<>% as.character()

matriculas2013 <- left_join(matriculas2013, escolas2013, by = c("PK_COD_ENTIDADE" = "ID_ESCOLA", "COD_MUNIC" = "COD_MUNIC"))

total.matriculas.2013 <- setDT(matriculas2013)[, .(MATRICULAS = .N), by = .(COD_MUNIC, FK_COD_ETAPA_ENSINO, LOC)]

saveRDS(total.matriculas.2013, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total.matriculas2013DT")
rm(matriculas2013)

#total.matriculas.munic2013 <- table.ff(matriculas2013.ativas.mun$COD_MUNIC)
#total.matriculas.munic2013 <- cbind(read.table(text = names(total.matriculas.munic2013)), total.matriculas.munic2013)
#setDT(total.matriculas.munic2013)[, ANO := "2013"]
##total.matriculas.munic2013 %>% rename(MUNICIPIO = Var1, TOTAL_MATRICULAS = Freq) %>% select(ANO, MUNICIPIO, TOTAL_MATRICULAS) -> total.matriculas.munic2013
#rm(matriculas2013.ativas.mun)