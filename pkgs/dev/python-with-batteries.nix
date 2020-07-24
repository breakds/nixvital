{ lib, python3,
  enableMachineLearning ? false,
  enableJupyterhub ? false }:

python3.withPackages (
  pythonPackages: with pythonPackages;
    let the-torchvision = torchvision.override {
          pytorch = pytorchWithCuda;
        };

        computation = [
          numpy pandas
        ];

        ide = [
          jupyterhub
        ];

        viz = [
          matplotlib plotly dash tqdm
        ];

        image = [
          opencv4 imageio
        ];
    in computation ++ ide ++ viz ++ image
       ++ (lib.optionals enableMachineLearning [ lightgbm pytorchWithCuda the-torchvision ])
        # FIXME: Currently jupyterhub does not yet work with jupyter
        # lab. Will make this working later.
       ++ (lib.optionals enableJupyterhub [ jupyterhub ]))
