# cpp-lib-template

<!-- markdownlint-disable-next-line line-length -->
![Continuous Integration Tests](https://github.com/devmarkusb/cpp-lib-template/actions/workflows/ci.yml/badge.svg) ![Lint Check (pre-commit)](https://github.com/devmarkusb/cpp-lib-template/actions/workflows/pre-commit-check.yml/badge.svg) [![Coverage](https://coveralls.io/repos/github/devmarkusb/cpp-lib-template/badge.svg?branch=main)](https://coveralls.io/github/devmarkusb/cpp-lib-template?branch=main)

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

**Build** (CMake 3.30+, C++26 by default — **MSVC presets use C++23**, Ninja). From repo root:

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

**Recommended: generate a new tree with the script** (CMake names, namespaces, paths, tests, examples, CI install-test
header, README badges — all handled in one step):

```bash
python3 /path/to/cpp-lib-template/scripts/new-cpp-lib.py \
  --dest ~/src/my-new-lib \
  --vendor mb \
  --lib my-new-lib \
  --github YOUR_USER_OR_ORG/my-new-lib \
  --fresh-git
```

- **`--dest`** — Empty directory for the new project (created for you).
- **`--vendor`** / **`--lib`** —
  Produces the CMake project `vendor.lib` (exactly two dot-separated segments, as required by
  `mb_devenv_install_library`), include layout `include/vendor/lib/`, C++ namespace `vendor::lib_snake_case`,
  and option prefix `VENDOR_LIB` (derived).
- **`--github OWNER/REPO`** — Rewrites the badge line in `README.md` only; upstream doc links stay on this template.
  Omit it and edit badges by hand, or add Coveralls for the new repo later.
- **`--fresh-git`** — Drops the template’s `.git`, runs `git init -b main`, and adds
  [`devenv`](https://github.com/devmarkusb/devenv) as a submodule (same as a manual setup, but scripted).
- **`--template /path/to/cpp-lib-template`** — Use a local checkout instead of cloning from GitHub (omit to clone
  `https://github.com/devmarkusb/cpp-lib-template.git`).

Then publish the folder (`--fresh-git` already creates an **initial commit** so `--push` works):

```bash
cd ~/src/my-new-lib
gh repo create my-new-lib --public --source=. --remote=origin --push
```

If `gh` reports *no commits found*, you never committed (for example you skipped `--fresh-git` or the commit step
failed). Fix it, then push:

```bash
git add -A
git commit -m "Initial import from cpp-lib-template"
gh repo create my-new-lib --public --source=. --remote=origin --push
# or, if origin already exists: git push -u origin main
```

**Why this order?** Generate **locally first**, then **push** to a new empty remote. You avoid fighting template history
or submodule state on GitHub’s “template” button (that flow often leaves `devenv` wrong until you re-init submodules).

**Manual / GitHub Template button:** You can still use **“Use this template”** on GitHub, clone the result, run
`git submodule update --init --recursive`, then rename everything using the top comment in `CMakeLists.txt` (option
prefix `MB_CPP_LIB_TEMPLATE`, names `cpp-lib-template`, `mb` / `mb::` / `mb/`, files and dirs). The script exists so you
do not have to do that by hand.

When you improve the template itself, open a PR here; when you improve `devenv`, contribute there.

## CMake options

| Option                               | Default             | Description                                                                  |
|--------------------------------------|---------------------|------------------------------------------------------------------------------|
| `MB_CPP_LIB_TEMPLATE_HEADER_ONLY`    | `OFF`               | Header-only `INTERFACE` library vs static library with sources under `src/`. |
| `MB_CPP_LIB_TEMPLATE_BUILD_TESTS`    | `ON` when top-level | Build tests and test infra (GoogleTest).                                     |
| `MB_CPP_LIB_TEMPLATE_BUILD_EXAMPLES` | `ON` when top-level | Build example executables.                                                   |

## Build presets

`CMakePresets.json` defines configure/build/test presets for:

- **Compilers:** GCC, Clang, Clang with libc++, AppleClang, MSVC.
- **Configurations:** Debug, RelWithDebInfo (release).
- **Preset names:** e.g. `gcc-debug`, `clang-release`, `msvc-debug`, `appleclang-release`.

C++ standard is **26** for GCC/Clang/AppleClang presets and **23** for `msvc-*` presets (matches the MSVC columns in
CI). Compile commands are exported for tooling. A dependency provider uses the **repo-root**
`fetchcontent-lockfile.json` for pinned Git dependencies (`find_package` entries, optional `cmake_include` / per-dep
`cmake_variables`; see `devenv/README.md` under **fetch-content-from-lockfile.cmake**). If you configure **`devenv/` as
the top-level CMake project** (using `devenv/CMakePresets.json`), that tree uses `devenv/fetchcontent-lockfile.json`
instead — a minimal lockfile for devenv-only dev — so edit the root lockfile when working on the library template.

Note: `SameMajorVersion` is used for the installed CMake package version file (see `mb_devenv_install_library` in
`devenv`), so consumers can typically `find_package` with a compatible major version.

## Directory structure

### `.github/`

- **`workflows/ci.yml`** — CI: preset-based build/test on Linux (GCC/Clang), macOS (AppleClang), Windows (MSVC);
  extended build-and-test matrix (GCC 15, Clang 18/21, sanitizers, coverage); install test.
- **`workflows/pre-commit-check.yml`** — Runs pre-commit on push to `main` and on pull requests.
- **`workflows/pre-commit-update.yml`** — Weekly (and manual) pre-commit hook autoupdate.

### `cmake/`

- **`mb.cpp-lib-template-config.cmake.in`** — Template for the CMake config-file package (used when installing the
  library so consumers can `find_package(mb.cpp-lib-template)`).

### `scripts/`

- **`new-cpp-lib.py`** — Instantiates a new library from this template (rename CMake/C++/paths, optional `README` badges
  and fresh `git` + `devenv` submodule). See [Usage when starting a new library](#usage-when-starting-a-new-library).

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
- **`fetchcontent-lockfile.json`** — Pinned Git dependencies for the CMake dependency provider (e.g. Googletest); optional
  fields include `cmake_variables` per dependency. Format is documented in `devenv/README.md`. See **Build presets**
  above for the separate minimal lockfile under `devenv/` when building devenv alone.
- **`.pre-commit-config.yaml`** — Pre-commit hooks: trailing whitespace, EOF, JSON/YAML checks, clang-format,
  gersemi (CMake), markdownlint, codespell (runs on the whole tree, including `devenv/` when checked out as a
  submodule — cheap and catches drift if you touch it).
