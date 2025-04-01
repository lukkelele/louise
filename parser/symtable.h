/**
 * @file
 * @brief Symbol table.
 */
#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * @struct symtable
 */
typedef struct symtable
{
	char* name;
	int offset;
	struct symtable* symlink;
} symtable;

int dataoffset = 0;

int next_data_location()
{
	return dataoffset++;
}

symtable* current_node = (symtable*)0;

/**
 * @brief Create a new node and add it to the existing sym chain.
 */
symtable* put_symbol(char* sym_name)
{
	symtable* new_node = (symtable*)malloc(sizeof(symtable));
	new_node->name = (char*)malloc(sizeof(sym_name) + 1);
	strcpy(new_node->name, sym_name);
	new_node->offset = next_data_location();
	new_node->symlink = (symtable*)current_node;
	current_node = new_node;

	return new_node;
}

/**
 * @brief Get symbol.
 */
symtable* get_symbol(char* sym_name)
{
	symtable* node_ref = current_node;
	while (node_ref)
	{
		if (strcmp(node_ref->name, sym_name) == 0)
		{
			return node_ref;
		}

		node_ref = node_ref->symlink;
	}

	return 0;
}

void print_symtable()
{
	symtable* node_ref = current_node;
	while (node_ref)
	{
		printf("%s -- %d\n", node_ref->name, node_ref->offset);
		node_ref = node_ref->symlink;
	}
}
