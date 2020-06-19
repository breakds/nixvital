{ lib, python3,
  enableMachineLearning ? false,
  enableJupyterhub ? false }:

python3.withPackages (
  pythonPackages: with pythonPackages;
    let the-torchvision = torchvision.override {
          pytorch = pytorchWithCuda;
        };
    in [ numpy pandas matplotlib jupyterlab plotly dash tqdm ]
       ++ (lib.optionals enableMachineLearning [ lightgbm pytorchWithCuda the-torchvision ])
        # FIXME: Currently jupyterhub does not yet work with jupyter
        # lab. Will make this working later.
       ++ (lib.optionals enableJupyterhub [ jupyterhub ]))
