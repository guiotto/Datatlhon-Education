library(data.table)
library(ffbase)
library(magrittr)
library(tidyverse)
library(doBy)
library(doParallel)

#2007
#Salvando as importações como um único arquivo: regiões em conjunto
matriculas2007completo <- ffdfappend(x = NULL, dat = MATRICULA_CO2007.CSV)
matriculas2007completo %<>% ffdfappend(MATRICULA_NORDESTE2007.CSV) 
matriculas2007completo %<>% ffdfappend(MATRICULA_NORTE2007.CSV) 
matriculas2007completo %<>% ffdfappend(MATRICULA_SUDESTE2007.CSV)
matriculas2007completo %<>% ffdfappend(MATRICULA_SUL2007.CSV)
save.ffdf(dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP\\CENSO2007_MATRICULAS_COMPLETO", 
          matriculas2007completo)

matriculas2007filtros <-  subset.ffdf(matriculas2007completo, select = c("ANO_CENSO", "PK_COD_MATRICULA", "FK_COD_ALUNO", "FK_COD_MOD_ENSINO", "FK_COD_ETAPA_ENSINO", 
                                                                         "PK_COD_TURMA", "COD_UNIFICADA", "PK_COD_ENTIDADE", "COD_MUNICIPIO_ESCOLA", 
                                                                         "ID_DEPENDENCIA_ADM_ESC", "FK_COD_TIPO_TURMA"))
save.ffdf(matriculas2007filtros, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP\\CENSO2007_MATRICULAS_FILTROS2007")

rm(list=c("MATRICULA_CO2007.CSV", "MATRICULA_NORDESTE2007.CSV", "MATRICULA_NORTE2007.CSV", "MATRICULA_SUDESTE2007.CSV", "MATRICULA_SUL2007.CSV", 
           "matriculas2007completo"))


# Selecionando apenas as matrículas que se encaixam no critério do Fundeb
# o Fundeb cobre todas as séries da educação básica, nas modalidades de Ensino Regular, Educação Especial, EJA e Ensino Profissional Integrado APENAS nas escolas 
# públicas e privadas que mantém convênio com o poder público

#### ####
matriculas2007filtradas <- matriculas2007filtros
dim(matriculas2007filtradas)
total.matriculas2007.DF0 <- subset.ffdf(matriculas2007filtradas, ID_DEPENDENCIA_ADM_ESC != 4 & FK_COD_TIPO_TURMA != 4 & FK_COD_TIPO_TURMA != 5)
dim(total.matriculas2007.DF0)
save.ffdf(total.matriculas2007.DF0, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total_matriculas2007", 
          overwrite = TRUE)

matriculas2007.ativas <- merge.ffdf(total.matriculas2007.DF0, escolas1999_2017.Pub.Ativas.ff, by.x = c("ANO_CENSO", "PK_COD_ENTIDADE"), by.y = c("ANO", "ID_ESCOLA"),
                                    trace = 2)
dim(matriculas2007.ativas)

matriculas2007.ativas.mun <- subset.ffdf(matriculas2007.ativas[!duplicated.ff(matriculas2007.ativas$PK_COD_MATRICULA), ], 
                                    select = c("ANO_CENSO", "PK_COD_MATRICULA","FK_COD_MOD_ENSINO", "FK_COD_ETAPA_ENSINO", "COD_MUNIC", 
                                               "PK_COD_ENTIDADE", "DEP", "LOC"))
save.ffdf(matriculas2007.ativas.mun, 
          dir = "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\matriculas-ativas-munic2007", 
          overwrite = TRUE)
rm(total.matriculas2007.DF0)

# Total de matrículas, por município e etapa de ensino
matriculas2007 <- as.data.table(subset.ffdf(matriculas2007.ativas.mun, select = c("ANO_CENSO", "PK_COD_MATRICULA", "FK_COD_MOD_ENSINO", "FK_COD_ETAPA_ENSINO", 
                                                                                  "COD_MUNIC", "PK_COD_ENTIDADE")))
matriculas2007$PK_COD_ENTIDADE %<>% as.character()
matriculas2007$COD_MUNIC %<>% as.character()

rm(matriculas2007.ativas.mun)
saveRDS(matriculas2007, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\matriculas2007DT")

matriculas2007 <- left_join(matriculas2007, escolas2007, by = c("PK_COD_ENTIDADE" = "ID_ESCOLA", "COD_MUNIC" = "COD_MUNIC"))

total.matriculas.2007 <- setDT(matriculas2007)[, .(MATRICULAS = .N), by = .(COD_MUNIC, FK_COD_ETAPA_ENSINO, LOC)]

saveRDS(total.matriculas.2007, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\TEMP\\total.matriculas2007DT")
rm(matriculas2007)

#total.matriculas.munic2007 <- table.ff(matriculas2007.ativas.mun$COD_MUNIC)
#total.matriculas.munic2007 <- cbind(read.table(text = names(total.matriculas.munic2007)), total.matriculas.munic2007)
#setDT(total.matriculas.munic2007)[, ANO := "2007"]
#total.matriculas.munic2007 %>% rename(MUNICIPIO = Var1, TOTAL_MATRICULAS = Freq) %>% select(ANO, MUNICIPIO, TOTAL_MATRICULAS) -> total.matriculas.munic2007
#rm(matriculas2007.ativas.mun)


#cluster <- makePSOCKcluster(4)
#registerDoParallel(cluster)
#stopCluster(cluster)

