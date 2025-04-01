%{
#include <stdbool.h>
#include <parser_core.h>

#include <parser.tab.h>

void yyerror(const char*);

extern int yylineno;
%}

%%
"//".*  ; /* Skip comments */

"=="        { return EQ; }
"="         { return ASSIGN; }
";"         { return SEMICOLON; }
","         { return COMMA; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"["         { return LBRACKET; }
"]"         { return RBRACKET; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return ASTERISK; }
"/"         { return SLASH; }

"NULL"      { return TYPE_NULL; }
"void"      { return TYPE_VOID; }
"bool"      { return TYPE_BOOL; }
"int"       { return TYPE_INT; }
"float"     { return TYPE_FLOAT; }
"double"    { return TYPE_DOUBLE; }

"if"        { return IF; }
"else"      { return ELSE; }
"return"    { return RETURN; }

"true"  { 
    yylval.int_val = 1;
    return INTEGER;
}

"false" { 
    yylval.int_val = 0;
    return INTEGER;
}

"const" { 
    yylval.str = strdup(yytext); 
    return SPECIFIER; 
}

"volatile" { 
    yylval.str = strdup(yytext); 
    return SPECIFIER; 
}

"mutable" { 
    yylval.str = strdup(yytext); 
    return SPECIFIER; 
}

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.str = strdup(yytext); 
    return IDENTIFIER; 
}

[0-9]+\.[0-9]+([fF]?) {
    yylval.float_val = atof(yytext);
    return FLOAT;
}

[0-9]+ { 
    yylval.int_val = atoi(yytext);
    return INTEGER;
}

[\n]    ;
[ \t]   ;

%%

int yywrap() { return 1; }