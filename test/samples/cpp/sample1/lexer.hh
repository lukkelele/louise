#pragma once

#include <string>
#ifndef yyFlexLexerOnce
#include <FlexLexer.h>
#endif

class LLexer : public yyFlexLexer
{
public:
    int yylex(std::string *const yylval);
};