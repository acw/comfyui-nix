{
  description = "ComfyUI as a Nix Flake";

  inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
     flake-utils.url = "github:numtide/flake-utils";
     comfyuigit = {
       flake = false;
       url = "github:comfyanonymous/ComfyUi/v0.3.64";
     };
  };

  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; config.rocmSupport = true; };
          python = (pkgs.python3.withPackages (
            ps: with ps; [
              alembic
              torch
              torchsde
              torchvision
              torchaudio
              numpy
              einops
              transformers
              tokenizers
              sentencepiece
              safetensors
              aiohttp
              yarl
              pyyaml
              pydantic
              pydantic-settings
              pillow
              scipy
              tqdm
              psutil
              av
              sqlalchemy
              soundfile
              kornia
            ]
          ));
      in rec {
       
        packages.comfyui_frontend = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfyui-frontend-package";
          version = "1.27.10";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_frontend_package";
            inherit version;
            sha256 = "sha256-KUfKv82V+kmHlNfu/Z0cTMTefDIOIqopFrJfvLm4DH4=";
          };

          buildInputs = [
            python
            python.pkgs.pip
          ];
        };

        packages.comfyui_workflow = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfyui-workflow-templates";
          version = "0.1.94";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates";
            inherit version;
            sha256 = "sha256-xkOm/IFRV9wsxjthlFT4aGVYki/rudDFRxCFNrobQXI=";
          };

          buildInputs = [
            python
            python.pkgs.pip
          ];
        };

        packages.comfyui_embedded_docs = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfyui-embedded-docs";
          version = "0.2.6";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_embedded_docs";
            inherit version;
            sha256 = "sha256-ild/PuIWvo3NbAjpZYxvJX/7np6B9A8NNt6bSZJJdWo=";
          };

          buildInputs = [
            python
            python.pkgs.pip
          ];
        };

        packages.spandrel = pkgs.python3Packages.buildPythonPackage rec {
          pname = "spandrel";
          version = "0.4.1";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "spandrel";
            inherit version;
            sha256 = "sha256-ZG2YFqlC5Z1WqrLckENTlS5X3uSyyz9Z9+pNwPsRofI=";
          };

          buildInputs = [
            python
            python.pkgs.pip
          ];
        };

        packages.comfyui =
          let python_extended = (python.withPackages (ps: [
            ps.alembic
            ps.torchWithRocm
            ps.torchsde
            ps.torchvision
            ps.torchaudio
            ps.numpy
            ps.einops
            ps.transformers
            ps.tokenizers
            ps.sentencepiece
            ps.safetensors
            ps.pydantic
            ps.pydantic-settings
            ps.aiohttp
            ps.yarl
            ps.pyyaml
            ps.pillow
            ps.scipy
            ps.tqdm
            ps.psutil
            ps.av
            ps.sqlalchemy
            ps.soundfile
            ps.kornia
            packages.comfyui_frontend
            packages.comfyui_workflow
            packages.comfyui_embedded_docs
            packages.spandrel
          ]));
          in pkgs.stdenv.mkDerivation {
          pname = "ComfyUI";
          version = "0.3.64";
          pyproject = true;

          src = pkgs.fetchFromGitHub {
            owner = "comfyanonymous";
            repo = "ComfyUI";
            tag = "v0.3.64";
            sha256 = "sha256-vIw22ISbjUnfRB6+TFE7QKbVnEXu6BFAN8lmCGE74/M=";
          };

          buildInputs = [
            python_extended
            python.pkgs.pip
            packages.comfyui_frontend
          ];

          installPhase = ''
            mkdir -p $out/bin
            cp -r --no-preserve=mode,ownership $src/* $out
            chmod -R u+w $out

            echo "#!/bin/sh" > $out/bin/ComfyUI
            echo "export MALLOC=system" >> $out/bin/ComfyUI
            echo "exec ${python_extended}/bin/python $out/main.py \"\$@\"" >> $out/bin/ComfyUI
            chmod +x $out/bin/ComfyUI
          '';
        };
      }
    );
}
