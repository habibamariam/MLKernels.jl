#===================================================================================================
  Kernel Kernels Module
===================================================================================================#

module MLKernels

import Base: call, convert, eltype, print, show, string, ==, *, /, +, -, ^, besselk, exp, gamma, 
             tanh

export

    # Hyper Parameters
    Bound,
    Interval,
    leftbounded,
    rightbounded,
    unbounded,
    checkbounds,
    Variable,
    fixed,
    Argument,
    HyperParameter,

    # Memory
    MemoryLayout,
    RowMajor,
    ColumnMajor,

    # Kernel Function Type
    Kernel,
        MercerKernel, 
            ExponentialKernel,
                LaplacianKernel,
            SquaredExponentialKernel,
                GaussianKernel,
                RadialBasisKernel,
            GammaExponentialKernel,
            RationalQuadraticKernel,
            GammaRationalKernel,
            MaternKernel,
            LinearKernel,
            PolynomialKernel,
            ExponentiatedKernel,
            PeriodicKernel,
        NegativeDefiniteKernel,
            PowerKernel,
            LogKernel,
        SigmoidKernel,

    # Kernel Functions
    ismercer,

    # Kernel Matrix
    kernel,
    kernelmatrix,
    kernelmatrix!,

    # Kernel Approximation
    NystromFact,
    nystrom

include("HyperParameters/HyperParameters.jl")
using MLKernels.HyperParameters: 
    Bound,
    Interval,
    leftbounded,
    rightbounded,
    unbounded,
    checkbounds,
    HyperParameter


# Row major and column major ordering are supported
abstract MemoryLayout

immutable ColumnMajor <: MemoryLayout end
immutable RowMajor    <: MemoryLayout end


include("common.jl")
include("pairwise.jl")
include("pairwisematrix.jl")
include("kernel.jl")
include("kernelmatrix.jl")
include("kernelmatrixapproximation.jl")
    
end # MLKernels
