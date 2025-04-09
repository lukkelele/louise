BUILD_DIR := build

YACC_SOURCE := parser_cpp.y
LEXER_SOURCE := lexer.l

BISON_OUT_CC := $(BUILD_DIR)/parser_cpp.tab.cc
BISON_OUT_HH := $(BUILD_DIR)/parser_cpp.tab.hh
FLEX_OUT_CC := $(BUILD_DIR)/lexer.lex.cc
EXECUTABLE := $(BUILD_DIR)/parser_cpp

# Compiler.
CXX := g++
CXXFLAGS := -std=c++17

all: $(EXECUTABLE)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)


# Compile executable
$(EXECUTABLE): $(BISON_OUT_CC) $(FLEX_OUT_CC)
	$(CXX) $(CXXFLAGS) -o $@ $^

# Generate Bison output
$(BISON_OUT_CC) $(BISON_OUT_HH): $(YACC_SOURCE) | $(BUILD_DIR)
	bison -d -o $(BISON_OUT_CC) $(YACC_SOURCE)

# Generate Flex output
$(FLEX_OUT_CC): $(LEXER_SOURCE) $(BISON_OUT_HH) | $(BUILD_DIR)
	flex -o $(FLEX_OUT_CC) $(LEXER_SOURCE)

clean:
	rm -rf $(BUILD_DIR)