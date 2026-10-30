
- fix awesome :kill() for clients
- live updates of symlinks for home-manager
- configure kernel
- configure ly
- configure bootloader
- disable all pagers globally

- make a language server bats test harness for having deterministic tests for
  the LSP

- fix slock patch not applying

- possibly investigate using ghostty instead?

- new tab should be in the same directory as the current one, not $HOME
- ask a forum how to do it

- make your shell have $ for the first tab $$ for the second, etc.

- vim completion for files sorted by mtime, not name

---

Skill for writing your makefiles

---

when writing a CPP language server use the CPP Core Guidelines are warnings and
hints and errors and such in diagnostics

---

using vim's errorfile concept for joining with neovim diagnostics

create a plugin for this maybe

so on an event that populates the quickfix lists you pass populate diagnostics
with the contents of it

---

plugin for gf that uses vim compiler error files as well to support gf for the
output of any compiler error

---

contribute to vim a compiler plugin for clang-tidy and oelint-adv

---

This seems to implement what you wanted, the core guidelines linting

clang-tidy -checks='cppcoreguidelines-*' main.cpp -- -std=c++20


---

anakins-agents the top level agent has no tools only can call subagents that
have the tools so that the top level agent is not blocked


