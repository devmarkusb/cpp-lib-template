#!/usr/bin/env bash
set -euo pipefail

: "${CI_CONAN_VERSION:=2.28.1}"

venv_dir="${RUNNER_TEMP:-${TMPDIR:-/tmp}}/conan-${CI_CONAN_VERSION}-venv"
python3 -m venv "${venv_dir}"
"${venv_dir}/bin/python" -m pip install --upgrade pip
"${venv_dir}/bin/python" -m pip install "conan==${CI_CONAN_VERSION}"

if [[ -n "${GITHUB_PATH:-}" ]]; then
  echo "${venv_dir}/bin" >> "${GITHUB_PATH}"
else
  export PATH="${venv_dir}/bin:${PATH}"
fi

"${venv_dir}/bin/conan" --version
