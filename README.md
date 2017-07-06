# tmLogL
### R Package with Log Likelihood Function for Text Mining

This package contains one function: tmLogL. This function allows you to compare the log likelihood of words between groups. To use, you must supply the grouping variable, text variable and group of interest. The function compares the expected frequency of words in the group of interest and remaining text to the observed frequency. Words with high log likelihood "surprisingly" occur more in the group of interest, while words with negative log likelihood occur less often than expected in the group of interest. This function was employed in the past by my [Text Mining South Park](https://github.com/walkerkq/textmining_southpark) and [50 Years of Music Lyrics](https://github.com/walkerkq/musiclyrics) projects but not formalized until now. 

### Usage

tmLogL(df, group, group.of.interest, text, sparsity = 0.8, threshold = 3) . 

### Arguments

**group**	            Column name in your dataframe to group the text by  
**group.of.interest**	Group to compare to the rest  
**text**	            Column name in your dataframe that contains the text    
**sparsity**	        Level of acceptable sparsity in the text, default 0.80   
**threshold**	        Chi-square statistic level at which to keep terms, default 3  
**df**	              Required data.frame containing the grouping varible and text 

### Examples

tmLogL(df=my.data, group="City", group.of.interest="Chicago", text="Tweets")  
tmLogL(df=other.data, group="Speaker", group.of.interest="George", text="Script.Lines", threshold=10)

### Log Likelihood  

Log likelihood was used to measure the unique-ness of the ngrams by character. Log likelihood compares the occurrence of a word in a particular corpus (such as the body of a character’s speech) to its occurrence in another corpus (all of the remaining text) to determine if it shows up more or less likely that expected. The returned value represents the likelihood that the corpora are from the same, larger corpus, like a t-test. The higher the score, the more unlikely.

The chi-square test, or goodness-of-fit test, can be used to compare the occurrence of a word across corpora.

χ2=∑(Oi−Ei)2Ei

where O = observed frequency and E = expected frequency. 
However, flaws have been identified: invalidity at low frequencies (Dunning, 1993) and over-emphasis of common words (Kilgariff, 1996). Dunning was able to show that the log-likelihood statistic was accurate even at low frequencies:

2∑Oi∗ln(OiEi) 


