%{
#include "common-headers.hh"
extern "C" void yyerror(char *s);
#include "parse.tab.h"

void store_token_name(std::string token_name, char *lexeme, int lineno);

%}
%option noyywrap
digit  [0-9]
ws	[ \t\n]*
operator [-+*/=]
letter [a-zA-Z_]
punct [();,\[\]]
matmul \*\*
conv @
%%
{digit}+ 	{ 	
			store_token_name("NUM\t", yytext, yylineno);
			yylval.name= new string(yytext); return NUM; 
		}

{operator}	{	
			store_token_name("OPERATOR", yytext, yylineno);
			return yytext[0]; 
		}

{matmul}	{
			store_token_name("MATMUL", yytext, yylineno);
			return TK_MATMUL;
		}
{conv}		{
		store_token_name("CONV", yytext, yylineno);
			return TK_CONV;
		}

{punct}		{	
			store_token_name("PUNCTUATION", yytext, yylineno);
			return yytext[0]; 
		}

int32		{
			store_token_name ("TK_INT32", yytext, yylineno);
			return TK_INT32;
		}

int8		{
			store_token_name ("TK_INT8", yytext, yylineno);
			return TK_INT8;
		}

output		{
			store_token_name ("TK_OUTPUT", yytext, yylineno);
			return TK_OUTPUT;
		}

{letter}({letter}|{digit})* { 
				
			store_token_name("ID\t", yytext, yylineno);
			yylval.name= new string(yytext); return ID; 
		}		
{ws}		;
.		{
			cerr << "Illegal Character \"" << yytext[0] << "\". Ignoring the rest of the input. " << endl;
			exit(1);
		}
