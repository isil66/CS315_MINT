%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
int yyerror(char* s);
extern int yylineno;
%}


%token	LSB					
%token	RSB
%token	MULTI_LINE_COMMENT						
%token	COMMENT
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
START stmt_list END {printf("Input program is valid.\n"); return 0;}

stmt_list :
stmt
	| stmt stmt_list
stmt : 
conditional_stmt 
| non_conditional_stmt 
| comment

// CONDITIONAL (IF ELSE) STATEMENTS

conditional_stmt : 
  IF LP logic_expr RP LC stmt_list RC else_stmt
            | IF LP logic_expr RP LC stmt_list RC elif_stmts else_stmt
            | IF LP logic_expr RP LC stmt_list RC
	| IF LP logic_expr RP LC stmt_list RC elif_stmts

else_stmt : 
ELSE LP stmt_list RC

elif_stmts : 
elif_stmt 
            | elif_stmt elif_stmts

elif_stmt : ELIF LP logic_expr RP LC stmt_list RC
// LOGICAL EXPRESSIONS
logic_expr : basic_logic_expr XOR logic_expr
		| basic_logic_expr OR logic_expr
		| basic_logic_expr AND logic_expr
		| basic_logic_expr


basic_logic_expr : const_or_var GREATER_OR_EQUAL const_or_var 
			| const_or_var SMALLER_OR_EQUAL const_or_var 
			| relational_operation
			| LP logic_expr RP

relational_operation : const_or_var GREATER const_or_var 
			    | const_or_var SMALLER const_or_var
			    | equality_operation

equality_operation : 
const_or_var EQUALS const_or_var
			  | const_or_var NOT_EQUAL const_or_var


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
| LIST IDENTIFIER WITH_SIZE CONST
| MATRIX IDENTIFIER WITH_DIMENSION CONST


initialization_stmt: 
int_initiliazation 
| LIST IDENTIFIER ASSIGN_OP list
| MATRIX IDENTIFIER ASSIGN_OP matrix


int_initiliazation:  
INT IDENTIFIER ASSIGN_OP const_or_var


assignment_stmt:
 IDENTIFIER ASSIGN_OP const_or_var
	| list_indexing ASSIGN_OP const_or_var


// LIST CREATION
list :
 LSB list_helper RSB

list_helper : 
one_d_list 
| matrix 
one_d_list : 
const_or_var
| const_or_var COMMA one_d_list
matrix : 
LSB one_d_list RSB
	| LSB one_d_list RSB COMMA matrix


// LIST INDEXING 
list_indexing: 
IDENTIFIER LSB const_or_var RSB
	| IDENTIFIER LSB const_or_var RSB LSB const_or_var RSB
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
FOR LP int_initiliazation SC logic_expr SC arithmetic_operation RP LC stmt_list RC
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
| exp


// FUNCTIONS
parameter:    const_or_var
		| const_or_var COMMA parameter 
|
func_stmt:  
FUNC IDENTIFIER LP parameter RP LC stmt_list RETURN const_or_var RC
func_call:  
IDENTIFIER LP parameter RP

// NUMBERS and VARIABLES
const_or_var: 
IDENTIFIER
| const_int
| list_indexing
| func_call
	
const_int:  
CONST 
| MINUS CONST


// COMMENTS
comment :
 	MULTI_LINE_COMMENT
	| COMMENT


%%

#include "lex.yy.c"
int lineno=1;
int yyerror(char *s){
  fprintf(stderr, "%s on line %d\n", s,lineno);
  return 1;
}

int main(){
  yyparse();
  return 0;
}