# Agent instructions — cpp-lib-template

Canonical project guidance for AI agents (Cursor, Claude Code, Copilot, etc.). Tool-specific files in this repo are thin adapters; do not duplicate this content elsewhere.

## Project overview

C++ **library template** (`mb.cpp-lib-template`): static library by default, optional header-only mode. Demonstrates professional CMake layout, FetchContent lockfile deps, GoogleTest, examples, install/`find_package`, and CI via the **`devenv`** git submodule ([devmarkusb/devenv](https://github.com/devmarkusb/devenv)).

- **CMake project name:** `mb.cpp-lib-template` (must stay `vendor.lib` — two dot-separated segments for `mb_devenv_install_library`).
- **Namespace:** `mb::cpp_lib_template`
- **Public headers:** `include/mb/cpp-lib-template/`
- **Implementation:** `src/` (omitted when `MB_CPP_LIB_TEMPLATE_HEADER_ONLY=ON`)
- **C++ standard:** 26 for GCC/Clang presets; 23 for `msvc-*` and `appleclang-*` in `CMakePresets.json`
- **Submodule required:** `devenv/` — run `git submodule update --init --recursive` after clone

`scripts/new-cpp-lib.py` instantiates a new library from this template; treat template-renaming logic there as authoritative when generating new projects.

## Build commands

Prerequisites: CMake 3.30+, Ninja, compatible toolchain. Initialize submodules first.

```bash
git submodule update --init --recursive
cmake --preset gcc-debug
cmake --build --preset gcc-debug
```

Alternate (same binary dir layout `build/<presetName>/`):

```bash
cmake --preset clang-debug
cmake --build build/clang-debug
```

Common configure presets: `gcc-debug`, `gcc-release`, `clang-debug`, `clang-release`, `clang-libc++-debug`, `clang-libc++-release`, `appleclang-debug`, `appleclang-release`, `msvc-debug`, `msvc-release`. List all: `cmake --list-presets`.

`CMakeUserPresets.json` is gitignored and may add local presets (e.g. IDE-specific); do not commit it.

## Test commands

Configure with tests enabled (`MB_CPP_LIB_TEMPLATE_BUILD_TESTS=ON`, default when top-level):

```bash
ctest --preset gcc-debug
```

Or after build:

```bash
ctest --test-dir build/gcc-debug --output-on-failure
```

Tests live in `src/*.test.cpp` and register via `mb_devenv_add_test` (GoogleTest).

## Formatting and linting

**Pre-commit** (`.pre-commit-config.yaml`): trailing whitespace, JSON/YAML checks, markdownlint, codespell, ruff/pyupgrade on Python, gersemi (CMake), clang-format (C/C++).

After CMake configure, hooks are installed by **mb-pre-commit** (from `fetchcontent-lockfile.json`). Run the full hook sweep:

```bash
cmake --preset gcc-debug   # once, if not configured
cmake --build --preset gcc-debug --target mb-pre-commit-sweep
```

Equivalent: `ninja -C build/gcc-debug mb-pre-commit-sweep`.

Manual (if `pre-commit` is on PATH): `pre-commit run -a`.

**clang-format:** `.clang-format` (LLVM-based). **clang-tidy:** `.clang-tidy` at repo root; optional review via devenv:

```bash
python3 devenv/clang-tidy-review.py changed
python3 devenv/clang-tidy-review.py full --preset clang-debug
```

Requires a configured preset with `compile_commands.json`. Use `--install` on supported platforms if clang-tidy is missing.

README mentions `./devenv/bootstrap.sh` for pre-commit setup; **that script is not present** in the current `devenv` submodule — use CMake configure + `mb-pre-commit-sweep` instead.

## Architecture and important directories

| Path | Role |
|------|------|
| `CMakeLists.txt`, `CMakePresets.json` | Top-level build, presets, options |
| `fetchcontent-lockfile.json` | Pinned FetchContent deps (GTest, mb-pre-commit, dot-clangformat/tidy) |
| `cmake/` | `find_package` config template |
| `include/mb/cpp-lib-template/` | Public API headers (FILE_SET) |
| `src/` | Library `.cpp` and `*.test.cpp` |
| `examples/` | Example executables linking the library |
| `devenv/` | Submodule: toolchains, CI workflow reuse, helper scripts |
| `scripts/new-cpp-lib.py` | Template → new library generator |
| `.github/workflows/` | CI entrypoints (delegate to `devenv` reusable workflows) |
| `build/` | Out-of-tree build output (gitignored) |

Not a monorepo; no nested `AGENTS.md` unless a subtree gains a different toolchain.

## Coding conventions

- Match existing style: `mb::cpp_lib_template` namespace, snake_case for functions, include guard macros with unique suffix in headers.
- CMake options use prefix `MB_CPP_LIB_TEMPLATE_*`; library target `mb.cpp-lib-template`, alias `mb::cpp-lib-template`.
- Prefer `mb_devenv_*` helpers from `devenv/cmake` over ad hoc CMake.
- New tests: GoogleTest in `src/*.test.cpp`, registered through `mb_devenv_add_test`.
- Python in `scripts/` targets 3.10+ (pyupgrade hook).
- When renaming for a real project, follow the checklist at the top of `CMakeLists.txt` or use `scripts/new-cpp-lib.py`.

## Testing expectations

- Add or update tests for behavior changes in `src/*.test.cpp`.
- Run `ctest --preset <same-as-build>` before claiming done.
- CI runs preset tests (Linux/macOS/Windows) and extended sanitizer/coverage matrices via `devenv` workflows — local `gcc-debug` is the usual fast check.

## Files and directories agents must not edit without explicit approval

- **Secrets / local env:** `.env`, credentials, tokens
- **Lockfiles:** `fetchcontent-lockfile.json`, `devenv/fetchcontent-lockfile.json` (pins CI reproducibility)
- **Generated / build output:** `build/`, `compile_commands.json` at repo root, FetchContent trees under `build/**/_deps/`
- **Submodule content:** `devenv/` — prefer PRs to [devmarkusb/devenv](https://github.com/devmarkusb/devenv); only touch here for integration glue in the parent repo
- **User-local CMake:** `CMakeUserPresets.json` (gitignored)
- **CI release / deployment:** `.github/workflows/*` unless the task is CI-related; reusable workflow logic lives upstream in `devenv`
- **Vendored / fetched code:** Do not hand-edit populated dependencies under `build/`

## Security and privacy constraints

- No secrets in repo, commits, or agent config.
- Do not weaken CI, sanitizers, or hook checks without explicit request.
- `pre-commit-check.yml` uses `pull_request_target` for reviewdog permissions — do not broaden token scopes casually.

## Review checklist before final response

- [ ] Submodules initialized if CMake/devenv paths were used
- [ ] Build and tests run for the preset you used (or note why skipped)
- [ ] `mb-pre-commit-sweep` or equivalent hooks considered for touched file types
- [ ] No edits to lockfiles, `devenv/` internals, or CI unless requested
- [ ] Changes scoped to the task; template rename rules respected if touching names/paths
