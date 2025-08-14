# Setup
Install Intel's MKL and copy the following lib files into the root directory of this project:
- mkl_core.lib
- mkl_intel_ilp64.lib
- mkl_intel_lp64.lib
- mkl_sequential.lib

Run the following commands in the root directory:
- `dub run raylib-d:install`

With the use of Developer Command Prompt for Visual Studio 2019, change directory to the root of this project. After changing directory run the command `dub run`.
