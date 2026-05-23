{
  description = "ComfyUI as a Nix Flake";

  inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
     flake-utils.url = "github:numtide/flake-utils";
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
              pyopengl
              glfw
              simpleeval
            ]
          ));
      in rec {
       
        packages.comfyui_frontend = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfyui-frontend-package";
          version = "1.43.18";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_frontend_package";
            inherit version;
            sha256 = "sha256-z75TrKUuWPjJYwBEVZGgcC1UrEsFzqrGtc7+4FgXHlM=";
          };

          build-system = [ python.pkgs.setuptools ];

          patchPhase = ''
            sed -i 's/or "0.1.0"/or "${version}"/' setup.py
          '';
        };

       packages.comfyui_workflow_core = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-core";
          version = "0.3.233";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_core";
            inherit version;
            sha256 = "sha256-5XQb9tEU9Kl/F0gYz/WXRzk24zF2+C4OU0va4bowG8U=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_media_api = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-api";
          version = "0.3.76";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_api";
            inherit version;
            sha256 = "sha256-I2al1ZJ12jraeIVgRNifFavVDlDfEZyM8RNcOWAPQ30=";
          };

          build-system = [ python.pkgs.setuptools ];
       };
       
       packages.comfyui_workflow_media_video = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-video";
          version = "0.3.85";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_video";
            inherit version;
            sha256 = "sha256-E9umiQInnuzlu0W0XxZ+Ea5IfhLIRyF4XZg2fT+/ZSo=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_media_image = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-image";
          version = "0.3.139";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_image";
            inherit version;
            sha256 = "sha256-RTFjVGV/JyB8phHXD8r+Z27JCSKs5ybzZMHmWqO5Bjc=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_media_other = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-other";
          version = "0.3.199";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_other";
            inherit version;
            sha256 = "sha256-HjWfx69yqED5cQEsOTYMB+zOlMU1aJbyR7BozcgygRs=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

        packages.comfyui_workflow = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfyui-workflow-templates";
          version = "0.9.77";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates";
            inherit version;
            sha256 = "sha256-/1g0oRYi+fc+cW9hRUBk1j1oF+rwRYMMMcISuzu5x1g=";
          };

          build-system = [ python.pkgs.setuptools ];

          dependencies = [
            packages.comfyui_workflow_core
            packages.comfyui_workflow_media_api
            packages.comfyui_workflow_media_video
            packages.comfyui_workflow_media_image
            packages.comfyui_workflow_media_other
          ];

          # Create an empty templates directory to satisfy ComfyUI's expectation
          # The newer workflow templates package no longer ships templates in this location
          postInstall = ''
            mkdir -p $out/lib/python${python.pythonVersion}/site-packages/comfyui_workflow_templates/templates
            cp -r ${packages.comfyui_workflow_media_video}/lib/python${python.pythonVersion}/site-packages/comfyui_workflow_templates_media_video/templates $out/lib/python${python.pythonVersion}/site-packages/comfyui_workflow_templates/templates/video
            cp -r ${packages.comfyui_workflow_media_other}/lib/python${python.pythonVersion}/site-packages/comfyui_workflow_templates_media_other/templates $out/lib/python${python.pythonVersion}/site-packages/comfyui_workflow_templates/templates/other
            cp -r ${packages.comfyui_workflow_media_image}/lib/python${python.pythonVersion}/site-packages/comfyui_workflow_templates_media_image/templates $out/lib/python${python.pythonVersion}/site-packages/comfyui_workflow_templates/templates/image
          '';
        };

        packages.comfyui_embedded_docs = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfyui-embedded-docs";
          version = "0.5.0";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_embedded_docs";
            inherit version;
            sha256 = "sha256-kZjzRaDPqXfJ9702CaA1m66+WijwckujYqFZ5Nv9N2E=";
          };

          build-system = [python.pkgs.setuptools ];
        };

        packages.spandrel = pkgs.python3Packages.buildPythonPackage rec {
          pname = "spandrel";
          version = "0.4.2";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "spandrel";
            inherit version;
            sha256 = "sha256-/vpOqWbGpbdyHc8k8+IGKlqWo5XIvty1cPtVlx/cvMs=";
          };

          build-system = [
            python.pkgs.setuptools
            python.pkgs.torch
            python.pkgs.torchvision
            python.pkgs.safetensors
            python.pkgs.numpy
            python.pkgs.einops
            python.pkgs.typing-extensions
          ];
        };

        packages.comfy_kitchen = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfy-kitchen";
          version = "0.2.8";
          format = "wheel";

          src = pkgs.fetchPypi {
            pname = "comfy_kitchen";
            inherit version;
            format = "wheel";
            dist = "py3";
            python = "py3";
            sha256 = "sha256-CzIpks8Wgevj1BOseVDznlzEJVBcE8740IUnzoL+XjI=";
          };
        };

        packages.comfy_aimdo = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfy-aimdo";
          version = "0.4.3";
          format = "wheel";

          src = pkgs.fetchPypi {
            pname = "comfy_aimdo";
            inherit version;
            format = "wheel";
            dist = "py3";
            python = "py3";
            sha256 = "sha256-Kl56KOWdQCRnslodnDatuCVzZwKNjhSt54UDsr52PVo=";
          };
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
            ps.requests
            ps.pyopengl
            ps.glfw
            ps.simpleeval
            packages.comfyui_workflow_core
            packages.comfyui_workflow_media_api
            packages.comfyui_workflow_media_video
            packages.comfyui_workflow_media_image
            packages.comfyui_workflow_media_other
            packages.comfyui_frontend
            packages.comfyui_workflow
            packages.comfyui_embedded_docs
            packages.spandrel
            packages.comfy_kitchen
            packages.comfy_aimdo
          ]));
          in pkgs.stdenv.mkDerivation {
          pname = "ComfyUI";
          version = "0.21.1";

          src = pkgs.fetchFromGitHub {
            owner = "Comfy-Org";
            repo = "ComfyUI";
            tag = "v0.21.1";
            sha256 = "sha256-cRhIZ8TfCDUWKdMPYSz7xwDKpQnaoxl1mC/snRg8xKE=";
          };

          buildInputs = [
            python_extended
            pkgs.libGL
            pkgs.libGLU
            pkgs.mesa
            pkgs.glfw
          ];

          nativeBuildInputs = [
            pkgs.makeWrapper
          ];

          installPhase = ''
            mkdir -p $out/bin
            cp -r --no-preserve=mode,ownership $src/* $out
            chmod -R u+w $out

            makeWrapper ${python_extended}/bin/python $out/bin/ComfyUI \
              --add-flags "$out/main.py" \
              --set MALLOC system \
              --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [
                pkgs.libGL
                pkgs.libGLU
                pkgs.mesa
                pkgs.glfw
              ]}
          '';
        };
      }
    );
}
