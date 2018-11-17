%{
#include"lex.yy.c"
void yyerror(char *);
int scope=0;

//printf("hi____________________");
%}

%token SEMICOLON_TOK
%token LCRLY_TOK
%token RCRLY_TOK
%token LPAREN_TOK
%token RPAREN_TOK
%token INT_TOK
%token INT_CONS
%token FLOAT_TOK
%token FLOAT_CONS
%token CHAR_TOK
%token CHAR_CONS
%token MAIN_TOK
%token COMMA_TOK
%token ID_TOK
%token ASG_TOK
%token IF_TOK
%token MINUS_TOK
%token PLUS_TOK
%token ELSE_TOK
%token VOID_TOK
%token RETURN_TOK
%token WHILE_TOK
%token EQUAL_TOK
%token GREATER_TOK
%token LESSER_TOK
%token GR_EQ_TOK
%token LE_EQ_TOK
%token NOT_TOK
%token NOT_EQ_TOK
%token MULTIPLY_TOK
%token DIVIDE_TOK
%token POW_TOK
%token FOR_TOK
%start S

%%

S    :  datatype  MAIN_TOK LPAREN_TOK RPAREN_TOK BLOCK     
		{printf("Syntax for Main Function is Ok...");}
     | datatype ID_TOK LPAREN_TOK args RPAREN_TOK BLOCK S
     ;
     
BLOCK: LCRLY_TOK  STATEMENTS  BLOCKS  RCRLY_TOK
     ;

BLOCKS: STATEMENTS BLOCK STATEMENTS BLOCKS                           {}
      |
      ;

STATEMENTS:STATEMENTS  stmt
          |
          ;
          
CONS: INT_CONS
	| CHAR_CONS
	| FLOAT_CONS
	;
	
stmt:	 DECLARATION SEMICOLON_TOK       {}
		 | ASSIGNMENT SEMICOLON_TOK	{printf("Assignment Statement");}
		 | CONDITIONAL	{printf("Conditional Statement");} 
		 | ITERATION SEMICOLON_TOK	{printf("Iteration Statement");}
		 | ITERATIVE	{printf("Iterative Statement");}
		 | FUNC_CALL SEMICOLON_TOK {printf("Function call");} 
		 | RETURN_TOK LPAREN_TOK ARGUMENTS RPAREN_TOK SEMICOLON_TOK
		 | RETURN_TOK SEMICOLON_TOK
		 | RETURN_TOK ID_TOK SEMICOLON_TOK;
		 ;
		
ITERATIVE: WHILE_TOK LPAREN_TOK exp RPAREN_TOK {printf("while");}
	| FOR_TOK LPAREN_TOK ASSIGNMENT SEMICOLON_TOK exp SEMICOLON_TOK ITERATION RPAREN_TOK	{printf("for");} // (int i=0; i<3; i++  )
	| FOR_TOK LPAREN_TOK ASSIGNMENT SEMICOLON_TOK exp SEMICOLON_TOK ASSIGNMENT RPAREN_TOK	{printf("for");} // (int i=0; i<3; i=i+2)
	| FOR_TOK LPAREN_TOK ASSIGNMENT SEMICOLON_TOK exp SEMICOLON_TOK RPAREN_TOK	{printf("for");}  // (int i=0; i<3; ))
	| FOR_TOK LPAREN_TOK ASSIGNMENT SEMICOLON_TOK SEMICOLON_TOK ITERATION RPAREN_TOK	{printf("for");} // (int i=0;    ; i++  )
	| FOR_TOK LPAREN_TOK ASSIGNMENT SEMICOLON_TOK SEMICOLON_TOK ASSIGNMENT RPAREN_TOK	 {printf("for");} // (int i=0;    ; i=i+2)
	| FOR_TOK LPAREN_TOK ASSIGNMENT SEMICOLON_TOK SEMICOLON_TOK RPAREN_TOK {printf("for");} // (int i=0;    ;      )		
	;

exp:	ID_TOK	 
	| NOT_TOK exp
	| CONS
	| CONS rel_op CONS
	| CONS rel_op ID_TOK
	| ID_TOK rel_op ID_TOK
	| ID_TOK rel_op CONS
	;
		
rel_op: EQUAL_TOK 
	| GREATER_TOK
	| LESSER_TOK
	| GR_EQ_TOK
	| LE_EQ_TOK
	| NOT_EQ_TOK
	;
		
args: FUNC_ARG
	|
	;
	
FUNC_ARG:  FUNC_ARG COMMA_TOK ARG_DEC
	|  ARG_DEC
	;
		
ARG_DEC: datatype ID_TOK
	; 	
		
FUNC_CALL: id_token LPAREN_TOK ARGUMENTS RPAREN_TOK  
	;

ARGUMENTS: ID {printf("Arguments parsed"); }
	;

ID : ID COMMA_TOK CONS
	| ID COMMA_TOK FUNC_CALL
	| ID COMMA_TOK ID_TOK
	| CONS
	| FUNC_CALL
	| ID_TOK
	|
	;
 
ITERATION: ID_TOK PLUS_TOK PLUS_TOK 
	| ID_TOK MINUS_TOK MINUS_TOK
	;
	
CONDITIONAL:	
	IF_TOK LPAREN_TOK id_token RPAREN_TOK 	
	| IF_TOK LPAREN_TOK CONS RPAREN_TOK		
  | ELSE_TOK {printf("else");}
  | ELSE_TOK CONDITIONAL {printf("else if..");}
   ;

DECLARATION: datatype id_token 
	{printf("Declaration Statement");}
  ;

ASSIGNMENT:	ID_TOK ASG_TOK CONS {printf("Assignment");} // Because Variable must be defined before it's used. 
	| ID_TOK ASG_TOK ID_TOK
	| ID_TOK ASG_TOK FUNC_CALL
	| ID_TOK ASG_TOK calc	
	;

calc: I bin_op calc
	| I
	;
	
I:	ID_TOK 
	| CONS
	;
	
bin_op: PLUS_TOK
		| MINUS_TOK
		| MULTIPLY_TOK
		| DIVIDE_TOK
		| POW_TOK
		;
		   
datatype:  INT_TOK 
	|	VOID_TOK
  |	FLOAT_TOK
  | CHAR_TOK
  ;

id_token: 
	id_token COMMA_TOK ID_TOK          {}
	| ID_TOK                             {}
  ;

%%
int main()
{
   if (yyparse()==0) printf("Parsed Successfully\n");
   else printf("\nParsing Error at Line No %d\n", yylineno);

   return(0);	

}

void yyerror(char *s)
{
	printf("yyerror: %s\n",s);
}
