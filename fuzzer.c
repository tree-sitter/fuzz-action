#include <tree_sitter/api.h>

#ifndef language
#error "language must be defined"
#endif

const TSLanguage *language(void);

int LLVMFuzzerTestOneInput(const uint8_t * data, const size_t len) {
    // Create a parser.
    TSParser *parser = ts_parser_new();

    // Set the parser's language.
    ts_parser_set_language(parser, language());

    // Build a syntax tree based on source code stored in a string.
    TSTree *tree = ts_parser_parse_string(parser, NULL, (const char *) data, len);

    // Free all of the heap-allocated memory.
    ts_tree_delete(tree);
    ts_parser_delete(parser);
    return 0;
}
