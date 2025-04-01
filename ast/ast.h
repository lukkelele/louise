#pragma once

#include <stdlib.h>
#include <string.h>

/**
 * @enum ast_node_type_t
 * AST node type.
 */
typedef enum ast_node_type_t
{
	AST_INTEGER_LITERAL,
	AST_BINARY_EXPRESSION
} ast_node_type_t;

/**
 * @struct ast_node_t
 */
typedef struct ast_node_t
{
	ast_node_type_t type;
} ast_node_t;

/**
 * @struct integer_literal_t
 */
typedef struct integer_literal_t
{
	ast_node_t base;
	int value;
} integer_literal_t;
