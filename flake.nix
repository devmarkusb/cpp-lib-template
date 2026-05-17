{
  description = "Project-local dev env kit config";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          gcc15 = pkgs.mkShell {
            packages = with pkgs; [ cmake ninja pkg-config conan gcc15 ];
          };

          clang21 = pkgs.mkShell {
            packages = with pkgs; [
              cmake
              ninja
              pkg-config
              conan
              clang_21
              llvmPackages_21.compiler-rt-libc
            ];
          };

          clang21-libcxx = pkgs.mkShell {
            packages = with pkgs; [
              cmake
              ninja
              pkg-config
              conan
              clang_21
              llvmPackages_21.libcxx
              llvmPackages_21.compiler-rt-libc
            ];
          };

          appleclang = pkgs.mkShell {
            packages = with pkgs; [ cmake ninja pkg-config conan ];
            shellHook = ''
              export CC="/usr/bin/cc"
              export CXX="/usr/bin/c++"
            '';
          };

          default = pkgs.mkShell {
            packages = with pkgs; [ cmake ninja pkg-config conan gcc15 ];
          };
        });
    };
}
