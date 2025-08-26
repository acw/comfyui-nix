{
  description = "ComfyUI as a Nix Flake";

  inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
     flake-utils.url = "github:numtide/flake-utils";
     comfyuigit = {
       flake = false;
       url = "github:comfyanonymous/ComfyUi/v0.3.50";
     };
  };

  outputs = { comfyuigit, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
          inherit system;
        };
        pyenv = pkgs.python312.buildEnv.override {
          extraLibs = with pkgs.python312Packages; [
            torchvision
            torchaudio
            torchsde

            einops
            transformers
            safetensors
            pyyaml
            pillow
            scipy
            tqdm
            psutil
            kornia
            numba
            opencv4
            GitPython
            numexpr
            matplotlib
            pandas
            imageio-ffmpeg
            scikit-image
            pip
            accelerate
          ];
        };
      in rec {
        packages = rec {
          comfyui = pkgs.stdenv.mkDerivation {
            name = "comfyui";
            src = comfyuigit;
            installPhase = ''
              mkdir -p $out/bin
              cp -r $src/* $out

              echo "${pyenv}/bin/python main.py" > $out/bin/comfyui
              chmod +x $out/bin/comfyui
            '';
          };

          default = comfyui;
        };

        devShell = pkgs.mkShell {
          buildInputs = [packages.comfyuimain pyenv];
        };
      }
  );
}
