{
  description = "Plantilla Latex para Tareas UdeC";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-24.05;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib; eachSystem allSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      tex = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-basic latexmk pgf mathtools thmtools
            setspace enumitem float titling titlesec eso-pic transparent
            etoolbox doclicense xifthen ifmtarg xstring xpatch fbox xkeyval
            ebgaramond fontspec subfiles newtx siunitx physics caption pgf-pie
            pgfplots csquotes biblatex ccicons babel-spanish hyphen-spanish
            txfonts biber circuitikz standalone lipsum placeins steinmetz
            pict2e pdfpages pdflscape xcolor listings wrapfig grffile minted
            fancyvrb upquote cancel;
      };
      python = pkgs.python3.withPackages(python-pkgs: [
        python-pkgs.pygments
        python-pkgs.catppuccin
      ]);
    in rec {
      packages = {
        document = pkgs.stdenvNoCC.mkDerivation rec {
          name = "latex-udec";
          src = self;
          buildInputs = [ pkgs.coreutils pkgs.ghostscript pkgs.ncurses pkgs.which python tex ];
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
            cp main.pdf $out/${name}.pdf
            cp compressed_main.pdf $out/${name}_compressed.pdf
          '';
        };
      };
      defaultPackage = packages.document;
    });
}
