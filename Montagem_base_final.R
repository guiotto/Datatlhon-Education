#MONTANDO A BASE DE NÚMERO TOTAL DE MATRÍCULAS POR MUNICÍPIO E POR ANO
total.matriculas.munic.1997_2017 <- merge(municipiosDF1, matriculas1997_2017, all.x = TRUE)
total.matriculas.munic.1997_2017 %<>% select(NOME_UF, MESORREGIAO, MICRORREGIAO, MUNIC, ANO, TOTAL_MATRICULAS)
write.csv2(total.matriculas.munic.1997_2017, "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_manipulados\\total_matriculas_1997-2017.csv",
           row.names = FALSE)





# Primeiro critério e segundo critério - selecionar apenas as escolas ativas e públicas
escolas.ativ.pub.DF0 <- copy(escolasDF0)
dim(escolas.ativ.pub.DF0)
escolas.ativ.pub.DF0 <- escolas.ativ.pub.DF0[escolas.ativ.pub.DF0$COD_FUNC == "Ativo" & escolas.ativ.pub.DF0$DEP != "Particular", ]
dim(escolas.ativ.pub.DF0)
escolas.ativ.pub.DF0$ANO %<>% as.character()
escolas.ativ.pub.DF0$COD_MUNIC %<>% as.character()
escolas.ativ.pub.DF0$MUNIC %<>% as.character()
escolas.ativ.pub.DF0$ID_ESCOLA %<>% as.character()

escolas.ativ.pub.DF0[, .N, by = ANO]
rm("escolasDF0")

# Terceiro critério - turmas de ensino regular

# Quarto critério - 3ª série/4º ano EF, 8ª série/9º ano do EF, 3º ano EM (ou 4º quando essa for a última série com matrícula)
# Já feito na construção da base de matrículas

# Quinto critério - são consideradas apenas as turmas com 10 ou mais alunos incritos
matriculas.selecionadasDF0 <- copy(matriculasDF2)
matriculas.selecionadasDF0 <- matriculas.selecionadasDF0[matriculas.selecionadasDF0$MATRICULA >= 10, ]
matriculas.selecionadasDF0$ANO %<>% as.character()
matriculas.selecionadasDF0$ID_ESCOLA %<>% as.character()
dim(matriculas.selecionadasDF0)

# Sexto critério - taxa de presença maior ou igual a 50%
total.matriculasDF0 <- merge(matriculas.selecionadasDF0, escolas.ativ.pub.DF0, by = c("ANO", "ID_ESCOLA"))
total.matriculasDF0 %<>% select(-c(COD_FUNC, UF, MUNIC))

total.matriculasDF0 %>% group_by(ANO, COD_MUNIC, SERIE) %>% summarise(Total.MAT = sum(MATRICULA)) -> total.matriculas.munDF0

alunos.saebDF0 <- copy(saeb1999_2005DF0)
alunos.saebDF0[is.na(alunos.saebDF0$MAIS3_ITENS), "MAIS3_ITENS"] <- "Nao_remover"
alunos.saebDF1 <- copy(alunos.saebDF0)
dim(alunos.saebDF1)

alunos.saebDF1 <- alunos.saebDF1[alunos.saebDF1$MAIS3_ITENS == "Nao_remover", ]
dim(alunos.saebDF1)

alunos.saebDF1 <- merge(alunos.saebDF1, escolas.ativ.pub.DF0[, c("ANO", "ID_ESCOLA", "COD_MUNIC")], by = c("ANO", "ID_ESCOLA"))
dim(alunos.saebDF1)

alunos.saebDF1 %>% group_by(ANO, COD_MUNIC, DISCIPLINA, SERIE) %>% summarise(Total.ALunos.Saeb = sum(PESO_AC)) -> total.alunos.SaebDF0

### ESTÁ HAVENDO MAIS INSCRIÇÕES NO SAEB DO QUE MATRÍCULAS
taxa.participacao <- copy(total.alunos.SaebDF0)
participacao <- merge(taxa.participacao, total.matriculas.munDF0, all.x = TRUE, by = c("ANO", "COD_MUNIC", "SERIE"))
