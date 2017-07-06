#' Log Likelihood Function for Text Mining
#' 
#' This function allows you to compare the log 
#' likelihood of words between groups. To use, you must
#' supply the grouping variable, text variable and group of interest.
#' The function compares the expected frequency of words in the group of interest
#' and remaining text to the observed frequency. Words with high log likelihood
#' "surprisingly" occur more in the group of interest, while words with negative 
#' log likelihood occur less often than expected in the group of interest.
#' @param dataframe Required data.frame containing the grouping varible and text
#' @param group Column name in your dataframe to group the text by
#' @param group.of.interest Group to compare to the rest
#' @param text Column name in your dataframe that contains the text
#' @param sparsity Level of acceptable sparsity in the text, default 0.80
#' @param threshold Chi-square statistic level at which to keep terms, default 3
#' @keywords log likelihood, text mining
#' @export 
#' @examples tmLogL(df=my.data, group="City", group.of.interest="Chicago", text="Tweets")
#' @examples tmLogL(df=other.data, group="Speaker", group.of.interest="George", text="Script.Lines", threshold=10)

tmLogL <- function(df,group,group.of.interest,text,sparsity=0.80,threshold=3){ 
  # Load packages.
  require(tm)
  
  # First, collapse into large set of text.
  collapsed.text <- NULL
  group.names <- levels(as.factor(df[,group]))
  for(i in group.names){
    sub <- df[df[,group] %in% i, ]
    txt <- paste(sub[,text], collapse=" ")
    sub.txt <- data.frame(Group=i, Text=txt)
    collapsed.text <- rbind(collapsed.text, sub.txt)
  }
  
  # Second, create a corpus, then save as data frame.
  myReader <- readTabular(mapping=list(content="Text", id="Group"))
  corpus <- Corpus(DataframeSource(collapsed.text), readerControl=list(reader=myReader))
  corpus <- tm_map(corpus,content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')))
  tdm <- TermDocumentMatrix(corpus, control=list(tolower=TRUE, removePunctuation=TRUE, stopwords=TRUE, removeNumbers=TRUE))
  tdm <- removeSparseTerms(tdm, sparsity)
  tdm.df <- data.frame(as.matrix(tdm[1:dim(tdm)[1],]))
  tdm.df$word <- row.names(tdm.df)
  ln <- length(tdm.df)
  tdm.df <- tdm.df[,c(ln, 1:(ln-1))]
  
  # Third, calculate the LL.
  column.number <- which(colnames(tdm.df) %in% group.of.interest)
  tdm.df.2 <- tdm.df[tdm.df[,column.number] > 0, ]
  returned <- NULL
  for(w in seq_along(tdm.df.2[,1])){
    word <- tdm.df.2[w,1]
    a <- tdm.df.2[w, column.number] # word, corpus one
    b <- sum(tdm.df.2[w, -c(1, column.number)]) # word, corpus two
    c <- sum(tdm.df.2[-w, column.number]) # not word, corpus one
    d <- sum(tdm.df.2[-w, -c(1, column.number)]) # not word, corpus two
    N <- a + b + c + d
    e1 <- (a + c) * ((a + b)/N)
    e2 <- (b + d) * ((a + b)/N)
    chisq <- 2 * ((a * log(a / e1)) + (b * log(b / e2)))
    if(!is.nan(chisq) & chisq > threshold){
      if(a < e1) chisq <- chisq * - 1
      row <- data.frame(o1=a, o2=b, e1, e2, chisq, word=tdm.df.2[w,1], name=group.of.interest)
      returned <- rbind(returned, row)
    }
  }
  return(returned)
}

