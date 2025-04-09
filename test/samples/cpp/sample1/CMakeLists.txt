cmake_minimum_required(VERSION 3.5)
project(louise_cpp_sample1 LANGUAGES CXX)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

message(STATUS "CMAKE_SOURCE_DIR: ${CMAKE_SOURCE_DIR}")
message(STATUS "CMAKE_BINARY_DIR: ${CMAKE_BINARY_DIR}")

# Parser files.
BISON_TARGET(Parser
  parser_cpp.y 
  ${CMAKE_BINARY_DIR}/parser.tab.cc
  DEFINES_FILE ${CMAKE_BINARY_DIR}/parser.tab.hh
)

# Lexer files.
FLEX_TARGET(Lexer
  ${CMAKE_CURRENT_SOURCE_DIR}/lexer.l
  ${CMAKE_BINARY_DIR}/lexer.y.cc
)

ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)

add_executable(${PROJECT_NAME}
  #main.cpp
  ${BISON_Parser_OUTPUTS}
  ${FLEX_Lexer_OUTPUTS}
)

target_include_directories(${PROJECT_NAME} PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_BINARY_DIR}
)
