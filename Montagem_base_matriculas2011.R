#2011
#Salvando as importações como um único arquivo: regiões em conjunto
matriculas2011completo <- ffdfappend(x = NULL, dat = MATRICULA_CO2011.CSV)
matriculas2011completo %<>% ffdfappend(MATRICULA_NORDESTE2011.CSV) 
matriculas2011completo %<>% ffdfappend(MATRICULA_NORTE2011.CSV) 
matriculas2011completo %<>% ffdfappend(MATRICULA_SUDESTE2011.CSV)
matriculas2011completo %<>% ffdfappend(MATRICULA_SUL2011.CSV)
save.ffdf(dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP\\CENSO2011_MATRICULAS_COMPLETO", 
          matriculas2011completo)



matriculas2011filtros <-  subset.ffdf(matriculas2011completo, select = c("ANO_CENSO", "PK_COD_MATRICULA", "FK_COD_ALUNO", "FK_COD_MOD_ENSINO", "FK_COD_ETAPA_ENSINO", 
                                                                         "PK_COD_TURMA", "COD_UNIFICADA", "PK_COD_ENTIDADE", "COD_MUNICIPIO_ESCOLA", 
                                                                         "ID_DEPENDENCIA_ADM_ESC", "FK_COD_TIPO_TURMA"))
save.ffdf(matriculas2011filtros, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP\\CENSO2011_MATRICULAS_FILTROS2011")
rm(list=c("MATRICULA_CO2011.CSV", "MATRICULA_NORDESTE2011.CSV", "MATRICULA_NORTE2011.CSV", "MATRICULA_SUDESTE2011.CSV", "MATRICULA_SUL2011.CSV", 
           "matriculas2011completo"))

matriculas2011filtradas <- matriculas2011filtros
dim(matriculas2011filtradas)
total.matriculas2011.DF0 <- subset.ffdf(matriculas2011filtradas, ID_DEPENDENCIA_ADM_ESC != 4 & FK_COD_TIPO_TURMA != 4 & FK_COD_TIPO_TURMA != 5)
dim(total.matriculas2011.DF0)
save.ffdf(total.matriculas2011.DF0, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total_matriculas2011", 
          overwrite = TRUE)

matriculas2011.ativas <- merge.ffdf(total.matriculas2011.DF0, escolas1999_2017.Pub.Ativas.ff, by.x = c("ANO_CENSO", "PK_COD_ENTIDADE"), by.y = c("ANO", "ID_ESCOLA"),
                                    trace = 2)
dim(matriculas2011.ativas)

matriculas2011.ativas.mun <- subset.ffdf(matriculas2011.ativas[!duplicated.ff(matriculas2011.ativas$PK_COD_MATRICULA), ], 
                                         select = c("ANO_CENSO", "PK_COD_MATRICULA", "FK_COD_ALUNO","FK_COD_MOD_ENSINO", "FK_COD_ETAPA_ENSINO", "COD_MUNIC", 
                                                    "PK_COD_ENTIDADE", "DEP"))

save.ffdf(matriculas2011.ativas.mun, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\matriculas-ativas-munic2011", 
          overwrite = TRUE)
rm(total.matriculas2011.DF0)

# Total de matrículas, por município e etapa de ensino
matriculas2011 <- as.data.table(matriculas2011.ativas.mun)
rm(matriculas2011.ativas.mun)
saveRDS(matriculas2011, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\matriculas2011DT")

matriculas2011$PK_COD_ENTIDADE %<>% as.character()
matriculas2011$COD_MUNIC %<>% as.character()

matriculas2011 <- left_join(matriculas2011, escolas2011, by = c("PK_COD_ENTIDADE" = "ID_ESCOLA", "COD_MUNIC" = "COD_MUNIC"))

total.matriculas.2011 <- setDT(matriculas2011)[, .(MATRICULAS = .N), by = .(COD_MUNIC, FK_COD_ETAPA_ENSINO, LOC)]
saveRDS(total.matriculas.2011, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total.matriculas2011DT")
rm(matriculas2011)

#total.matriculas.munic2011 <- table.ff(matriculas2011.ativas.mun$COD_MUNIC)
#total.matriculas.munic2011 <- cbind(read.table(text = names(total.matriculas.munic2011)), total.matriculas.munic2011)
#setDT(total.matriculas.munic2011)[, ANO := "2011"]
#total.matriculas.munic2011 %>% rename(MUNICIPIO = Var1, TOTAL_MATRICULAS = Freq) %>% select(ANO, MUNICIPIO, TOTAL_MATRICULAS) -> total.matriculas.munic2011
#rm(matriculas2011.ativas.mun)
