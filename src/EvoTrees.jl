module EvoTrees

export init_evotree, grow_evotree!, grow_tree, fit_evotree, predict,
    EvoTreeRegressor, EvoTreeCount, EvoTreeClassifier, EvoTreeGaussian,
    EvoTreeRModels, importance

using Statistics
using Base.Threads: @threads
using StatsBase: sample, quantile
using Random: seed!
using StaticArrays
using Distributions
using CategoricalArrays
import MLJModelInterface
import MLJModelInterface: fit, update
import MLJModelInterface: predict

include("models.jl")
include("structs.jl")
include("loss.jl")
include("eval.jl")
include("predict.jl")
include("find_split.jl")
include("fit.jl")
include("importance.jl")
include("MLJ.jl")

end # module
