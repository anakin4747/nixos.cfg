---
name: bash-scripting
description: Use when writing bash/shell scripts. Enforces explicit manual error handling (no set -e/-u/-o pipefail), colored die()/log() helpers, printf-only output, long options, strict quoting, and early guard checks.
---

# Writing Bash Scripts

Follow every rule below when writing or modifying a bash script.

## Required helpers

Every script must define `die` and `log` near the top, before any other logic.

- `die` prints **all** of its arguments in **red** to stderr, prefixed with `error: `, then exits non-zero.
- `log` prints **all** of its arguments in **green** to stdout.

```bash
ME=$0

die() {
    printf "\033[31m${ME}: error: %s\033[0m\n" "$*" >&2
    exit 1
}

log() {
    printf "\033[32m${ME}: %s\033[0m\n" "$*"
}
```

Always use `die` for fatal errors and `log` for status/progress/success
messages. Do not write ad-hoc `echo`/`printf` error or status lines when these
helpers apply.

`log` shall be used before every command describing what that command is
attempting to do and `log` shall be used after every command succeeding.

For example:

```sh
log "copying file to folder"
if ! cp file folder/; then
    die "copying file to folder failed"
fi
log "copying file to folder succeeded"
```

The wording in the log message before, the die message, and the log message
after should always use very similar wording.

## Never use set -* options

Do not use `set -e`, `set -u`, `set -o pipefail`, or any `set -*` option. Every
error must be handled manually and explicitly.

## Manual error handling

Wrap every significant command in an explicit check that calls `die`.

### Short commands

```bash
if ! <command>; then
    die "<command> failed"
fi
```

### Long commands with line continuations

The `then` goes on its own line:

```bash
if ! <command> \
    --long-arg1 \
    --long-arg2
then
    die "<command> failed"
fi
```

## Prefer long options

Use long option names (`--quiet`, `--recursive`, `--exclude`) over short ones
(`-q`, `-r`, `-e`). Long options are self-documenting. Exceptions: tight
interactive one-liners, well-known combinations like `rm -rf`, or many combined
single-letter flags where long forms would be excessively verbose.

## Variable conventions

- Lowercase for local script variables (`src_file`, `dest_dir`).
- `: "${VAR:=default}"` for optional environment variables with defaults.
- Quote all variable expansions (`"$var"`, not `$var`) unless word-splitting is
  explicitly desired.
- `$(...)` over backticks for command substitution.
- Declare function-local variables with `local`.

## Guard patterns

- Validate argument count early: `if [ $# -ne 1 ]; then usage; fi`
- Check file existence before operating: `if [ ! -f "$src_file" ]; then die "not found: $src_file"; fi`
- Validate path structure with `case` before stripping prefixes.
- If the script has specific dependencies that may not be assumed to be
  available (ex. ripgrep, jq, openssl) then check for them at the beginning of
  the script with logic that reports every single missing program.

## Redirects

Always place a space after `>` redirects to files:

Do this:
```sh
echo > file
```

Not this:
```sh
echo >file
```

Unless it is combining streams like `>&2`
