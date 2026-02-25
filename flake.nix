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
            ]
          ));
      in rec {
       
        packages.comfyui_frontend = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfyui-frontend-package";
          version = "1.39.14";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_frontend_package";
            inherit version;
            sha256 = "sha256-4hQfTUhZR7zBg5WBJDy9oNfxlh7iTyhnQldxJGPsnAo=";
          };

          build-system = [ python.pkgs.setuptools ];

          patchPhase = ''
            sed -i 's/or "0.1.0"/or "${version}"/' setup.py
          '';
        };

       packages.comfyui_workflow_core = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-core";
          version = "0.3.145";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_core";
            inherit version;
            sha256 = "sha256-a8FzBQpCv3SiSyRooHVWOlx1TFPzLFx1/rd3hJbIMWM=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_media_api = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-api";
          version = "0.3.53";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_api";
            inherit version;
            sha256 = "sha256-LPEghCWfma46eHyHB+CJhUc/KnOQv66pJSoXlgCPzxE=";
          };

          build-system = [ python.pkgs.setuptools ];
       };
       
       packages.comfyui_workflow_media_video = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-video";
          version = "0.3.49";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_video";
            inherit version;
            sha256 = "sha256-n8WcG6bbm3K9Ht16DUxvQM59+1zDNa9ghWy+8gYjB5U=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_media_image = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-image";
          version = "0.3.90";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_image";
            inherit version;
            sha256 = "sha256-I86F1hJy2BMNXOhHJa/kjfIiHsf6Bp2qcmwBSdqiybI=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

       packages.comfyui_workflow_media_other = pkgs.python3Packages.buildPythonPackage rec {
         pname = "comfyui-workflow-templates-media-other";
          version = "0.3.121";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates_media_other";
            inherit version;
            sha256 = "sha256-5EFSytx6LGjGHNwZ/0zrHQYUVPnYTgAa2a8R5kXTFTs=";
          };

          build-system = [ python.pkgs.setuptools ];
       };

        packages.comfyui_workflow = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfyui-workflow-templates";
          version = "0.8.43";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_workflow_templates";
            inherit version;
            sha256 = "sha256-XFwoSLDSp6h8/UKEg3J++PR8gVfZ1fEmrz0MBoEK60A=";
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
          version = "0.4.1";
          pyproject = true;

          src = pkgs.fetchPypi {
            pname = "comfyui_embedded_docs";
            inherit version;
            sha256 = "sha256-Xq1Smz36mnxrptXW5C1rEX9ZH9RGn85XoebyzGtKvxA=";
          };

          build-system = [python.pkgs.setuptools ];
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
          version = "0.2.7";
          format = "wheel";

          src = pkgs.fetchPypi {
            pname = "comfy_kitchen";
            inherit version;
            format = "wheel";
            dist = "py3";
            python = "py3";
            sha256 = "sha256-+PqlebadMx0vHqwJ6WqVWGwqa5WKVLwZ5/HBp3hS3TY=";
          };
        };

        packages.comfy_aimdo = pkgs.python3Packages.buildPythonPackage rec {
          pname = "comfy-aimdo";
          version = "0.1.8";
          format = "wheel";

          src = pkgs.fetchPypi {
            pname = "comfy_aimdo";
            inherit version;
            format = "wheel";
            dist = "py3";
            python = "py3";
            sha256 = "sha256-BVs3sDetESkbqH2knvJ4weuw4ix0IRH6+a4xWzru3Zk=";
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
          version = "0.14.2.1";

          src = pkgs.fetchFromGitHub {
            owner = "Comfy-Org";
            repo = "ComfyUI";
            tag = "v0.14.2";
            sha256 = "sha256-rrkVEnoWp0BBFZS4fMHo72aYZSxy0I3O8C9DMKXsr88=";
          };

          buildInputs = [
            python_extended
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
