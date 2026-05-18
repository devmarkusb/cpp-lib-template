#!/usr/bin/env bash
set -euo pipefail

bash_env="${RUNNER_TEMP:-/tmp}/nix-clang-libcxx-env.sh"

cat > "${bash_env}" <<'EOF'
if command -v nix >/dev/null 2>&1; then
  libcxx_path="$(nix build --no-link --print-out-paths nixpkgs#llvmPackages_21.libcxx)"
  export CC="clang"
  export CXX="clang++"
  export CXXFLAGS="${CXXFLAGS:+${CXXFLAGS} }-stdlib=libc++"
  export LDFLAGS="-L${libcxx_path}/lib ${LDFLAGS:+${LDFLAGS} }-stdlib=libc++ -lc++abi"
fi
EOF

{
  echo "BASH_ENV=${bash_env}"
  echo "CC=clang"
  echo "CXX=clang++"
  echo "CXXFLAGS=-stdlib=libc++"
  echo "LDFLAGS=-stdlib=libc++ -lc++abi"
} >> "${GITHUB_ENV}"
