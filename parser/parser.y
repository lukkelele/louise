//%debug
%{
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//#define LDEBUG
#include <parser_core.h>

#include <symtable.h>
#include <codegen.h>

int yyparse();
extern int yylex();
void yyerror(const char*);

char strbuf[140];
int success = 0;
int errors = 0;
char* L_yytext;

/**
 * @brief Checks if the identifier already exists.
 * Enters the identifier into the symbol table if it doesn't.
 */
int into_symtable(char *sym_name) 
{
    printf("[into_symtable] %s\n", sym_name);
    symtable* id = (symtable*)get_symbol(sym_name);
    if (id != NULL) 
    {
        printf("%s -- Symbol already exists\n", id->name);
        return 0;
    }

    put_symbol(sym_name);
}

int to_codegen(const parser_op_t op, char* sym_name)
{
    printf("[to_codegen] %s\n", sym_name);
    symtable* symbol_ptr = (symtable*)get_symbol(sym_name);
    if (symbol_ptr == NULL)
    {
        errors++;
        strcat(strbuf, "[to_codegen] ");
        strcpy(strbuf, sym_name);
        strcat(strbuf, "is undeclared");
        yyerror(strbuf);
        return 1;
    }

    return (codegen(op, symbol_ptr->offset));
}

int L_DEBUG_FLAGS = L_PARSER_DEBUG_ALL;

%}

%union {
    char* str;
    int int_val;
    float float_val;
}

/* Token declarations. */
%token <str> IDENTIFIER
%token <str> VARIABLE
%token <str> SPECIFIER
%token <int_val> INTEGER
%token <float> FLOAT 
%token EQ ASSIGN SEMICOLON COMMA
%token LPAREN RPAREN 
%token LBRACE RBRACE
%token LBRACKET RBRACKET
%token PLUS MINUS ASTERISK SLASH

%token TYPE_NULL TYPE_BOOL TYPE_VOID TYPE_INT TYPE_FLOAT TYPE_DOUBLE

/* Conditionals. */
%token IF ELSE RETURN

/* Operator precedence (lowest to highest). */
%left PLUS MINUS
%left ASTERISK SLASH
%left LPAREN RPAREN 

%%
program: 
       | program function
       | program declaration
       | program statements

declaration:
        | type_spec IDENTIFIER SEMICOLON
        | type_spec IDENTIFIER ASSIGN expression SEMICOLON
;

function:
    type_spec IDENTIFIER LPAREN arg_list RPAREN SEMICOLON 
    | type_spec IDENTIFIER LPAREN arg_list RPAREN LBRACE statements RBRACE 
;

arg_list: 
    /* Empty - no arguments. */
    | arg_decl
    | arg_list COMMA arg_decl
;

arg_decl:
    type_spec IDENTIFIER
    | type_spec ASTERISK IDENTIFIER
    | type_spec IDENTIFIER LBRACKET RBRACKET
;

type_spec:
    base_type
    | SPECIFIER base_type
    | base_type pointer_spec
    | SPECIFIER base_type pointer_spec
;

base_type:
    | IDENTIFIER
    | TYPE_VOID
    | TYPE_BOOL
    | TYPE_INT
    | TYPE_DOUBLE
    | TYPE_FLOAT
;

pointer_spec:
    ASTERISK
    | pointer_spec ASTERISK
;

statements:
    | statements statement
;

statement:
    RETURN expression SEMICOLON
;

expression:
    TYPE_NULL
    | INTEGER
    | FLOAT
    | expression PLUS expression 
    | expression MINUS expression
    | expression ASTERISK expression
    | expression SLASH expression    
    | LPAREN expression RPAREN      
;

%%

void yyerror(const char* s)
{
    errors++;
    fprintf(stderr, "Error: %s (total %d)\n", s, errors);
}

void print_args(const int argc, char* argv[])
{
    printf("argc=%d ", argc);
    for (int i = 0; i < argc; i++) 
    {
        printf("(%i=%s) ", i, argv[i]);
    }
}

int main(int argc, char* argv[])
{
    fprintf(stdout, "\n|=============================|\n");
    fprintf(stdout, "|        Running parser       |\n");
    fprintf(stdout, "|=============================|\n\n");
    print_args(argc, argv);

    if (argc == 1)  
    {
        printf("Returning\n");
        return 0;
    }

#ifdef LDEBUG
    extern int yydebug;
    yydebug = 1;
#endif

    extern FILE* yyin;
    for (int i = 1; i < argc; i++) 
    {
        fprintf(stdout, "\n");
        FILE* fp = fopen(argv[i], "r");
        if (!fp)
        {
            fprintf(stderr, "Failed to open file: %s\n", argv[i]);
            return 1;
        }

        fprintf(stdout, "File opened: %s\n", argv[i]);

        yyin = fp;

        char line_str[400];
        //fprintf(stdout, "File size: %d (sizeof: %d)\n", sizeof(line_str) / sizeof(char), sizeof(line_str));
        fprintf(stdout, "|==========================|\n");
        fprintf(stdout, "| File: %s\n", argv[i]);
        fprintf(stdout, "|==========================|\n");
        while (fgets(line_str, sizeof(line_str) / sizeof(char), yyin))
        {
            fprintf(stdout, "| %s", line_str);
        }
        fprintf(stdout, "|==========================|\n\n");
        rewind(fp);

        yyparse();
        fclose(fp);
        fprintf(stdout, "\n");
    }

    fprintf(stdout, "|==========================|\n");
    fprintf(stdout, "| Parsing complete\n");
    fprintf(stdout, "|\n");
    fprintf(stdout, "| Errors: %d\n", errors);
    fprintf(stdout, "|==========================|\n");

    return 0;
}
