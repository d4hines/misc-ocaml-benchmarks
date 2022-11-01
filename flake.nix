{
  inputs = {
    nixpkgs.url = "github:nix-ocaml/nix-overlays";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
  };
  outputs = { self, nixpkgs, flake-utils, nix-filter }: flake-utils.lib.eachDefaultSystem (system:
    let pkgs = import nixpkgs { inherit system; }; in
    with pkgs;
    with ocamlPackages;
    {
      packages = {
        benchmarks = buildDunePackage {
          pname = "benchmarks";
          version = "0.1";
          src = ./.;
          propagatedBuildInputs = [ core core_unix core_bench ];
        };
      };
      defaultPackage = self.packages."${system}".benchmarks;
      devShell = mkShell
        {
          inputsFrom = [
            self.packages."${system}".benchmarks
          ];
          packages = [
            ocaml
            dune_3
            ocaml-lsp
            ocamlformat
            ocamlformat-rpc
            utop
          ];
        };
    }
  );
}
