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
          version = "1.45.15";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_frontend_package";
            inherit version;
            sha256 = "sha256-Me7c0kgW+uVECyyWcgX5u9yJRxstk14F37yB3QrSdWQ=";
          };

          build-system = [ python.pkgs.setuptools ];

          patchPhase = ''
            sed -i 's/or "0.1.0"/or "${version}"/' setup.py
          '';
        };

       packages.comfyui_workflow_core = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-core";
          version = "0.3.252";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_core";
            inherit version;
            sha256 = "sha256-+0qfArlhI7fInoMMAxykkPWQEk44/t8Jep7k0NTf3hY=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_media_api = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-api";
          version = "0.3.80";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_api";
            inherit version;
            sha256 = "sha256-8ky96qyePUC/WHqmADciOOvMHoj70D50iCiIigzplvo=";
          };

          build-system = [ python.pkgs.setuptools ];
       };
       
       packages.comfyui_workflow_media_video = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-video";
          version = "0.3.91";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_video";
            inherit version;
            sha256 = "sha256-sv5boLqFrRxp33kN7xpFC6/YLTNaaPJYy9xn/H0Y9eo=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_media_image = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-image";
          version = "0.3.150";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_image";
            inherit version;
            sha256 = "sha256-ysh+E245FKY65e3H1HtrlRqOyH5d1h2GGhH+SrJ3Gcc=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_media_other = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-other";
          version = "0.3.217";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_other";
            inherit version;
            sha256 = "sha256-Z1t3WHFcBFvd753v3du6nH79dxFFUSYdJv30nwQzxpc=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

        packages.comfyui_workflow = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfyui-workflow-templates";
          version = "0.9.98";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates";
            inherit version;
            sha256 = "sha256-uCb0E0V3CVdmDwKSEMmYZsGNkmsP1cB9Cupb7uwxvQI=";
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
          version = "0.5.3";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_embedded_docs";
            inherit version;
            sha256 = "sha256-Sf7LVwOL2+Pfs8D3e0tpW1+xMes24IjKPquQ2eGD/b8=";
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
          version = "0.2.10";
          format = "wheel";

          src = pkgs.fetchPypi {
            pname = "comfy_kitchen";
            inherit version;
            format = "wheel";
            dist = "py3";
            python = "py3";
            sha256 = "sha256-wkKv0Y0SDij8lJxCP6KMuyLLTXDWJ9jMfN9rrVTdJyw=";
          };
        };

        packages.comfy_aimdo = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfy-aimdo";
          version = "0.4.9";
          format = "wheel";

          src = pkgs.fetchPypi {
            pname = "comfy_aimdo";
            inherit version;
            format = "wheel";
            dist = "py3";
            python = "py3";
            sha256 = "sha256-qCF8CXnW5AJU/civJnCxjZxOmfPFRp7wmv8UbDaD7y8=";
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
          version = "0.24.0";

          src = pkgs.fetchFromGitHub {
            owner = "Comfy-Org";
            repo = "ComfyUI";
            tag = "v0.24.0";
            sha256 = "sha256-43yi0Pgx+UKQDNnXQSw3TtCc2pA8arfFrI2hFN6MlZg=";
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
