### Matrículas 2007-13
diretorio <- "C:\\Users\\Guilherme\\Documents\\Data Science\\Datathon de dados - MEC\\Dados_originais\\Censo_escolar\\TEMP"
setwd(diretorio)
anos.2007_13 <- c(csv)
arquivos2007_13 <- list()
for (i in 1:length(anos.2007_13)) {
  arquivos2007_13[[i]] <- list.files(pattern = paste(anos.2007_13[i]))
}

for(i in 1:length(arquivos2007_13)){
  for(j in 1:length(arquivos2007_13[[i]])){
  assign(arquivos2007_13[[i]][j], read.csv2.ffdf(file = arquivos2007_13[[i]][j], sep = "|", header = TRUE, VERBOSE = TRUE, colClasses = NA, first.rows=100000, 
                                                 next.rows = 50000))
  }
}


#### arquivos_2015 ####
arquivos2015 <- list.files(pattern = "2015.CSV")
for(i in 1:length(arquivos2015)){
  assign(arquivos2015[i], read.csv2.ffdf(file = arquivos2015[i], sep = "|", header = TRUE, colClasses = NA, first.rows=100000, next.rows = 50000))
}



#### arquivos_2017 ####
arquivos2017 <- list.files(pattern= "2017")
for(i in 1:length(arquivos2017)){
  assign(arquivos2017[i], read.csv2.ffdf(file = arquivos2017[i], sep = "|", header = TRUE, colClasses = NA, first.rows=100000, next.rows = 50000))
}
