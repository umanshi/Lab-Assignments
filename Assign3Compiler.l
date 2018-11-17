%{
	#include<stdio.h>
	#include<stdlib.h>
	#include <string.h>
	#include <ctype.h>
	#include <stdlib.h>
	#include "headers.h"
%}
digit[0-9]
letter[a-zA-Z]
%%

"\n"|"\t"|" "|"#"|"."|"+"|"-"|"*"|"/"|"%"|"!"|"<"|">"|"&"|"|"|"^"|"~"|"="|";"|","|"("|")"|"{"|"}"|"["|"]" return yytext[0];

"while" return WHILE_TOK;
"int" return INT_TOK;
"float" return FLOAT_TOK;
"char" return CHAR_TOK;
"for" return FOR_TOK;
"if" return IF_TOK;
"else" return ELSE_TOK;
"return" return RETURN_TOK;

"++" return INCRE_TOK;
"--" return DECRE_TOK;
"<=" return LT_EQ_TOK;
">=" return GT_EQ_TOK;
"==" return EQ_TO_TOK;
"!=" return NOT_EQ_TOK;
"<<" return LEFT_SHIFT_TOK;
">>" return RIG_SHIFT_TOK;
"&&" return LOG_AND_TOK;
"||" return LOG_OR_TOK;

{letter}+({letter}|{digit})* return ID_TOK;
{digit}+ return INTCONST;
<<EOF>> return -1;


%%
void main()
{	
	int val;
	val = yylex();
	while(val>0)
	{	
		printf("yytext --> %s	Token --> %d\n", yytext, val);
		val = yylex();
	}	
}
