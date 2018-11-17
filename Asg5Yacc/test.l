%{
#include<stdio.h>
#include "y.tab.h"
%}

%%

;		{return(SEMICOLON_TOK);}
,       {return COMMA_TOK; }
\{      {return(LCRLY_TOK);}
\}      {return(RCRLY_TOK);}
\(		{ return(LPAREN_TOK);}
\)		{ return(RPAREN_TOK);}
int     {return(INT_TOK);}
char	{return (CHAR_TOK);}
float   {return (FLOAT_TOK);}
main    {printf("main\n"); return(MAIN_TOK);}
while	{return (WHILE_TOK);}
if		{return IF_TOK; }
else 	{return ELSE_TOK;}
void 	{return VOID_TOK;}
return 	{return RETURN_TOK;}
for 	{ return FOR_TOK;}
([a-z]|[A-Z])([a-z]|[A-Z]|[0-9])* {return (ID_TOK);}
= 		return ASG_TOK;
[0-9]*"."[0-9]*		return FLOAT_CONS;
[\'][a-zA-Z][\']	return CHAR_CONS;
[0-9]*	return INT_CONS;
\*      {return MULTIPLY_TOK;}
\/      {return DIVIDE_TOK;}
\^		{return POW_TOK;}
\-		{return MINUS_TOK;}
\+		{return PLUS_TOK;}
\!		{return NOT_TOK;}
"!="	{return NOT_EQ_TOK;}
"=="	{return EQUAL_TOK;} 
\<		{return LESSER_TOK;}
\>		{return GREATER_TOK;}
">="	{return GR_EQ_TOK;}
"<="  	{return LE_EQ_TOK;}


%%

/*
int main()
{
    int val;
    while((val = yylex()) > 0)
    {
        printf("Token ===%s; Token ID ====%d\n", yytext, val);
        
    }
    
    return(0);
}
 */
