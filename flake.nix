{
  description = "Plantilla Latex para Tareas UdeC";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-24.05;
    utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          (self: super: rec {
            python = (super.python3.withPackages (python-pkgs: with python-pkgs; [
              pygments catppuccin
            ]));
            tex = (super.texlive.withPackages (ps: with ps; [
              texdoc # recommended package to navigate the documentation
              scheme-medium # most packages you will need

              # paquetes necesarios para la plantilla
              biber biblatex ccicons csquotes doclicense ebgaramond enumitem 
              fbox float ifmtarg newtx pict2e subfiles thmtools titlesec
              titling transparent xifthen xstring 

              # paquetes necesarios para minted
              minted upquote

              # paquetes para generar gráficos
              pgfplots

              # otros paquetes útiles
              placeins
            ]));
          })
        ];
        pkgs = import nixpkgs { inherit system overlays; };
      in rec {
        packages = {
          document = pkgs.stdenvNoCC.mkDerivation rec {
            name = "latex-udec";
            src = self;
            buildInputs = with pkgs; [ coreutils ghostscript ncurses which python tex ];
            phases = ["unpackPhase" "buildPhase" "installPhase"];
            buildPhase = ''
              export PATH="$PATH:${pkgs.lib.makeBinPath buildInputs}";
              mkdir -p .cache/texmf-var
              env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
                latexmk -interaction=nonstopmode -pdf -lualatex -bibtex -shell-escape \
                  main.tex
              gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress \
                -dNOPAUSE -dQUIET -dBATCH -sOutputFile=compressed_main.pdf main.pdf
            '';
            installPhase = ''
              mkdir -p $out
              cp main.pdf $out/doc.pdf
              cp compressed_main.pdf $out/doc_compressed.pdf
            '';
          };
        };
        packages.default = packages.document;
      }
    );
}
