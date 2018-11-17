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
		return 1;
	return 0;
}
int yylex(){
	//getchar();
	char ch = fgetc(yyin);
	//printf(" First char = %c", ch);
	
	if(ch == EOF)
		return -1;
	
	while (isspace(ch)==1)
		ch = fgetc(yyin);	
	
	yytext = (char*)malloc(2*sizeof(char));
	//printf("Checking for length 2\n");
	char ch1 = fgetc(yyin);
	int yyleng;
	//printf("\nch = %c, ch1 = %c\n", ch, ch1);
	if((ch == '=')&&(ch1=='=')){
		yytext[0]= ch;
		yytext[1]=ch1;
		yyleng = 2;
		//printf("\nYYTEXT = %s\n", yytext);
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
			fseek(yyin, -1, SEEK_CUR);
			//printf("Before switch\n");
    			//printf("Char single = %c\n", ch);
			switch(ch)
			{			
				case ';': case ',' : case '[': case ']': case '{': case '}': case '(': case ')' : case '^' : case '=' :
			 //... and other single character tokens
					yytext[0] = ch;
		    	//	printf("\nChar single Found = %c", ch);				
		    		//printf("\nChar single Found");				
				//printf("\nYYTEXT = %s\n", yytext);
		    		return ch; // ASCII value is used as token value
				//printf("Inside switch\n");
			}
			//fseek(yyin, -1, SEEK_CUR);
			//printf("\n%s", yytext);
		}
	
	yytext = (char*)malloc(10*sizeof(char));
	//else if(first_letter_found ==1)
	
	if(isLetter(ch))
		{
		//printf("First Letter Found\n");
		int t = 0;
		yytext[0] = ch;
		while(isLetter(ch) || isDigit(ch) || ch=='_')
			{
				yytext[t++] = ch;
				ch = fgetc(yyin);
				//printf("\n-----Next Letter = %c", ch); 
			}
		yyleng = t;
		yytext[t++] = '\0';
		fseek(yyin, -1, SEEK_CUR);
		//printf("\nYYTEXT = %s\n", yytext);
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
		}
	
	if(isDigit(ch))
		{
		int t = 0;
		yytext[0] = ch;
		while(isDigit(ch))
			{
				yytext[t++] = ch;
				ch = fgetc(yyin);
			}
		yyleng = t;
		yytext[t++] = '\0';
		//printf("YYTEXT (NUMerical) = %s", yytext);
		return (INTCONST);		
		}
	
	return -1;
	
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
			//printf("__0__\n");
			token = yylex();
			//printf("_0000___\n");
			if(token == -1)
				return 0;
			//printf("____\n");
			printf("YYTEXT -> '%s', TOKEN -> %d\n", yytext, token);
		}
		fclose(yyin);
		return 0;
		}
}
