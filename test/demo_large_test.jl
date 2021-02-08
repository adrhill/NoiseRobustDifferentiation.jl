using CSV
using DataFrames

"""
Perform primitive check for smoothness of derivative.
If derivative û is smooth, elements of diff(û) should be small.
Use parameter-sets from MATLAB examples. =#
"""
function _test_demo_large(data, scale, precond, diff_kernel)


    @test sum(
        abs.(
            diff(
                TVRegDiff(
                    data,
                    40,
                    1e-1,
                    ε = 1e-8;
                    scale = scale,
                    precond = precond,
                    diff_kernel = diff_kernel,
                ),
            ),
        ),
    ) < 1e3
end

function _testset_demo_large(scale, preconds, diff_kernels)
    # Load data
    file = CSV.File("./data/demo_large.csv")
    data = DataFrame(file).largescaledata

    @testset "Demo large" begin
        for precond in preconds
            @testset "$precond" begin
                for diff_kernel in diff_kernels
                    @testset "$diff_kernel" begin
                        _test_demo_large(data, scale, precond, diff_kernel)
                    end
                end
            end
        end
    end
end
