using Base.Test
importall MLKernels

function matrix_test_approx_eq(A::Array, B::Array)
    length(A) == length(B) || error("dimensions do not conform")
    for i = 1:length(A)
        @test_approx_eq A[i] B[i]
    end
end

print("- Testing syml ... ")
matrix_test_approx_eq(MLKernels.syml([1.0 1 ; 0 1]), [1.0 1; 1 1])
matrix_test_approx_eq(MLKernels.symu([1.0 0 ; 1 1]), [1.0 1; 1 1])
println("Done")

print("- Testing dot_rows ... ")
matrix_test_approx_eq(MLKernels.dot_rows([1.0 1 ; 0 1]), [2.0; 1])
println("Done")

print("- Testing dot_columns ... ")
matrix_test_approx_eq(MLKernels.dot_columns([1.0 1 ; 0 1]), [1.0 2])
println("Done")

print("- Testing hadamard! ... ")
matrix_test_approx_eq(MLKernels.hadamard!([1.0; 1], [3.0; 2]), [3.0; 2])
println("Done")

X = reshape([1.0; 2], 2, 1)
Y = reshape([1.0; 1], 2, 1)

print("- Testing gramian_matrix ... ")
matrix_test_approx_eq(gramian_matrix(X), [1.0 2; 2 4])
matrix_test_approx_eq(gramian_matrix(X, Y), [1.0 1; 2 2])
matrix_test_approx_eq(lagged_gramian_matrix(X), [0.0 1; 1 0.0])
matrix_test_approx_eq(lagged_gramian_matrix(X, Y), [0.0 0; 1 1])
println("Done")

print("- Testing center_kernel_matrix ... ")
X = [0.0 0; 2 2]
Z = X .- mean(X,1)
matrix_test_approx_eq(center_kernel_matrix(X*X'), Z*Z')
println("Done")

immutable TestKernel{T<:FloatingPoint} <: StandardKernel{T}
    a::T
end
kernel_function{T<:FloatingPoint}(::TestKernel{T}, x::Array{T}, y::Array{T}) = sum(x)*sum(y)


X = [0.0 0; 1 1]

print("- Testing generic kernel_matrix ... ")
matrix_test_approx_eq(kernel_matrix(TestKernel(1.0), X), [0.0 0; 0 4])
matrix_test_approx_eq(kernel_matrix(TestKernel(1.0), X, X), [0.0 0; 0 4])
println("Done")

print("- Testing generic kernel_matrix_scaled ... ")
matrix_test_approx_eq(MLKernels.kernel_matrix_scaled(2.0, TestKernel(1.0), X), [0.0 0; 0 8])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * TestKernel(1.0), X), [0.0 0; 0 8])
matrix_test_approx_eq(MLKernels.kernel_matrix_scaled(2.0, TestKernel(1.0), X, X), [0.0 0; 0 8])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * TestKernel(1.0), X, X), [0.0 0; 0 8])
matrix_test_approx_eq(MLKernels.kernel_matrix_scaled(2.0, TestKernel(1.0), X', 'T'), [0.0 0; 0 8])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * TestKernel(1.0), X', 'T'), [0.0 0; 0 8])
matrix_test_approx_eq(MLKernels.kernel_matrix_scaled(2.0, TestKernel(1.0), X', X', 'T'), [0.0 0; 0 8])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * TestKernel(1.0), X', X', 'T'), [0.0 0; 0 8])
println("Done")


print("- Testing generic kernel_matrix_product ... ")
matrix_test_approx_eq(MLKernels.kernel_matrix_product(2.0, TestKernel(1.0), TestKernel(1.0), X), [0.0 0; 0 32])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * TestKernel(1.0) * TestKernel(1.0), X), [0.0 0; 0 32])
matrix_test_approx_eq(MLKernels.kernel_matrix_product(2.0, TestKernel(1.0), TestKernel(1.0), X, X), [0.0 0; 0 32])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * TestKernel(1.0) * TestKernel(1.0), X), [0.0 0; 0 32])
matrix_test_approx_eq(MLKernels.kernel_matrix_product(2.0, TestKernel(1.0), TestKernel(1.0), X', 'T'), [0.0 0; 0 32])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * TestKernel(1.0) * TestKernel(1.0), X', 'T'), [0.0 0; 0 32])
matrix_test_approx_eq(MLKernels.kernel_matrix_product(2.0, TestKernel(1.0), TestKernel(1.0), X', X', 'T'), [0.0 0; 0 32])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * TestKernel(1.0) * TestKernel(1.0), X', X', 'T'), [0.0 0; 0 32])
println("Done")


print("- Testing generic kernel_matrix_sum ... ")
matrix_test_approx_eq(MLKernels.kernel_matrix_sum(2.0, TestKernel(1.0), 1.0, TestKernel(1.0), X), [0.0 0; 0 12])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * TestKernel(1.0) + 1.0 * TestKernel(1.0), X), [0.0 0; 0 12])
matrix_test_approx_eq(MLKernels.kernel_matrix_sum(2.0, TestKernel(1.0), 1.0, TestKernel(1.0), X, X), [0.0 0; 0 12])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * TestKernel(1.0) + 1.0 * TestKernel(1.0), X, X), [0.0 0; 0 12])
matrix_test_approx_eq(MLKernels.kernel_matrix_sum(2.0, TestKernel(1.0), 1.0, TestKernel(1.0), X', 'T'), [0.0 0; 0 12])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * TestKernel(1.0) + 1.0 * TestKernel(1.0), X', 'T'), [0.0 0; 0 12])
matrix_test_approx_eq(MLKernels.kernel_matrix_sum(2.0, TestKernel(1.0), 1.0, TestKernel(1.0), X', X', 'T'), [0.0 0; 0 12])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * TestKernel(1.0) + 1.0 * TestKernel(1.0), X', X', 'T'), [0.0 0; 0 12])
println("Done")


X = [1.0 0; 0 1]

print("- Testing optimized euclidean distance kernel_matrix ... ")
matrix_test_approx_eq(kernel_matrix(PowerKernel(2.0), X), [0.0 -2; -2 0])
matrix_test_approx_eq(kernel_matrix(PowerKernel(2.0), X, X), [0.0 -2; -2 0])
println("Done")

print("- Testing optimized euclidian distance kernel_matrix_scaled ... ")
matrix_test_approx_eq(MLKernels.kernel_matrix_scaled(2.0, PowerKernel(2.0), X), [0.0 -4; -4 0])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * PowerKernel(2.0), X), [0.0 -4; -4 0])
matrix_test_approx_eq(MLKernels.kernel_matrix_scaled(2.0, PowerKernel(2.0), X, X), [0.0 -4; -4 0])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * PowerKernel(2.0), X, X), [0.0 -4; -4 0])
println("Done")

print("- Testing optimized euclidian distance kernel_matrix_product ... ")
matrix_test_approx_eq(MLKernels.kernel_matrix_product(2.0, PowerKernel(2.0), PowerKernel(2.0), X), [0.0 8; 8 0])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * PowerKernel(2.0) * PowerKernel(2.0), X), [0.0 8; 8 0])
matrix_test_approx_eq(MLKernels.kernel_matrix_product(2.0, PowerKernel(2.0), PowerKernel(2.0), X, X), [0.0 8; 8 0])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * PowerKernel(2.0) * PowerKernel(2.0), X, X), [0.0 8; 8 0])
println("Done")

print("- Testing optimized euclidian distance kernel_matrix_sum ... ")
matrix_test_approx_eq(MLKernels.kernel_matrix_sum(2.0, PowerKernel(2.0), 1.0, PowerKernel(2.0), X), [0.0 -6; -6 0])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * PowerKernel(2.0) + 1.0 * PowerKernel(2.0), X), [0.0 -6; -6 0])
matrix_test_approx_eq(MLKernels.kernel_matrix_sum(2.0, PowerKernel(2.0), 1.0, PowerKernel(2.0), X, X), [0.0 -6; -6 0])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * PowerKernel(2.0) + 1.0 * PowerKernel(2.0), X, X), [0.0 -6; -6 0])
println("Done")

X = [1.0 0; 0 1]

print("- Testing optimized separable kernel kernel_matrix ... ")
matrix_test_approx_eq(kernel_matrix(MercerSigmoidKernel(0.0, 1.0), X), [tanh(1.0)^2 0; 0 tanh(1.0)^2])
matrix_test_approx_eq(kernel_matrix(MercerSigmoidKernel(0.0, 1.0), X, X), [tanh(1.0)^2 0; 0 tanh(1.0)^2])
println("Done")

print("- Testing optimized separable kernel kernel_matrix_scaled ... ")
matrix_test_approx_eq(MLKernels.kernel_matrix_scaled(2.0, MercerSigmoidKernel(0.0, 1.0), X), 2*[tanh(1.0)^2 0; 0 tanh(1.0)^2])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * MercerSigmoidKernel(0.0, 1.0), X), 2*[tanh(1.0)^2 0; 0 tanh(1.0)^2])
matrix_test_approx_eq(MLKernels.kernel_matrix_scaled(2.0, MercerSigmoidKernel(0.0, 1.0), X, X), 2*[tanh(1.0)^2 0; 0 tanh(1.0)^2])
matrix_test_approx_eq(MLKernels.kernel_matrix(2.0 * MercerSigmoidKernel(0.0, 1.0), X, X), 2*[tanh(1.0)^2 0; 0 tanh(1.0)^2])
println("Done")

