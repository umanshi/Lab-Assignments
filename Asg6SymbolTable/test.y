%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>	
#include <ctype.h>

#include"lex.yy.c"

void yyerror(char *);
//int scope=0;
char func_name[] = "global_func";
//printf("Heyyyy");
//func_name = 'global';
//int yylineno;
struct node
{
	int type;
	int lineno;
	char name[32];
	int scope;
	char owner_func[10];
	int destroyed; // when the variable is outside its scope destroyed = true	
}; 

int func_args_indices[100] = {0};  // First element shows the number of elements in the array;
//func_args_indices[0]= 0; // initially zero args
//printf("%d_______________\n", func_args_indices[0]);
int sym_table_index = 0;
struct node symbol_table[150];

//void put_in_temp_table(char *id_name)
//{
//        strcpy(symbol_table[symbol_table_index++],id_name);
//}

void view_table()
{
	printf("Name| Type| scope| lineNo| destroyed| owmner_func| \n");
	for (int i=0; i<sym_table_index; i++)
	{
		printf(" name = %s| type = %d | scope =%d | lineNo = %d | destroyed = %d | owner_func= %s\n", symbol_table[i].name, symbol_table[i].type, symbol_table[i].scope, symbol_table[i].lineno, symbol_table[i].destroyed, symbol_table[i].owner_func);
	}
}

int search_in_table(char *id_name)
{
	int j;
        //printf("searching for %s\n",id_name);
        for(j=0;j<sym_table_index;j++)
	{
        	if(strcmp(symbol_table[j].name,id_name)==0) 
	    	return j;
        }
        return -1;
}

void insert_into_table(struct node n)
{	printf("insert_into_table function\n Variable = %s\n", n.name);
	int i;
	for(i=0;i<sym_table_index;i++)
	{
		if(strcmp(symbol_table[i].name, n.name)==0 && symbol_table[i].scope==n.scope && symbol_table[i].destroyed==0)// && (strcmp(symbol_table[i].owner_func, n.owner_func)==0)) // && //ex->int func(inta,char a)
			//(symbol_table[i].destroyed==0) && symbol_table[i].scope==n.scope)
		{	
			printf("ERROR: Variable %s already declared on line number %d line no-  %d.\n", symbol_table[i].name, symbol_table[i].lineno, yylineno);
            exit(0);
		}
	}
    printf("Search over! Not found in the table.  \n");
	symbol_table[sym_table_index].type = n.type;
	symbol_table[sym_table_index].scope = n.scope;
	symbol_table[sym_table_index].lineno = n.lineno;
	strcpy(symbol_table[sym_table_index].name, n.name);
	symbol_table[sym_table_index].destroyed = n.destroyed;
    sym_table_index++;
	printf("Inserted\n");
	view_table();
}

void destroy_in_table(int s)
{	printf("scope destroyed = %d\n", s);
	int i;
	for(i=0; i<sym_table_index; i++)
	{
		if(symbol_table[i].scope == s)
			symbol_table[i].destroyed = 1;
	}	
	view_table();
}

int can_be_assigned(char name_[], int scop_)
{	printf("name = %s\n", name_);
	for(int i=0; i<sym_table_index; i++)
	{	if (strcmp(symbol_table[i].name, name_)==0) 
		{	printf("Name matched.. scope[i] = %d\n", symbol_table[i].scope);
			if(symbol_table[i].scope == scop_)
			{	printf("Scope Matched\n");	
				if(symbol_table[i].destroyed == 0)
				{
					printf("Found the variable %s in Symbol Table\n", name_);
					return i;
				}
			}
			else if(symbol_table[i].scope < scop_)
			{	printf("Found in symbol table. Scope[i] < current scope.\n");
				return i;
			}
		}
	}   
	printf("ERROR: Variable %s cannot be assigned a value due to one of the following reasons : \n1. It is not in the symbol table\n2. It is in a higher scope\n3. It is in the same scope but its value is destroyed.\n", name_);
	return -1;	
}
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

%union{
    struct s1{
               int i_val;
               char name[10];
               int i_type;
              } tnv;
    struct s2{
    					char name[10];
    					int i_type;
    				 } tn;
   struct s3{
   		int i_type;
		int i_val;
	} tv;
   		
   struct s4
    				{int i_type;
    				} t;
   
};

%type <t> datatype VOID_TOK CHAR_TOK INT_TOK FLOAT_TOK ARG_DEC

%type <tv> CONS 

%type <tnv> exp ASSIGNMENT FLOAT_CONS INT_CONS CHAR_CONS ID_TOK id_token calc DECLARATION I id
%%

//start: global S;

//global: STATEMENTS
//	|
//	;
	
S    : datatype  MAIN_TOK LPAREN_TOK RPAREN_TOK BLOCK    
		{	// put function name in func_args_indices entries
		//printf("fuction dec for fun == ->%s<-\n",yytext);
		strcpy(func_name, "main");
		int count = func_args_indices[0];
		printf("Count of arguments =%d for func_name = %s  \n", count, func_name);
		for(int i=count; i>0; i--)
		{	
			strcpy ( (symbol_table[func_args_indices[i]].owner_func), func_name)  ; 
			printf("Updated func_name : %s\n", func_name);
		}	
		func_args_indices[0] = 0;
		printf("%s function definition parsed. Updated Symbol table :-\n", func_name);
		printf("main parsed............");
		view_table();
	}
		//{func_name = "main\0";}		
     | func_dec S  
     ;
     
func_dec : function_name LPAREN_TOK args RPAREN_TOK BLOCK
	{	// put function name in func_args_indices entries
		//printf("fuction dec for fun == ->%s<-\n",yytext);
		int count = func_args_indices[0];
		printf("Count of arguments =%d for func_name = %s  \n", count, func_name);
		for(int i=count; i>0; i--)
		{	
			strcpy ( (symbol_table[func_args_indices[i]].owner_func), func_name)  ; 
			printf("Updated func_name : %s\n", func_name);
		}	
		func_args_indices[0] = 0;
		printf("%s function definition parsed. Updated Symbol table :-\n", func_name);
		view_table();
	}
      |
      ;

function_name: datatype ID_TOK
	     	{
	     		$2.i_type = $1.i_type;
	     		strcpy($2.name, yytext);
	     		strcpy(func_name, $2.name);
	     	}
	     ;
		
args: FUNC_ARG
	|
	;
	
FUNC_ARG:  FUNC_ARG COMMA_TOK ARG_DEC  // FUNC_ARG has no type because one function can have more than one argument types
	|  ARG_DEC  
	;
		
ARG_DEC: datatype ID_TOK  {	//printf("datatype.....\n");
       			$2.i_type =  $1.i_type;  // (2)       
				$$.i_type = $1.i_type;			
				strcpy($2.name,yytext);			
				struct node n;
				n.type = $2.i_type;
				n.scope = scope+1;  // THis is a function argument. scope is more!
				strcpy(n.name, yytext);
				//printf("\n\n%s--%s\n", n.name, yytext);
				n.destroyed = 0;
				n.lineno = yylineno;
				printf("func_args_indices[0] = %d \n", func_args_indices[0]); 
				func_args_indices[func_args_indices[0]+1] = sym_table_index;
				func_args_indices[0]++;		
				//Add ID_TOK to symbol_table
				insert_into_table(n);
				//view_table();	
			  } 
	; 		     
BLOCK: LCRLY_TOK  STATEMENTS  BLOCKS  RCRLY_TOK  // 
		{
			printf("\nA BLOCK ENDS. A SCOPE ENDS! DESTROYING VARIBLES..\n");
			printf("scope to be destroyed = %d\n", scope+1);
			destroy_in_table(scope+1); // destoy all the variables of current scope
							   // because we met a curly bracket :)
			//scope--;
		}
     ;

BLOCKS: STATEMENTS BLOCK STATEMENTS BLOCKS                           {}
      |
      ;



STATEMENTS:STATEMENTS  stmt
          |
          ;
          
CONS: INT_CONS 	   	{
					$$.i_type = 0; 
					$$.i_val = yytext;
					}
	| CHAR_CONS    	{
					$$.i_type = 2; 
					$$.i_val = yytext;
					}
	| FLOAT_CONS   	{
					$$.i_type = 1; 
					$$.i_val = yytext;
					}
	;
	
stmt:	 DECLARATION SEMICOLON_TOK       
		{	printf("dec+semicolon parsed___________\n\n");
			struct node n;
			strcpy(n.name, $1.name);
			n.type = $1.i_type;
			n.scope = scope;
			if(scope==0)
				strcpy(n.owner_func, func_name);
			else
			{
				//printf("func_args_indices[0] = %d \n", func_args_indices[0]); 
				func_args_indices[func_args_indices[0]+1] = sym_table_index;
				func_args_indices[0]++;		
			}
			n.destroyed = 0;
			n.lineno = yylineno;
			insert_into_table(n);
			//view_table();
		}
			
	   	| ASSIGNMENT SEMICOLON_TOK	   {printf("stmt assignment \n"); }
		 | CONDITIONAL	
		 | RETURN_TOK LPAREN_TOK ARGUMENTS RPAREN_TOK SEMICOLON_TOK
		 | RETURN_TOK SEMICOLON_TOK
		 | RETURN_TOK ID_TOK SEMICOLON_TOK
		/* | ITERATION SEMICOLON_TOK	//{printf("Iteration Statement");}
		 | ITERATIVE	//{printf("Iterative Statement");}
		 | FUNC_CALL SEMICOLON_TOK  {printf("Function call");} 
		 
	*/		;
		
ITERATIVE: WHILE_TOK LPAREN_TOK exp RPAREN_TOK 
	| FOR_TOK LPAREN_TOK ASSIGNMENT SEMICOLON_TOK exp SEMICOLON_TOK ITERATION RPAREN_TOK // (int i=0; i<3; i++  )
	| FOR_TOK LPAREN_TOK ASSIGNMENT SEMICOLON_TOK exp SEMICOLON_TOK ASSIGNMENT RPAREN_TOK // (int i=0; i<3; i=i+2)
	| FOR_TOK LPAREN_TOK ASSIGNMENT SEMICOLON_TOK exp SEMICOLON_TOK RPAREN_TOK  // (int i=0; i<3; ))
	| FOR_TOK LPAREN_TOK ASSIGNMENT SEMICOLON_TOK SEMICOLON_TOK ITERATION RPAREN_TOK// (int i=0;    ; i++  )
	| FOR_TOK LPAREN_TOK ASSIGNMENT SEMICOLON_TOK SEMICOLON_TOK ASSIGNMENT RPAREN_TOK // (int i=0;    ; i=i+2)
	| FOR_TOK LPAREN_TOK ASSIGNMENT SEMICOLON_TOK SEMICOLON_TOK RPAREN_TOK // (int i=0;    ;      )		
	;

exp:	ID_TOK	 
	| NOT_TOK exp
	| CONS
	| CONS rel_op CONS
	| CONS rel_op ID_TOK 
	{}
	| exp rel_op exp
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

		
FUNC_CALL: id_token LPAREN_TOK ARGUMENTS RPAREN_TOK  
	;

ARGUMENTS: ID   {//printf("Arguments parsed");
	 	}
	;

ID : ID COMMA_TOK CONS
	| ID COMMA_TOK FUNC_CALL
	| ID COMMA_TOK ID_TOK
	| CONS //{printf(" n\n\n\ntype found : %d\n",$$.i_type);}
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
  | ELSE_TOK {}
  | ELSE_TOK CONDITIONAL 
   ;

DECLARATION: datatype ID_TOK 
	{	printf("Declaration parsed.\n");
		strcpy($2.name, yytext);
		$2.i_type = $1.i_type;
		$$.i_type = $2.i_type;
		strcpy($$.name, $2.name); 
	}
		

	;

ASSIGNMENT: //id_token ASG_TOK CONS  // Because Variable must be defined before it's used. 
	 id ASG calc
		{	//printf("Assignment statement calc calc Check\n");
			//struct node n; // dummy node to check if the RHS can be assigned something or not.
			//strcpy(n.name, $1.name);
			//n.scope = scope;
				printf("before sending name = %s\n", $1.name);
				int in = can_be_assigned($1.name, scope);
				//printf("\n\n in = %d\n\n", in);
				if(in != -1)
				{	//Type checking
					if($1.i_type == $3.i_type)
					{	
						$1.i_val = $3.i_val;
					}
					else
					{	
						printf("Assignment statement rejected due to Type Mismatch\n Variable = %s \n", $1.name);
						exit(0);
					}
				}	
				else if(in==-1)
				{
					printf("Assignment statement rejected as\nRHS can't be assigned any value due to the above mentioned reason\n");
					//int u = 9;
					
					
					exit(0);
					
				}					
		}
	 //| id ASG_TOK id
	 //| id ASG_TOK FUNC_CALL
	;

ASG: ASG_TOK {printf("In asg***************8, yytext = '%s'\n", yytext);}
;
calc: I bin_op calc {$$.i_type = $1.i_type;}
	| I {printf("In calc, yytext = %s\n", yytext); $$.i_type = $1.i_type;}
	;
id: ID_TOK
		{
		printf("\n\nid parsed----%s----\n", yytext);	
		strcpy($$.name , yytext);
		printf("$$.name = or id.name = %s\n", $$.name);
		}
	;
I:	id { $$.i_type = $1.i_type;}
	| CONS  { $$.i_type = $1.i_type;}
	;
	
bin_op: PLUS_TOK
		| MINUS_TOK
		| MULTIPLY_TOK
		| DIVIDE_TOK
		| POW_TOK
		;
		   
datatype:  INT_TOK {printf("datatype int..\n"); $$.i_type = 0;}  //   (1)
  |	FLOAT_TOK	{$$.i_type = 1;}
  | CHAR_TOK	{$$.i_type = 2;}
  |	VOID_TOK	{$$.i_type = 3;}
  ;

id_token: 
	id_token COMMA_TOK ID_TOK          {
										strcpy($$.name, yytext);
										printf("yytext = %s", yytext); 
										strcpy($1.name, yytext);
										strcpy($$.name, $1.name); 
										}
	| ID_TOK                           { 			
											strcpy($$.name, yytext);
											printf("yytext = %s", yytext); 
											strcpy($1.name, yytext);
											strcpy($$.name, $1.name); 
										}
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
	printf("_____yyerror: %s\n",s);
}
