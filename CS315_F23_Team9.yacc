%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(char* s);
%}


%token	LSB					
%token	RSB
%token  REFERENCE
%token	START
%token	END
%token	FUNC
%token	RETURN
%token	WHILE
%token	FOR
%token	DO
%token	IF
%token	ELIF
%token	ELSE
%token	INT
%token	LIST
%token	MATRIX
%token	WITH_SIZE
%token	WITH_DIMENSION
%token	INPUT_STREAM
%token	OUTPUT_STREAM
%token	MOD_OP
%token	LC
%token	RC
%token	LP
%token	RP
%token	SC
%token	PLUS
%token	MINUS
%token	MULT_OP
%token	DIV_OP
%token	EXP_OP
%token	COMMA
%token	ASSIGN_OP
%token	STRING
%token	IDENTIFIER
%token	CONST
%token	GREATER_OR_EQUAL
%token	GREATER
%token	SMALLER
%token	SMALLER_OR_EQUAL
%token	EQUALS
%token	NOT_EQUAL
%left 	XOR OR
%left 	AND
%%

// PROGRAM START
program: 
START stmt_list END

stmt_list :
stmt
	| stmt stmt_list
stmt : 
conditional_stmt 
| non_conditional_stmt
| error SC {yyerrok;} 


// CONDITIONAL (IF ELSE) STATEMENTS
conditional_stmt : 
  IF LP logic_expr RP LC stmt_list RC else_stmt
            | IF LP logic_expr RP LC stmt_list RC elif_stmts else_stmt
            | IF LP logic_expr RP LC stmt_list RC
	| IF LP logic_expr RP LC stmt_list RC elif_stmts

else_stmt : 
ELSE LC stmt_list RC

elif_stmts : 
elif_stmt 
            | elif_stmt elif_stmts

elif_stmt : ELIF LP logic_expr RP LC stmt_list RC

// LOGICAL EXPRESSIONS
logic_expr :  logic_expr XOR basic_logic_expr
		| logic_expr OR basic_logic_expr
		| logic_expr AND basic_logic_expr
		| basic_logic_expr


basic_logic_expr : arithmetic_operation GREATER_OR_EQUAL arithmetic_operation 
			| arithmetic_operation SMALLER_OR_EQUAL arithmetic_operation 
			| relational_operation
			| LP logic_expr RP

relational_operation : arithmetic_operation GREATER arithmetic_operation 
			    | arithmetic_operation SMALLER arithmetic_operation
			    | equality_operation

equality_operation : 
	arithmetic_operation EQUALS arithmetic_operation
	| arithmetic_operation NOT_EQUAL arithmetic_operation


// NON-CONDITIONAL STATEMENTS
non_conditional_stmt: 
arithmetic_operation SC 
| loop_stmt
| assignment_stmt SC 
| declaration_stmt SC 
| initialization_stmt SC 
| func_stmt
| io_stmt SC

//DECLARATION, INITIALIZATION, ASSIGNMENT
declaration_stmt: 
INT IDENTIFIER
| LIST IDENTIFIER WITH_SIZE arithmetic_operation
| MATRIX IDENTIFIER WITH_DIMENSION arithmetic_operation


initialization_stmt: 
int_initiliazation 
| LIST IDENTIFIER ASSIGN_OP list
| MATRIX IDENTIFIER ASSIGN_OP matrix


int_initiliazation:  
INT IDENTIFIER ASSIGN_OP arithmetic_operation


assignment_stmt:
 IDENTIFIER ASSIGN_OP arithmetic_operation
	| list_indexing ASSIGN_OP arithmetic_operation
	| IDENTIFIER ASSIGN_OP list


// LIST CREATION
list :
 LSB list_helper RSB

list_helper : 
one_d_list 
| matrix 
one_d_list : 
arithmetic_operation
| arithmetic_operation COMMA one_d_list
matrix : 
LSB one_d_list RSB
	| LSB one_d_list RSB COMMA matrix


// LIST INDEXING 
list_indexing: 
IDENTIFIER LSB arithmetic_operation RSB
	| IDENTIFIER LSB arithmetic_operation RSB LSB arithmetic_operation RSB


// ARITHMETIC OPERATION 
arithmetic_operation:
 arithmetic_operation PLUS term 
| arithmetic_operation MINUS term
| term
term : 
 term MULT_OP factor
| term DIV_OP factor
| term MOD_OP factor
| factor
factor :
exp EXP_OP factor 
| exp
exp :
 LP arithmetic_operation RP
 | const_or_var


// LOOPS 
loop_stmt:  
while 
| for 
| do_while

while:  
WHILE LP logic_expr RP LC stmt_list RC
for:  
FOR LP int_initiliazation SC logic_expr SC IDENTIFIER ASSIGN_OP arithmetic_operation SC RP LC stmt_list RC
do_while:  DO LC stmt_list RC WHILE LP logic_expr RP SC


// INPUTS / OUTPUTS
io_stmt:
 input_stmt 
| output_stmt


 input_stmt: INPUT_STREAM IDENTIFIER 
output_stmt: OUTPUT_STREAM output_body 


output_body: 
string_or_number
| string_or_number COMMA output_body


string_or_number: 
STRING
| arithmetic_operation


// FUNCTIONS
parameter_decs: parameter_dec
 			|


parameter_dec:    INT const_or_var
		| INT const_or_var COMMA parameter_dec
		 
parameter_calls: parameter_call
 			|

parameter_call:   const_or_var
		| REFERENCE IDENTIFIER
		| const_or_var COMMA parameter_call
		| REFERENCE IDENTIFIER COMMA parameter_call
		

func_stmt:  
FUNC IDENTIFIER LP parameter_decs RP LC stmt_list RETURN arithmetic_operation SC RC
| FUNC IDENTIFIER LP parameter_decs RP LC RETURN arithmetic_operation SC RC

func_call:  
IDENTIFIER LP parameter_calls RP

// NUMBERS and VARIABLES
const_or_var: 
IDENTIFIER
| const_int
| list_indexing
| func_call
	
const_int:  
CONST 
| MINUS CONST
| PLUS CONST


%%

#include "lex.yy.c"
int lineno=1;
void yyerror(char *s){
  fprintf(stderr, "%s on line %d\n", s,lineno);
}

int main(){
  yyparse();
	if(yynerrs==0)
{
	printf("Input program is valid\n");	
}
  return 0;
}
