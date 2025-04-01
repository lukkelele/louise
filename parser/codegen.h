/**
 * @file
 * @brief Code generation.
 */
#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * @enum parser_op_t
 * Parser operation type.
 */
typedef enum parser_op_t
{
	PARSER_OP_HALT,
	PARSER_OP_DATA,
	PARSER_OP_READ_INT,
	PARSER_OP_WRITE_INT,
	PARSER_OP_LOAD_VAR,
	PARSER_OP_LOAD_INT,
	PARSER_OP_STORE,
	PARSER_OP_ADD,
	PARSER_OP_MULT,
	PARSER_OP_DIV,
	PARSER_OP_SUB,
	PARSER_OP_GT,
	PARSER_OP_LT,
	PARSER_OP_EQ,
	PARSER_OP_GOTO,
	PARSER_OP_JMP_FALSE,
	PARSER_OP_JMP_TRUE,
	PARSER_OP_JMP,
	PARSER_OP_LE,
	PARSER_OP_NE,
	PARSER_OP_GE
} parser_op_t;

static const char* parser_op_str_arr[] = {
	"halt",
	"data_block",
	"in_int",
	"out_ac",
	"ld_var",
	"ld_int",
	"store",
	"add",
	"mult",
	"div",
	"sub",
	"gt",
	"lt",
	"eq",
	"goto",
	"jmp_false",
	"jmp_true",
	"jmp",
	"le",
	"ne",
	"ge"
};

/**
 * @var code_offset
 * Code line generator for the code sheet.
 */
int code_offset = 0;

int current_code_line()
{
	return code_offset;
}

int next_code_line()
{
	return code_offset++;
}

/**
 * @struct cslabel
 *
 * Label generation.
 */
typedef struct cslabel
{
	int jmp_true;
	int jmp_false;
} cslabel;

cslabel* gen_label()
{
	cslabel* ptr = (cslabel*)malloc(sizeof(cslabel));
	return ptr;
}

/**
 * @struct codesheet
 */
typedef struct codesheet
{
	parser_op_t inst;
	int data_pos;
} codesheet;

struct codesheet code[999];

/**
 * @brief Fill the code sheet table
 */
int codegen(parser_op_t op, int arg)
{
	code[code_offset].inst = op;
	code[code_offset].data_pos = arg;
	code_offset++;

	return code_offset;
}

/**
 * @brief Fix jump.
 */
void fix_jmp(parser_op_t op, int arg)
{
	code[arg].inst = op;
	code[arg].data_pos = code_offset;
}

void print_code()
{
	int i = 0;
	printf(">> CODE\n");
	while (i < code_offset)
	{
		printf(" %-4d: %-4s %-4d\n", i, parser_op_str_arr[(int)code[i].inst], code[i].data_pos);
		i++;
	}
}

/**
 * @brief Conditional jump for single 'if'.
 */
void fix_shift_a(int xpos, int ypos)
{
	int i;
	code_offset++;

	for (i = ypos; i >= xpos; i--)
	{
		code[i + 1].inst = code[i].inst;
		code[i + 1].data_pos = code[i].data_pos;
	}

	code[xpos].inst = PARSER_OP_JMP_FALSE;
	code[xpos].data_pos = ypos + 1;
}

/**
 * @brief Conditional jump for 'if else'.
 */
void fix_shift_b(int xpos, int ypos, int zpos)
{
	int i;
	code_offset += 2;

	for (i = zpos; i >= xpos; i--)
	{
		code[i + 1].inst = code[i].inst;
		code[i + 1].data_pos = code[i].data_pos;
	}

	code[xpos].inst = PARSER_OP_JMP_FALSE;
	code[xpos].data_pos = ypos + 2;

	for (i = (zpos + 1); i >= (ypos + 1); i--)
	{
		code[i + 1].inst = code[i].inst;
		code[i + 1].data_pos = code[i].data_pos;
	}

	code[ypos + 1].inst = PARSER_OP_JMP;
	code[ypos + 1].data_pos = zpos + 2;
}
