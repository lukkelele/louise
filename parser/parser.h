/**
 * @file
 * @brief L parser.
 */
#pragma once

#include <stdarg.h>
#include <stdbool.h>
#include <string.h>

/**
 * @struct parser_t
 */
typedef struct parser_t
{
	int argc;
	char** argv;
	bool initialized;
} parser_t;

/**
 * @brief Get the parser instance.
 */
parser_t* parser_instance();
