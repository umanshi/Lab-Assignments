#include<stdlib.h>
#include<stdio.h>
#include <string.h>
#define LPAREN_TOK ’(’
#define GT_TOK ’>’
#define RPAREN_TOK ’)’
#define EQ_TOK ’=’
#define MINUS_TOK ’-’
#define SEMICOLON_TOK ’;’
#define L_EQ_TOK 256
#define G_EQ_TOK 257
#define EQUAL_TOK 268
#define NOTEQUAL_TOK 269
#define AND_TOK 312
#define OR_TOK 313
#define WHILE_TOK 314
#define FOR_TOK 315
#define IF_TOK 316
#define ELSE_TOK 317 
#define DO_TOK 318
#define ID_TOK 319
#define INTCONST 320
#define INT_TOK 321
#define FLOAT_TOK 322
#define CHAR_TOK 323


FILE *yyin;
char *yytext;
int state = 0;
int yyleng;
int isspace(char ch)
{
	if (ch == ' '|| ch == '\n' || ch == '\t')
		return 1;
	return 0;
}

int isDigit(char ch)
{
	if((ch >= '0')&&(ch <='9'))
		return 1;
	return 0;
}
int isLetter(char ch)
{
	
	if(((ch >= 'a')&&(ch <='z'))||((ch >= 'A')&&(ch <= 'Z')))
		{
		//printf("isLetter returns 1");
		return 1;
		}
	return 0;
}
int t;
void change_state(char ch)
{
	

	if(isLetter(ch)==1)
		state = 1;
	else if(isDigit(ch)==1)
		state = 2;
	else if(isspace(ch)==1)
		state = 0;
	else //symbol
		state = 3;
	return;
}
char ch;
int yylex_util()
{
	switch(state)
	{
		case 0:
			while(isspace(ch))
				ch = fgetc(yyin);
			change_state(ch);
			if (ch==EOF) return -1;
			return yylex();
			break;
			
		case 1: // ch is a letter
			yytext = (char*)malloc(10*sizeof(char));
			t = 0;
			yytext[0] = ch;
			while(isLetter(ch) || isDigit(ch) || ch=='_')
			{
				yytext[t++] = ch;
				ch = fgetc(yyin); 
			}
			
			yyleng = t+1;
			yytext[t++] = '\0';
			change_state(ch);
			if(strcmp(yytext,"for")==0)
				return FOR_TOK;
			if(strcmp(yytext, "while")==0)
				return WHILE_TOK;
			if(strcmp(yytext, "if")==0)
				return IF_TOK;
			if(strcmp(yytext, "do")==0)
				return DO_TOK;
			if(strcmp(yytext, "else")==0)
				return ELSE_TOK;
			else 
				return (ID_TOK);		
		case 2:
			t = 0;
			yytext[0] = ch;
			while(isDigit(ch))
				{
					yytext[t++] = ch;
					ch = fgetc(yyin);
				}
			change_state(ch);
			yyleng = t;
			yytext[t++] = '\0';
			return (INTCONST);	
		case 3:
			if(ch == EOF)
				return -1;
			yytext = (char*)malloc(2*sizeof(char));
			char ch1 = fgetc(yyin);
		int yyleng;
		if((ch == '=')&&(ch1=='='))
		{	//char ch3 = fgetc(yyin);
			
			yytext[0]= ch;
			yytext[1]=ch1;
			yyleng = 2;
			return EQUAL_TOK;
		}
	else if((ch == '&')&&(ch1=='&')){
		yytext[0]=ch;
		yytext[1]=ch1;
		yyleng =2;
		return AND_TOK;
	} else if((ch == '|')&&(ch == '|')){
		yytext[0]=ch;
		yytext[1]= ch1;
		yyleng = 2;
		return OR_TOK;
	} else if((ch == '!')&&(ch1=='=')){
		yytext[0]= ch;
		yytext[1]= ch1;
		yyleng = 2;
		return NOTEQUAL_TOK;
	} else if((ch == '>')&&(ch1 == '=')){
		yytext[0]= ch;
		yytext[1] = ch1;
		yyleng = 2;
		return G_EQ_TOK;
	}else if((ch =='<')&&(ch1=='=')){
		yytext[0]= ch;
		yytext[1]= ch1;
		yyleng = 2;
		return L_EQ_TOK;
	}
	else{
			
			switch(ch)
			{	
				case ';': case ',' : case '[': case ']': case '{': case '}': case '(': case ')' : case '^' : case '=' :
			 //... and other single character tokens
					yytext[0] = ch;
					yytext[1] = '\0';
				
		    		char ch2 = ch;
		    		ch = ch1;
		    		change_state(ch1);
		    
		    		return ch2; // ASCII value is used as token value	
			}	
		}
	}
}

int yylex(){

	if(state==0) 
		ch = fgetc(yyin);

	if(ch == EOF)
		return -1;
	printf("State = %d\n", state);
	
	return yylex_util();
	
}

int main(int argc, char *argv[])

{
	int token;
	if (argc != 2)
		{
		printf("Enter file name!");
		}
	else{
		yyin = fopen(argv[1], "r");
		while(!feof(yyin))
		{	
			token = yylex();
			if(token == -1)
				return 0;
			
			printf("YYTEXT -> '%s', TOKEN -> %d\n", yytext, token);
		}
		fclose(yyin);
		return 0;
		}
}
