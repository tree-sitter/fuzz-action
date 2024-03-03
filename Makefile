LANG_NAME ?=
LANG_DIR ?=
TIMEOUT ?= 10
MAX_TIME ?= 60
MAX_LEN ?= 4096
FUZZER_DIR ?= .
CORPUS_DIR ?=

JQ_FILTER := .. | select((.type? == "STRING" or (.type? == "ALIAS" and .named? == false)) and .value? != "") | .value

fuzz: $(FUZZER_DIR)/fuzzer $(FUZZER_DIR)/dict
	@mkdir -p $(FUZZER_DIR)/artifacts $(FUZZER_DIR)/out
	$(<D)/$(<F) $(FUZZER_DIR)/out $(CORPUS_DIR) \
		-dict=$(word 2,$^) -artifact_prefix=$(FUZZER_DIR)/artifacts/ \
		-timeout=$(TIMEOUT) -max_total_time=$(MAX_TIME) -max_len=$(MAX_LEN)

$(FUZZER_DIR)/dict: $(LANG_DIR)/src/grammar.json
	jq '$(JQ_FILTER)' $^ | grep -v '\\' | iconv -c -f UTF-8 -t ASCII//TRANSLIT > $(FUZZER_DIR)/dict

$(FUZZER_DIR)/fuzzer: fuzzer.c $(LANG_DIR)/src/parser.c $(wildcard $(LANG_DIR)/src/scanner.c)
	$(eval LANGUAGE = $(if $(LANG_NAME),tree_sitter_$(LANG_NAME),$(error LANG_NAME must be set)))
	clang -fsanitize=fuzzer,address,undefined -fsanitize-ignorelist=ignorelist.ini \
		-Wall -Wno-unused-but-set-variable -std=c11 -O0 -g -I$(LANG_DIR)/src \
		-Dlanguage=$(LANGUAGE) $$(pkg-config --cflags --libs tree-sitter) $^ -o $@

.PHONY:
clean:
	@rm -rf $(FUZZER_DIR)/artifacts $(FUZZER_DIR)/out $(FUZZER_DIR)/dict $(FUZZER_DIR)/fuzzer
