#include "parser.h"

static parser_t instance;

parser_t* parser_instance()
{
	return &instance;
}
