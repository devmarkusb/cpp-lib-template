# cpp-lib-template

<!-- markdownlint-disable-next-line line-length -->
![Continuous Integration Tests](https://github.com/devmarkusb/cpp-lib-template/actions/workflows/ci_tests.yml/badge.svg) ![Lint Check (pre-commit)](https://github.com/devmarkusb/cpp-lib-template/actions/workflows/pre-commit-check.yml/badge.svg) [![Coverage](https://coveralls.io/repos/github/devmarkusb/cpp-lib-template/badge.svg?branch=main)](https://coveralls.io/github/devmarkusb/cpp-lib-template?branch=main)

A generic C++ library template. Contains the useful basic stuff
probably needed for any C++ library. Especially a jump start
towards connecting to a basic professional infrastructure
for building and CI.

By default, this builds a **static** library with a split header and `.cpp` implementation. Set
`MB_CPP_LIB_TEMPLATE_HEADER_ONLY=ON` to build the same API as a **header-only** `INTERFACE` library (no object code in
the library target; implementation is `inline` in the generated public header).

## Quick start

The repo uses submodules (e.g. for `devenv`). After clone:

```bash
git submodule update --init --recursive
```

To sync submodules (and optionally Git LFS) later, from the repo root:

```bash
devenv/git-sub.sh
```

**Build** (CMake 3.30+, C++26, Ninja). From repo root:

```bash
cmake --preset gcc-debug
cmake --build build/gcc-debug
```

Run tests:

```bash
ctest --preset gcc-debug
```

**Pre-commit** (optional, for local lint/format): create a venv and install hooks:

```bash
./devenv/bootstrap.sh
```

Then `pre-commit` runs on commit; you can also run `pre-commit run -a` manually.

## Usage when starting a new library

1. Create your new repo (e.g. on GitHub).
2. Copy everything except devenv, .git, and similar, from this template.
3. Add <https://github.com/devmarkusb/devenv> as submodule, cf. README.md there.
4. Rename namespace and library names everywhere. See the top comment in `CMakeLists.txt` for what to change:
    - `MB_CPP_LIB_TEMPLATE` (CMake option prefix)
    - `cpp-lib-template` (project and target names)
    - `mb.` / `mb::` / `mb/` (namespace and install layout)
    - files and dirs
5. Go. When you find improvements that belong in the template, consider contributing them back here.

## CMake options

| Option                                  | Default             | Description                                                                 |
|-----------------------------------------|---------------------|-----------------------------------------------------------------------------|
| `MB_CPP_LIB_TEMPLATE_HEADER_ONLY`       | `OFF`               | Header-only `INTERFACE` library vs static library with sources under `src/`. |
| `MB_CPP_LIB_TEMPLATE_BUILD_TESTS`       | `ON` when top-level | Build tests and test infra (GoogleTest).                                    |
| `MB_CPP_LIB_TEMPLATE_BUILD_EXAMPLES`    | `ON` when top-level | Build example executables.                                                  |

## Build presets

`CMakePresets.json` defines configure/build/test presets for:

- **Compilers:** GCC, Clang, Clang with libc++, AppleClang, MSVC.
- **Configurations:** Debug, RelWithDebInfo (release).
- **Preset names:** e.g. `gcc-debug`, `clang-release`, `msvc-debug`, `appleclang-release`.

C++ standard is 26 (23 for MSVC). Compile commands are exported for tooling. A dependency provider uses
`fetchcontent-lockfile.json` so `find_package(GTest)` is satisfied from locked Git versions without system GTest.

## Directory structure

### `.github/`

- **`workflows/ci_tests.yml`** — CI: preset-based build/test on Linux (GCC/Clang), macOS (AppleClang), Windows (MSVC);
  extended build-and-test matrix (GCC 14/15, Clang 18/21, sanitizers, coverage); install test.
- **`workflows/pre-commit-check.yml`** — Runs pre-commit on push to `main` and on pull requests.
- **`workflows/pre-commit-update.yml`** — Weekly (and manual) pre-commit hook autoupdate.

### `cmake/`

- **`mb.cpp-lib-template-config.cmake.in`** — Template for the CMake config-file package (used when installing the
  library so consumers can `find_package(mb.cpp-lib-template)`).

### `devenv/`

Development and CI support (typically as a submodule): see
<https://github.com/devmarkusb/devenv>.

### `examples/`

- **`CMakeLists.txt`** — Builds example executables (e.g. `usage`) that link to the library.
- **`usage.cpp`** — Example program using the library (e.g. `mb::cpp_lib_template::sum`).

### `include/`

- **`mb/cpp-lib-template/`** — Public headers, exposed via a FILE_SET.

### `src/`

- **`CMakeLists.txt`** — Adds compiled `.cpp` sources to the static library when `MB_CPP_LIB_TEMPLATE_HEADER_ONLY` is
  OFF; registers tests when `MB_CPP_LIB_TEMPLATE_BUILD_TESTS` is ON.
- **`cpp-lib-template.cpp`** — Library implementation (not used in header-only mode).
- **`cpp-lib-template.test.cpp`** — GoogleTest sources; built only when `MB_CPP_LIB_TEMPLATE_BUILD_TESTS` is ON.

### Root files

- **`CMakeLists.txt`** — Top-level: project, options, library target (static by default, or header-only `INTERFACE`
  when `MB_CPP_LIB_TEMPLATE_HEADER_ONLY=ON`), install, tests, examples.
- **`CMakePresets.json`** — Configure, build, test, and workflow presets for multiple compilers and configs.
- **`fetchcontent-lockfile.json`** — Locked dependencies for the CMake dependency provider (e.g. Googletest at a fixed
  Git tag).
- **`.pre-commit-config.yaml`** — Pre-commit hooks: trailing whitespace, EOF, JSON/YAML checks, clang-format, gersemi (
  CMake), markdownlint, codespell (hooks apply to repo; `devenv/` is excluded). To sync `.clang-format` from
  [devmarkusb/clangformat](https://github.com/devmarkusb/clangformat) (including versioned configs), run
  `cd devenv && ./sync-clang-format.sh [VERSION]` (run from inside `devenv`).
