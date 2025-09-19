# Clang Format Check

A fast and lightweight **GitHub Action** for automated C++ code formatting validation using
the [clang-format](https://clang.llvm.org/docs/ClangFormat.html) code formatter. Designed to integrate seamlessly into
your **GitHub Workflows** for continuous formatting style enforcement.

## Supported Platforms

This action currently supports **Ubuntu** runners only (including `ubuntu-latest` and `ubuntu-22.04`).

## Behavior

The action processes all files with specified extensions in the given directories using **clang-format**,
checking if the code follows the configured formatting style.

Action will fail with exit code 1 if any **clang-format** errors occur.

## Arguments

### `version`: \<string\> (optional)

Specifies the **clang-format** version to use.

- **Default:** `'18'`
- **Example:** `'16'`, `'18'`, `'20'`

For the list of supported versions on your runner, please, refer
to [GitHub Actions Runner Images](https://github.com/actions/runner-images)
and [Ubuntu Packages](https://packages.ubuntu.com/plucky/clang-format).

### `directories`: \<string\> (required)

Comma-separated list of directories to recursively scan for files.

- **Example:** `'src,include'`, `'./src'`, `'src,tests,examples'`

### `file-extensions`: \<string\> (optional)

Comma-separated list of file extensions to include in the formatting check.

- **Default:** `'cpp,hpp,c,h'`
- **Example:** `'cpp,hpp,cxx,hxx'`, `'c,h'`

### `style`: \<string\> (optional)

Formatting style used by **clang-format**. Uses the same format as **clang-format** `--style=` option.

- **Default:** `'file'`
- **Example:** `'Google'`, `'LLVM'`, `'Mozilla'`

When set to `'file'`, **clang-format** will look for a `.clang-format` file in the project directory.

### `werror`: \<boolean\> (optional)

Whether to treat formatting violations as errors, causing the action to fail. Same as **clang-tidy**
`--Werror` option.

- **Default:** `true`
- **Example:** `true`, `false`

### `extra-args`: \<string\> (optional)

Additional arguments to pass directly to **clang-format**.

- **Default:** `''`
- **Example:** `'--verbose'`

## Output

The action provides following outputs:

- Individual file formatting status
- **clang-format** warnings and errors
- Final summary (SUCCESS/FAIL)

## Examples

### Example With All Options

In your **GitHub Workflow:**

```yml
- name: Run clang-format check
  uses: T-im4i-k/clang-format-check@v1
  with:
    version: '18'
    directories: 'src,include,test'
    file-extensions: 'cpp,hpp,cxx,hxx'
    style: 'Google'
    werror: true
    extra-args: '--verbose'
```

### Minimal Working Example

In your **GitHub Workflow:**

```yml
- name: Run clang-format check
  uses: T-im4i-k/clang-format-check@v1
  with:
    directories: 'src'
```