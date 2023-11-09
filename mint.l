digit						[0-9]
letter 						[A-Za-z]
sign 						[+-]
alphanumeric				({digit}|{letter})
%x IN_COMMENT
%%
"["					 		return LSB;
"]"							return RSB;
<INITIAL>{
"##"              			{return MULTI_LINE_COMMENT;
							BEGIN(IN_COMMENT);}
}
<IN_COMMENT>{
"##"      					BEGIN(INITIAL);
[^#\n]
"#"
\n        					yylineno++;
}
start 						return START;
end 						return END;
func						return FUNC;
return						return RETURN;
while						return WHILE;
for 						return FOR;
do 							return DO;
if 							return IF;
elif 						return ELIF;
else 						return ELSE;
Int 						return INT;
List 						return LIST;
Matrix 						return MATRIX;
"with size" 				return WITH_SIZE;
"with dimension"			return WITH_DIMENSION;
and							return AND;
or							return OR;
xor							return XOR;
">="						return GREATER_OR_EQUAL;
">"							return GREATER;
"<" 						return SMALLER;
"<="						return SMALLER_OR_EQUAL;
"=="						return EQUALS;
"!="						return NOT_EQUAL;
in[ \t]*>>					return INPUT_STREAM;
out[ \t]*<< 				return OUTPUT_STREAM;
\%							return MOD_OP;
\{ 							return LC;
\} 							return RC;
\( 							return LP;
\) 							return RP;
\; 							return SC;
\+  		   				return PLUS;
\-  						return MINUS;
\*  						return MULT_OP;
\/  						return DIV_OP;
\*\*  						return EXP_OP;
\,							return COMMA;
\= 							return ASSIGN_OP;
\"[^(\")]*\"				return STRING;
{letter}+{alphanumeric}*	return IDENTIFIER;
\n						{extern int lineno; lineno++;}
{digit}+		 			return CONST;
\/\/.*						return COMMENT;
.
%%
int yywrap(void){
	return 1;
}
