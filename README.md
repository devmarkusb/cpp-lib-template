# cpp-lib-template

<!-- markdownlint-disable-next-line line-length -->
![Continuous Integration Tests](https://github.com/devmarkusb/cpp-lib-template/actions/workflows/ci.yml/badge.svg) ![Lint Check (pre-commit)](https://github.com/devmarkusb/cpp-lib-template/actions/workflows/pre-commit-check.yml/badge.svg) [![Coverage](https://coveralls.io/repos/github/devmarkusb/cpp-lib-template/badge.svg?branch=main)](https://coveralls.io/github/devmarkusb/cpp-lib-template?branch=main)

C++ library template: **static** library with split header/`.cpp` by default, or **header-only** `INTERFACE` library
when `MB_CPP_LIB_TEMPLATE_HEADER_ONLY=ON` (no object code; implementation is `inline` in the public header). Includes
CMake presets, pinned FetchContent deps, GoogleTest, examples, install/`find_package`, and CI via the
[`devenv`](https://github.com/devmarkusb/devenv) submodule.

## Quick start

After clone:

```bash
git submodule update --init --recursive
```

Sync submodules (and Git LFS when used): `./devenv/scripts/git-sub.sh`

**Build** (CMake 3.30+, C++26 — **MSVC presets use C++23**, Ninja):

```bash
cmake --preset gcc-debug
cmake --build build/gcc-debug
ctest --preset gcc-debug
```

**Pre-commit** (configure once):

```bash
cmake --preset gcc-debug
cmake --build --preset gcc-debug --target mb-pre-commit-sweep
```

Hooks run on commit; `pre-commit run -a` works when `pre-commit` is on `PATH`.

## Starting a new library

**Recommended** — one-step rename (CMake, namespaces, paths, tests, examples, CI install-test header, README badges):

```bash
python3 /path/to/cpp-lib-template/scripts/new-cpp-lib.py \
  --dest ~/src/my-new-lib \
  --vendor mb \
  --lib my-new-lib \
  --github YOUR_USER_OR_ORG/my-new-lib \
  --fresh-git
```

| Flag | Effect |
| ------ | -------- |
| `--dest` | Empty output directory (created if needed) |
| `--vendor` / `--lib` | Project `vendor.lib` (two segments, for `mb_devenv_install_library`); `include/vendor/lib/`; namespace `vendor::lib_snake_case`; option prefix `VENDOR_LIB` |
| `--github OWNER/REPO` | Rewrites README badges only; doc links stay on this template |
| `--fresh-git` | `git init -b main`, add `devenv` submodule, initial commit |
| `--template /path/...` | Local checkout (default: clone from GitHub) |

Publish (`--fresh-git` creates the initial commit):

```bash
cd ~/src/my-new-lib
gh repo create my-new-lib --public --source=. --remote=origin --push
```

If `gh` reports *no commits found* (skipped `--fresh-git` or commit failed):

```bash
git add -A
git commit -m "Initial import from cpp-lib-template"
gh repo create my-new-lib --public --source=. --remote=origin --push
# or, if origin exists: git push -u origin main
```

Generate locally, then push — avoids GitHub “Use this template” submodule issues. Manual alternative: template button →
clone → `git submodule update --init --recursive` → rename per the checklist in `CMakeLists.txt`. Template PRs here;
`devenv` PRs upstream.

## CMake options

| Option                               | Default             | Description                                                                  |
|--------------------------------------|---------------------|------------------------------------------------------------------------------|
| `MB_CPP_LIB_TEMPLATE_HEADER_ONLY`    | `OFF`               | Header-only `INTERFACE` library vs static library with sources under `src/`. |
| `MB_CPP_LIB_TEMPLATE_BUILD_TESTS`    | `ON` when top-level | Build tests and test infra (GoogleTest).                                     |
| `MB_CPP_LIB_TEMPLATE_BUILD_EXAMPLES` | `ON` when top-level | Build example executables.                                                   |

## Build presets

`CMakePresets.json`: GCC, Clang, Clang+libc++, AppleClang, MSVC × Debug / RelWithDebInfo (e.g. `gcc-debug`,
`clang-release`, `msvc-debug`). C++ **26** for GCC/Clang/AppleClang; **23** for `msvc-*`. `compile_commands.json`
exported.

Pinned Git deps via root `fetchcontent-lockfile.json` and the lockfile dependency provider (format and options in
`devenv/README.md`, **fetch-content-from-lockfile.cmake**). Configuring **`devenv/`** as the top-level project uses
`devenv/fetchcontent-lockfile.json` instead — edit the root lockfile when working on this template.

Installed package version compatibility: `SameMajorVersion` (`mb_devenv_install_library` in `devenv`).

## Layout

| Path | Role |
| ------ | ------ |
| `.github/workflows/` | `ci.yml` — Linux/macOS/Windows preset CI, Nix+Conan matrix, sanitizers, coverage, install test; `pre-commit-check.yml` |
| `cmake/` | `dependencies.cmake` — `find_package` for build deps; mirror public deps in `mb.cpp-lib-template-config.cmake.in` with `find_dependency` (not test-only deps) |
| `conan/profiles/` | Conan profiles for Nix+Conan CI |
| `scripts/new-cpp-lib.py` | Template → new project ([above](#starting-a-new-library)) |
| `devenv/` | Submodule — toolchains, lockfile provider, reusable workflows: [devenv](https://github.com/devmarkusb/devenv) |
| `examples/` | Example executables (e.g. `usage.cpp` → `mb::cpp_lib_template::sum`) |
| `include/mb/cpp-lib-template/` | Public headers (FILE_SET) |
| `src/` | `.cpp` implementation (omitted when header-only); `*.test.cpp` when tests enabled |
| Root | `CMakeLists.txt`, `CMakePresets.json`, `conanfile.txt`, `fetchcontent-lockfile.json`, `.pre-commit-config.yaml` (whole tree, including `devenv/`) |
