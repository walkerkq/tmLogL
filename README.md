# tmLogL
###R Package with Log Likelihood Function for Text Mining

This package contains one function: tmLogL. This function allows you to compare the log likelihood 
of words between groups. To use, you must supply the grouping variable, text variable and group of interest. 
The function compares the expected frequency of words in the group of interest and remaining text to 
the observed frequency. Words with high log likelihood "surprisingly" occur more in the group of interest, 
while words with negative log likelihood occur less often than expected in the group of interest.

###Usage . 
tmLogL(df, group, group.of.interest, text, sparsity = 0.8, threshold = 3) . 

###Arguments . 
**group**	Column name in your dataframe to group the text by  
**group.of.interest**	Group to compare to the rest  
**text**	Column name in your dataframe that contains the text    
**sparsity**	Level of acceptable sparsity in the text, default 0.80   
**threshold**	Chi-square statistic level at which to keep terms, default 3 
**df**	Required data.frame containing the grouping varible and text 

###Examples . 
tmLogL(df=my.data, group="City", group.of.interest="Chicago", text="Tweets")  
tmLogL(df=other.data, group="Speaker", group.of.interest="George", text="Script.Lines", threshold=10)
