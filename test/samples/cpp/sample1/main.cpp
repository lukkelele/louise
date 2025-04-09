#include <iostream>

#include <parser.tab.hh>

#define SAMPLE_NAME "cpp_sample1"

int main()
{
    std::printf("Running %s\n", SAMPLE_NAME);

    yy::parser parser;
    const int ret = parser.parse();

    return 0;
}
