# Claude Code

Read and follow **[AGENTS.md](./AGENTS.md)** for build, test, lint, architecture, and safety rules for this repository.

Claude-specific notes:

- Prefer `cmake --preset` / `ctest --preset` / `cmake --build --preset` for reproducible builds.
- Do not add repo-level MCP servers or permission overrides here; use user-level config for personal tooling.
- For repeatable template instantiation, use `scripts/new-cpp-lib.py` with `--help` rather than manual mass rename.
