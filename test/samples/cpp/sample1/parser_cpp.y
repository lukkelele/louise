%require "3.2"
%language "c++"

%{
#include <cstdlib>
#include <cstdio>
#include <string>
#include <vector>

using namespace std;
//yy::parser::symbol_type yylex();
%}

/* Declare that <string> is required in the generated header. */
%code requires {
    #include <string>
    #include <lexer.hh>
}

//%define api.value.type {int}
%define api.value.type {std::string}

%parse-param {LLexer &lexer}

%header

%code {
  #define yylex lexer.yylex
}

%token NUM

%token HELLO
%token WORLD

%%

hello_world: HELLO WORLD '!' { std::cout << "Goodbye " << $WORLD << '!' << std::endl; }

%%

#include "parser.tab.hh"

int main(int argc, char* argv[])
{
    //yy::parser parser;
    LLexer lexer;
    yy::parser parser(lexer);
    parser.parse();

    return 0;
}

void yy::parser::error(const std::string &message)
{
    std::cerr << "Error: " << message << std::endl;
}
