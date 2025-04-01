#pragma once

#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define L_BIT(x) (1 << x)

typedef enum parser_debug_flag_t
{
	L_PARSER_DEBUG_OFF = L_BIT(0),
	L_PARSER_DEBUG_FUNC = L_BIT(1), /* Function */
	L_PARSER_DEBUG_DECL = L_BIT(2), /* Declaration */
	L_PARSER_DEBUG_EXPR = L_BIT(3), /* Expression */
	L_PARSER_DEBUG_STMT = L_BIT(4), /* Statement */
	L_PARSER_DEBUG_PTR = L_BIT(5),	/* Pointer */
	L_PARSER_DEBUG_PROG = L_BIT(6), /* Program */
	L_PARSER_DEBUG_TKN = L_BIT(7),	/* Token */

	L_PARSER_DEBUG_ALL = L_PARSER_DEBUG_FUNC
		| L_PARSER_DEBUG_DECL
		| L_PARSER_DEBUG_EXPR
		| L_PARSER_DEBUG_STMT
		| L_PARSER_DEBUG_PTR
		| L_PARSER_DEBUG_PROG
		| L_PARSER_DEBUG_TKN
} parser_debug_flag_t;

extern int L_DEBUG_FLAGS;

static bool parser_is_debug_enabled(const parser_debug_flag_t flag)
{
	return (L_DEBUG_FLAGS & flag);
}

#define IS_DEBUG_FUNC is_debug_enabled(L_PARSER_DEBUG_FUNC)
#define IS_DEBUG_DECL is_debug_enabled(L_PARSER_DEBUG_DECL)
#define IS_DEBUG_EXPR is_debug_enabled(L_PARSER_DEBUG_EXPR)
#define IS_DEBUG_EXPR is_debug_enabled(L_PARSER_DEBUG_EXPR)
#define IS_DEBUG_STMT is_debug_enabled(L_PARSER_DEBUG_STMT)
#define IS_DEBUG_PTR  is_debug_enabled(L_PARSER_DEBUG_PTR)
#define IS_DEBUG_PROG is_debug_enabled(L_PARSER_DEBUG_PROG)
#define IS_DEBUG_TKN  is_debug_enabled(L_PARSER_DEBUG_TKN)
