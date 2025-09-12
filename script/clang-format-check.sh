#!/bin/bash

if [ -z "$CLANG_FORMAT_VERSION" ]; then
	printf "Error: variable CLANG_FORMAT_VERSION is required\n"
	exit 1
fi

if [ -z "$CLANG_FORMAT_DIRECTORIES" ]; then
	printf "Error: variable CLANG_FORMAT_DIRECTORIES is required\n"
	exit 1
fi

if [ -z "$CLANG_FORMAT_FILE_EXTENSIONS" ]; then
	printf "Error: variable CLANG_FORMAT_FILE_EXTENSIONS is required\n"
	exit 1
fi

if [ -z "$CLANG_FORMAT_STYLE" ]; then
	printf "Error: variable CLANG_FORMAT_STYLE is required\n"
	exit 1
fi

CLANG_FORMAT_ARGS=()
CLANG_FORMAT_ARGS+=("--style=$CLANG_FORMAT_STYLE")

if [ "$CLANG_FORMAT_WERROR" = "true" ]; then
	CLANG_FORMAT_ARGS+=("--Werror")
fi

if [ -n "$CLANG_FORMAT_EXTRA_ARGS" ]; then
	read -ra CLANG_FORMAT_EXTRA_ARGS_ARRAY <<<"$CLANG_FORMAT_EXTRA_ARGS"
	CLANG_FORMAT_ARGS+=("${CLANG_FORMAT_EXTRA_ARGS_ARRAY[@]}")
fi

function remove_spaces_around_commas() {
	if [ "$#" -ne 1 ]; then
		printf "Error: function remove_spaces_around_commas() expects 1 argument, but %s were provided\n" "$#"
		exit 1
	fi

	printf "%s" "$(sed 's/[[:space:]]*,[[:space:]]*/,/g' <<<$1)"
}

CLANG_FORMAT_DIRECTORIES=$(remove_spaces_around_commas "$CLANG_FORMAT_DIRECTORIES")
IFS=',' read -ra DIR_ARRAY <<<"$CLANG_FORMAT_DIRECTORIES"
for DIR in "${DIR_ARRAY[@]}"; do
	if [ ! -d "$DIR" ]; then
		printf "Error: %s is not a directory\n" "$DIR"
		exit 1
	fi
done

CLANG_FORMAT_FILE_EXTENSIONS=$(remove_spaces_around_commas "$CLANG_FORMAT_FILE_EXTENSIONS")
FILE_EXTENSIONS_REGEX="${CLANG_FORMAT_FILE_EXTENSIONS//,/|}"

FILES_TO_CHECK=$(find "${DIR_ARRAY[@]}" -regextype posix-extended -regex ".*($FILE_EXTENSIONS_REGEX)$")

function print_delim() {
	printf -- "---\n"
}

CHECK_FAIL="false"

printf "Checking code formatting with clang-format...\n"
printf "clang-format arguments: %s\n" "${CLANG_FORMAT_ARGS[*]}"
print_delim

while IFS= read -r FILE; do

	printf "Checking file %s...\n" "$FILE"

	if ! clang-format-"$CLANG_FORMAT_VERSION" "${CLANG_FORMAT_ARGS[@]}" \
		--dry-run -- "$FILE" 2>&1; then
		CHECK_FAIL="true"
	fi

	print_delim
done <<<"$FILES_TO_CHECK"

if [ "$CHECK_FAIL" = "true" ]; then
	printf "### clang-format formatting check FAIL ###\n"
	exit 1
else
	printf "### clang-format formatting check SUCCESS ###\n"
	exit 0
fi
