# setup paths -
const _ROOT = @__DIR__;
const _PATH_TO_SRC = joinpath(_ROOT, "src");

# if we are missing any packages, install them -
using Pkg;
if (isfile(joinpath(_ROOT, "Manifest.toml")) == false) # have manifest file, we are good. Otherwise, we need to instantiate the environment
    Pkg.add(path="https://github.com/varnerlab/VLDataScienceMachineLearningPackage.jl.git")
    Pkg.activate("."); Pkg.resolve(); Pkg.instantiate(); Pkg.update();
end

# load external package -
using VLDataScienceMachineLearningPackage
using Test
using JLD2
using FileIO
using DataFrames
using CSV
using Distributions
using Statistics
using UnicodePlots
using BenchmarkTools
using DataStructures
using Plots
using Colors
using ProgressMeter
using IJulia
using DataStructures

# load my codes -
include(joinpath(_PATH_TO_SRC, "Factory.jl"))