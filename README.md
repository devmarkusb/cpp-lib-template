# cpp-lib-template

<!-- markdownlint-disable-next-line line-length -->
![Continuous Integration Tests](https://github.com/devmarkusb/cpp-lib-template/actions/workflows/ci_tests.yml/badge.svg) ![Lint Check (pre-commit)](https://github.com/devmarkusb/cpp-lib-template/actions/workflows/pre-commit-check.yml/badge.svg) [![Coverage](https://coveralls.io/repos/github/devmarkusb/cpp-lib-template/badge.svg?branch=main)](https://coveralls.io/github/devmarkusb/cpp-lib-template?branch=main)

A generic C++ library template. Contains the useful basic stuff
probably needed for any C++ library. Especially a jump start
towards connecting to a basic professional infrastructure
for building and CI.

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

| Option                               | Default             | Description                              |
|--------------------------------------|---------------------|------------------------------------------|
| `MB_CPP_LIB_TEMPLATE_BUILD_TESTS`    | `ON` when top-level | Build tests and test infra (GoogleTest). |
| `MB_CPP_LIB_TEMPLATE_BUILD_EXAMPLES` | `ON` when top-level | Build example executables.               |

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

Development and CI support (often as a submodule):

- **`bootstrap.sh`** — Creates `.venv`, installs pre-commit, runs `pre-commit install`.
- **`git-sub.sh`** — `git submodule update --init --recursive` (and Git LFS pull if used).
- **`cmake/install-library-config.cmake`** — Defines `mb_install_library()`: installs target, headers, and optional
  config package (used by root `CMakeLists.txt`).
- **`cmake/fetch-content-from-lockfile.cmake`** — CMake dependency provider: reads `fetchcontent-lockfile.json` and
  provides packages (e.g. GTest) via FetchContent with locked versions.
- **`cmake/toolchains/`** — Toolchain files for GCC, Clang, Clang-libc++, AppleClang, MSVC; optional sanitizers (e.g.
  TSan, MaxSan) via `MB_SANITIZER`.

### `examples/`

- **`CMakeLists.txt`** — Builds example executables (e.g. `usage`) that link to the library.
- **`usage.cpp`** — Example program using the library (e.g. `mb::cpp_lib_template::sum`).

### `include/`

- **`mb/cpp-lib-template/`** — Public headers. Template ships a single header `cpp-lib-template.hpp` and an INTERFACE
  library; headers are exposed via a FILE_SET.

### `src/`

- **`cpp-lib-template/`** — Test sources (e.g. `cpp-lib-template.test.cpp` using GoogleTest). Built only when
  `MB_CPP_LIB_TEMPLATE_BUILD_TESTS` is ON.

### Root files

- **`CMakeLists.txt`** — Top-level: project, options, INTERFACE library, install, tests, examples.
- **`CMakePresets.json`** — Configure, build, test, and workflow presets for multiple compilers and configs.
- **`fetchcontent-lockfile.json`** — Locked dependencies for the CMake dependency provider (e.g. Googletest at a fixed
  Git tag).
- **`.pre-commit-config.yaml`** — Pre-commit hooks: trailing whitespace, EOF, JSON/YAML checks, clang-format, gersemi (
  CMake), markdownlint, codespell (hooks apply to repo; `devenv/` is excluded). To sync `.clang-format` from
  [devmarkusb/clangformat](https://github.com/devmarkusb/clangformat) (including versioned configs), run
  `cd devenv && ./sync-clang-format.sh [VERSION]` (run from inside `devenv`).
