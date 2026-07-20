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
          version = "1.47.9";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_frontend_package";
            inherit version;
            sha256 = "sha256-WutDaSumL+yFNByd+5PGR58HfPY8+s0rZdtN8PLDg+0=";
          };

          build-system = [ python.pkgs.setuptools ];

          patchPhase = ''
            sed -i 's/or "0.1.0"/or "${version}"/' setup.py
          '';
        };

       packages.comfyui_workflow_core = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-core";
          version = "0.3.275";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_core";
            inherit version;
            sha256 = "sha256-+RgejrDjZpxCAZ9cptEgtgB8Q6BF9m/xP6SXu4HlDRY=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_media_api = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-api";
          version = "0.3.84";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_api";
            inherit version;
            sha256 = "sha256-a9XEluNo5eQN2H3+JfBm4k1X82AoiLo9+AATqI0GAlk=";
          };

          build-system = [ python.pkgs.setuptools ];
       };
       
       packages.comfyui_workflow_media_video = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-video";
          version = "0.3.101";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_video";
            inherit version;
            sha256 = "sha256-dlLtmfubsAs52JBZGdyBUJIB4zXd4jqXNroTiRmQhHY=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_media_image = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-image";
          version = "0.3.160";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_image";
            inherit version;
            sha256 = "sha256-iNz3STAsahL1uAPftGcktMiswx0RF87P9RZy2b2F6xg=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_media_other = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-other";
          version = "0.3.229";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_other";
            inherit version;
            sha256 = "sha256-bi2wdS8sfOlPaoudRBpfnceLv6dldF8PnqyuzLzmk4U=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_json = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-json";
          version = "0.1.9";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_json";
            inherit version;
            sha256 = "sha256-+q2lCMPCwA8qOt/WEe+eNPcXdkjaUNsxShWxFjq/vYQ=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_media_assets = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-assets-01";
          version = "0.1.5";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_assets_01";
            inherit version;
            sha256 = "sha256-qyoluHfudoKW1c0JNvM1FrINXZCn+9tvRz/DK77lNcE=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

        packages.comfyui_workflow = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfyui-workflow-templates";
          version = "0.11.12";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates";
            inherit version;
            sha256 = "sha256-tJ6wm4ixxCywLO9B3iDjQKox1nGwO0ptvzCP4bZ69TY=";
          };

          build-system = [ python.pkgs.setuptools ];

          dependencies = [
            packages.comfyui_workflow_core
            packages.comfyui_workflow_json
            packages.comfyui_workflow_media_api
            packages.comfyui_workflow_media_video
            packages.comfyui_workflow_media_image
            packages.comfyui_workflow_media_other
            packages.comfyui_workflow_media_assets
          ];

          # ComfyUI >= 0.28.0 (templates >= 0.3.0) resolves template assets by
          # importing each bundle package directly (see comfyui_workflow_templates_core's
          # loader manifest), so the legacy static /templates directory is no longer used.
        };

        packages.comfyui_embedded_docs = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfyui-embedded-docs";
          version = "0.5.8";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_embedded_docs";
            inherit version;
            sha256 = "sha256-w6fGpXHcTkx7Ur5qAw3kts2ZaNxqneLqKmd2/A5BjwU=";
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
          version = "0.2.22";
          format = "wheel";

          src = pkgs.fetchPypi {
            pname = "comfy_kitchen";
            inherit version;
            format = "wheel";
            dist = "py3";
            python = "py3";
            sha256 = "sha256-0E8UduYJoa6zr4tf5iEr61dBunHgJjyF0cmQ9rP8er8=";
          };
        };

        packages.comfy_aimdo = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfy-aimdo";
          version = "0.4.10";
          format = "wheel";

          src = pkgs.fetchPypi {
            pname = "comfy_aimdo";
            inherit version;
            format = "wheel";
            dist = "py3";
            python = "py3";
            sha256 = "sha256-oG3rgljMbDPvhHO0v7bFu+EWdviAGbqoQdtiNf88m5A=";
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
            packages.comfyui_workflow_json
            packages.comfyui_workflow_media_api
            packages.comfyui_workflow_media_video
            packages.comfyui_workflow_media_image
            packages.comfyui_workflow_media_other
            packages.comfyui_workflow_media_assets
            packages.comfyui_frontend
            packages.comfyui_workflow
            packages.comfyui_embedded_docs
            packages.spandrel
            packages.comfy_kitchen
            packages.comfy_aimdo
          ]));
          in pkgs.stdenv.mkDerivation {
          pname = "ComfyUI";
          version = "0.28.0";

          src = pkgs.fetchFromGitHub {
            owner = "Comfy-Org";
            repo = "ComfyUI";
            tag = "v0.28.0";
            sha256 = "sha256-p75qcm6eRMWaVD89xac2biu58hN2FcxW1QgNujlGxAA=";
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
