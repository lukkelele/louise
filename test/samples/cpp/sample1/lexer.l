%{
    #include <iostream>

    #include "lexer.hh"
    #include "parser.tab.hh"

    #undef  YY_DECL
    //#define YY_DECL int parser::yylex(const std::string* yylval)
    #define YY_DECL int LLexer::yylex(const std::string* yylval)

    /**
    * Bring in the parser header to get token constants
    * and also so we can return the correct token types. 
    */
    //#include "parser_cpp.tab.hh"

    using namespace std;
    //.            { return *yytext; }  /* For +, -, *, /, and \n, etc. */
%}

%option c++ noyywrap
%option yyclass="LLexer"

%%
[[:space:]] ;
[[:alpha:]]+ { *yylval = std::string(yytext, yytext + yyleng); return yy::parser::token::WORLD; }
. { return yytext[0]; }

%%
