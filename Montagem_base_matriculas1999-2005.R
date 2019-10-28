## NÚMERO TOTAL DE ALUNOS (MATRÍCULAS)
#### Ano 1997 ####
escolaDF0.1997 <- read.csv2("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\censo_escolar_1997.csv")

escolaDF1.1997 <- copy(escolaDF0.1997)
escolaDF1.1997 %<>% rename(ID_ESCOLA = MASCARA, COD_MUNIC = CODMUNIC, SIGLA_UF = SIGLA, COD_FUNC = CODFUNC, MAT_CRECHE = VPE511, MAT_PRE.ESCOLA = VPE515, 
                           MAT_CLASSE.ALF = VPE516, MAT_1EF = VEF221, MAT_2EF = VEF222, MAT_3EF = VEF223, MAT_4EF = VEF224,  MAT_5EF = VEF225, MAT_6EF = VEF226, 
                           MAT_7EF = VEF227, MAT_8EF = VEF228, MAT_1EM = VEM221, MAT_2EM = VEM222, MAT_3EM = VEM223, MAT_4EM = VEM224, MAT_N.SERIADA = VEM225)

escolaDF1.1997[is.na(escolaDF1.1997)] <- 0
setDT(escolaDF1.1997)[, MAT_EJA := VES711 + VES712 + VES713 + VES714 + VES715]
escolaDF1.1997[, MAT_ENS.INF := MAT_CRECHE + MAT_PRE.ESCOLA + MAT_CLASSE.ALF]
escolaDF1.1997[, MAT_EF := MAT_1EF + MAT_2EF + MAT_3EF + MAT_4EF + MAT_5EF + MAT_6EF + MAT_7EF + MAT_8EF]
escolaDF1.1997[, MAT_EM := MAT_1EM + MAT_2EM + MAT_3EM + MAT_4EM + MAT_N.SERIADA]

escolaDF2.1997 <- copy(escolaDF1.1997)
escolaDF2.1997 %<>% select(ANO, COD_MUNIC, SIGLA_UF, MUNIC, ID_ESCOLA, DEP, LOC, COD_FUNC, MAT_ENS.INF, MAT_EF, MAT_EM, MAT_EJA)
rm(escolaDF0.1997, escolaDF1.1997)

#### Ano 1999 ####
#Os microdados dos anos 1999-2005 apresentaram mudanças nas variáveis disponíveis. Sendo assim, dada a inexistência das variáveis referentes ao número total de matrículas em cada série analisada (como acontece no Censo Escolar 1997), elas foram criadas a partir do somatório do número de matrículas nos turnos diruno e noturno das respectivas séries.

escolaDF0.1999 <- read.csv2("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\censo_escolar_1999.csv")

escolaDF1.1999 <- copy(escolaDF0.1999)
escolaDF1.1999 %<>% rename(ID_ESCOLA = MASCARA, COD_MUNIC = CODMUNIC, SIGLA_UF = SIGLA, COD_FUNC = CODFUNC, MAT_CRECHE = VPE511, MAT_PRE.ESCOLA = VPE515, 
                           MAT_CLASSE.ALF = VPE516, MAT_1EF.D = DEF11C, MAT_2EF.D = DEF11D, MAT_3EF.D = DEF11E, MAT_4EF.D = DEF11F,  MAT_5EF.D = DEF11G, 
                           MAT_6EF.D = DEF11H, MAT_7EF.D = DEF11I, MAT_8EF.D = DEF11J, MAT_1EF.N = NEF11C, MAT_2EF.N = NEF11D, MAT_3EF.N = NEF11E, MAT_4EF.N = NEF11F,
                           MAT_5EF.N = NEF11G, MAT_6EF.N = NEF11H, MAT_7EF.N = NEF11I, MAT_8EF.N = NEF11J, MAT_1EM.D = DEM118, MAT_2EM.D = DEM119, MAT_3EM.D = DEM11A, 
                           MAT_4EM.D = DEM11B, MAT_N.SERIADA.D = DEM11C, MAT_1EM.N = NEM118, MAT_2EM.N = NEM119, MAT_3EM.N = NEM11A, MAT_4EM.N = NEM11B, 
                           MAT_N.SERIADA.N = NEM11C)

escolaDF1.1999[is.na(escolaDF1.1999)] <- 0
setDT(escolaDF1.1999)[, MAT_EJA := rowSums(escolaDF1.1999[, 39:80])]
escolaDF1.1999[, MAT_ENS.INF := MAT_CRECHE + MAT_PRE.ESCOLA + MAT_CLASSE.ALF]
escolaDF1.1999[, MAT_EF := MAT_1EF.D + MAT_2EF.D + MAT_3EF.D + MAT_4EF.D + MAT_5EF.D + MAT_6EF.D + MAT_7EF.D + MAT_8EF.D + MAT_1EF.N + MAT_2EF.N + MAT_3EF.N + 
                 MAT_4EF.N + MAT_5EF.N + MAT_6EF.N + MAT_7EF.N + MAT_8EF.N]
escolaDF1.1999[, MAT_EM :=  MAT_1EM.D + MAT_2EM.D + MAT_3EM.D + MAT_4EM.D + MAT_N.SERIADA.D +  MAT_1EM.N + MAT_2EM.N + MAT_3EM.N + MAT_4EM.N + MAT_N.SERIADA.N]

escolaDF2.1999 <- copy(escolaDF1.1999)
escolaDF2.1999 %<>% select(ANO, COD_MUNIC, SIGLA_UF, MUNIC, ID_ESCOLA, DEP, LOC, COD_FUNC, MAT_ENS.INF, MAT_EF, MAT_EM, MAT_EJA)
rm(escolaDF0.1999, escolaDF1.1999)

#### Ano 2001 ####
escolaDF0.2001 <- read.csv2("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\censo_escolar_2001.csv")

escolaDF1.2001 <- copy(escolaDF0.2001)
escolaDF1.2001 %<>% rename(ID_ESCOLA = MASCARA, COD_MUNIC = CODMUNIC, SIGLA_UF = SIGLA, COD_FUNC = CODFUNC, MAT_CRECHE.D = DPE119, MAT_PRE.ESCOLA.D = DPE11D,
                           MAT_CRECHE.N = NPE119, MAT_PRE.ESCOLA.N = NPE11D, MAT_CLASSE.ALF.D = DCA114, MAT_CLASSE.ALF.N = NCA114, MAT_1EF.M = VEF411, 
                           MAT_2EF.M = VEF412, MAT_3EF.M = VEF413, MAT_4EF.M = VEF414, MAT_5EF.M = VEF415, MAT_6EF.M = VEF416, MAT_7EF.M = VEF417, MAT_8EF.M = VEF418, 
                           MAT_1EF.F = VEF421, MAT_2EF.F = VEF422, MAT_3EF.F = VEF423, MAT_4EF.F = VEF424, MAT_5EF.F = VEF425, MAT_6EF.F = VEF426, MAT_7EF.F = VEF427, 
                           MAT_1EM.M = VEM411, MAT_2EM.M = VEM412, MAT_3EM.M = VEM413, MAT_4EM.M = VEM414, MAT_N.SERIADA.M = VEM415, MAT_1EM.F = VEM421, 
                           MAT_2EM.F = VEM422, MAT_3EM.F = VEM423, MAT_4EM.F = VEM424, MAT_N.SERIADA.F = VEM425) #DESISTI DE RENOMEAR TODAS AS VARIÁVEIS

escolaDF1.2001[is.na(escolaDF1.2001)] <- 0
setDT(escolaDF1.2001)[, MAT_ENS.INF := MAT_CRECHE.D + MAT_CRECHE.N + MAT_PRE.ESCOLA.D + MAT_PRE.ESCOLA.N + MAT_CLASSE.ALF.D + MAT_CLASSE.ALF.N]
escolaDF1.2001[, MAT_EF := rowSums(escolaDF1.2001[, 10:31])]
escolaDF1.2001[, MAT_EM := rowSums(escolaDF1.2001[, 40:61])]
escolaDF1.2001[, MAT_EJA := rowSums(escolaDF1.2001[, 64:71])]

escolaDF2.2001 <- copy(escolaDF1.2001)
escolaDF2.2001 %<>% select(ANO, COD_MUNIC, SIGLA_UF, MUNIC, ID_ESCOLA, DEP, LOC, COD_FUNC, MAT_ENS.INF, MAT_EF, MAT_EM, MAT_EJA)
rm(escolaDF0.2001, escolaDF1.2001)

#### Ano 2003 ####
escolaDF0.2003 <- read.csv2("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\censo_escolar_2003.csv")

escolaDF1.2003 <- copy(escolaDF0.2003)
escolaDF1.2003[is.na(escolaDF1.2003)] <- 0
escolaDF1.2003 %<>% rename(ID_ESCOLA = MASCARA, COD_MUNIC = CODMUNIC, SIGLA_UF = SIGLA, COD_FUNC = CODFUNC) 

setDT(escolaDF1.2003)[, MAT_ENS.INF := rowSums(escolaDF1.2003[, 10:15])]
escolaDF1.2003[, MAT_EF.SERIE := rowSums(escolaDF1.2003[, 16:31])]
escolaDF1.2003[, MAT_EF.ANO := rowSums(escolaDF1.2003[, 32:40])] #houve mudança de série para ano - lembrar da correspondência na hora de somar por série/ano
escolaDF1.2003[, MAT_EM := rowSums(escolaDF1.2003[, 41:60])]
escolaDF1.2003[, MAT_EJA := rowSums(escolaDF1.2003[, 61:68])]
escolaDF1.2003[, MAT_EF := MAT_EF.SERIE + MAT_EF.ANO]

escolaDF2.2003 <- copy(escolaDF1.2003)
escolaDF2.2003 %<>% select(ANO, COD_MUNIC, SIGLA_UF, MUNIC, ID_ESCOLA, DEP, LOC, COD_FUNC, MAT_ENS.INF, MAT_EF, MAT_EM, MAT_EJA)
rm(escolaDF0.2003, escolaDF1.2003)

#### Ano 2005 ####
escolaDF0.2005 <- read.csv2("C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\censo_escolar_2005.csv")

escolaDF1.2005 <- copy(escolaDF0.2005)
escolaDF1.2005[is.na(escolaDF1.2005)] <- 0
escolaDF1.2005 %<>% rename(ID_ESCOLA = MASCARA, COD_MUNIC = CODMUNIC, SIGLA_UF = SIGLA, COD_FUNC = CODFUNC) 

setDT(escolaDF1.2005)[, MAT_ENS.INF := rowSums(escolaDF1.2005[, 10:13])]
escolaDF1.2005[, MAT_EF.SERIE := rowSums(escolaDF1.2005[, 14:29])]
escolaDF1.2005[, MAT_EF.ANO := rowSums(escolaDF1.2005[, 30:47])] #houve mudança de série para ano - lembrar da correspondência na hora de somar por série/ano
escolaDF1.2005[, MAT_EM := rowSums(escolaDF1.2005[, 48:57])]
escolaDF1.2005[, MAT_EJA := rowSums(escolaDF1.2005[, 58:67])]
escolaDF1.2005[, MAT_EF := MAT_EF.SERIE + MAT_EF.ANO]

escolaDF2.2005 <- copy(escolaDF1.2005)
escolaDF2.2005 %<>% select(ANO, COD_MUNIC, SIGLA_UF, MUNIC, ID_ESCOLA, DEP, LOC, COD_FUNC, MAT_ENS.INF, MAT_EF, MAT_EM, MAT_EJA)
rm(escolaDF0.2005, escolaDF1.2005)

#APPEND DA BASE DE DADOS
sapply(mget(ls(pattern = "escola")), nrow)
sum(sapply(mget(ls(pattern = "escola")), nrow))
matriculasDF0.1997_2005 <- rbind(escolaDF2.1997, escolaDF2.1999, escolaDF2.2001, escolaDF2.2003, escolaDF2.2005, fill = TRUE)


saveRDS(matriculasDF0.1997_2005, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\Censo_escolar\\matriculas1997_2005")
dim(matriculas1997_2005)
rm(escolaDF2.1997, escolaDF2.1999, escolaDF2.2001, escolaDF2.2003, escolaDF2.2005)

