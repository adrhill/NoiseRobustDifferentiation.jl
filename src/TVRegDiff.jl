"""
    TVRegDiff(data::Array{<:Real,1}, iter::Int, α::Real; kwargs...)

# Arguments
- `data::Array{<:Real,1}`:    
    Vector of data to be differentiated.

- `iter::Int`:  
    Number of iterations to run the main loop.  A stopping
    condition based on the norm of the gradient vector `g`
    below would be an easy modification.

- `α::Real`:    
    Regularization parameter.  This is the main parameter
    to fiddle with.  Start by varying by orders of
    magnitude until reasonable results are obtained.  A
    value to the nearest power of 10 is usally adequate.
    Higher values increase regularization strenght 
    and improve conditioning.

## Keywords
- `u_0::Array{<:Real,1}`:          
    Initialization of the iteration.  Default value is the
    naive derivative (without scaling), of appropriate
    length (this being different for the two methods).
    Although the solution is theoretically independent of
    the intialization, a poor choice can exacerbate
    conditioning issues when the linear system is solved.

- `scale::String`:
    Scale of dataset, `\"large\"` or `\"small\"` (case insensitive).  
    Default is `\"small\"` .  `\"small\"`  has somewhat better 
    boundary behavior, but becomes unwieldly for very large datasets.  
    `\"large\"` has simpler numerics but
    is more efficient for large-scale problems.  `\"large\"` is
    more readily modified for higher-order derivatives,
    since the implicit differentiation matrix is square.

- `ε::Real`:    
    Parameter for avoiding division by zero.  Default value
    is `1e-6`.  Results should not be very sensitive to the
    value.  Larger values improve conditioning and
    therefore speed, while smaller values give more
    accurate results with sharper jumps.

- `dx::Real`:   
    Grid spacing, used in the definition of the derivative
    operators.  Default is `1 / length(data)`.

- `precond::String`:  
    Select the preconditioner for the conjugate gradient method.
    Default is `\"none\"`.
    - `scale = \"small\"`:
        While in principle `precond=\"simple\"` should speed things up, 
        sometimes the preconditioner can cause convergence problems instead,
        and should be left to `\"none\"`.
    - `scale = \"large\"`:
        The improved preconditioners are one of the main features of the 
        algorithm, therefore using the default `\"none\"` is discouraged.
        Currently, `\"diagonal\"`,`\"amg_rs\"`,`\"amg_sa\"`, `\"cholesky\"`
        are available.

- `diff_kernel::String`:
    Kernel to use in the integral to smooth the derivative. By default it is set to `\"abs\"`, 
    the absolute value ``|u'|``. However, it can be changed to `\"square\"`,
    the square value ``(u')^2``. The latter produces smoother
    derivatives, whereas the absolute values tends to make them more blocky.

- `cg_tol::Real`:      
    Tolerance used in conjugate gradient method. Default is `1e-6`.

- `cgmaxit::Int`:
    Maximum number of iterations to use in conjugate gradient optimisation. 
    Default is `100`.

- `show_diagn::Bool`:    
    Flag whether to display diagnostics at each iteration. Default is `false`.  
    Useful for diagnosing preconditioning problems. When tolerance is not met,
    an early iterate being best is more worrying than a large relative residual.

# Output
- `u`:          
    Estimate of the regularized derivative of data with 
    `length(u) = length(data)`.
"""
function TVRegDiff(data::Array{<:Real,1}, iter::Int, α::Real;
    u_0::Array{<:Real,1}=[NaN],
    scale::String="small",
    ε::Real=1e-6,
    dx::Real=NaN,
    precond::String="none",
    diff_kernel::String="abs",
    cg_tol::Real=1e-6,
    cg_maxiter::Int=100,
    show_diagn::Bool=false,
    )

    n = length(data)
    if isnan(dx)
        dx = 1 / (n - 1)
    end

    # Make string inputs case insensitive
    scale = lowercase(scale)
    precond = lowercase(precond)
    diff_kernel = lowercase(diff_kernel)
    
    # Run TVRegDiff for selected method
    if scale == "small"
        u = _TVRegDiff_small(data, iter, α, u_0, ε, dx, cg_tol, cg_maxiter, precond, diff_kernel, show_diagn)
    elseif scale == "large"
        u = _TVRegDiff_large(data, iter, α, u_0, ε, dx, cg_tol, cg_maxiter, precond, diff_kernel, show_diagn)
    else
        throw(ArgumentError("in keyword argument scale, expected  \"large\" or \"small\", got \"$(scale)\""))
    end

    return u
end

function _TVRegDiff_small(data::Array{<:Real,1}, iter::Int, α::Real,
    u_0::Array{<:Real,1},
    ε::Real,
    dx::Real, 
    cg_tol::Real,
    cg_maxiter::Int,
    precond::String,
    diff_kernel::String,
    show_diagn::Bool,
    )

    n = length(data)

    #= Assert initialization if provided, otherwise set 
    default initization to naive derivative =#
    if isequal(u_0, [NaN])
        u_0 = [0; diff(data); 0] / dx
    elseif length(u_0) != (n + 1)
        throw(DimensionMismatch("in keyword argument u_0, size $(size(u_0)) of intialization doesn't match size ($(n + 1),) required for scale=\"small\"."))
    end
    u = copy(u_0)

    # Construct differentiation matrix.
    D = spdiagm(n, n + 1, 0 => -ones(n), 1 => ones(n)) / dx
    Dᵀ = transpose(D)

    # Construct antidifferentiation operator and its adjoint.
    function A(x)
        (cumsum(x) - 0.5 * (x .- x[1]))[2:end] * dx
    end

    function Aᵀ(x)
        [sum(x) / 2; (sum(x) .- cumsum(x) .- x / 2)] * dx
    end

    # Precompute antidifferentiation adjoint on data
    # Since A([0]) = 0, we need to adjust.
    offset = data[1]
    Aᵀb = Aᵀ(offset .- data)

    for i = 1:iter
        if diff_kernel == "abs"
            # Diagonal matrix of weights, for linearizing E-L equation.
            Q = Diagonal(1 ./ sqrt.((D * u).^2 .+ ε))
            # Linearized diffusion matrix, also approximation of Hessian.
            L = dx * Dᵀ * Q * D
        elseif diff_kernel == "square"
            L = dx * Dᵀ * D
        else 
            throw(ArgumentError("unexpected input \"$(diff_kernel)\" in keyword argument diff_kernel for scale=\"small\""))
        end

        # Gradient of functional.
        g = Aᵀ(A(u)) + Aᵀb + α * L * u

        # Select preconditioner.
        if precond == "simple"
            P = Diagonal(α * diag(L) .+ 1)
        elseif precond == "none"
            P = Identity()
        else 
            throw(ArgumentError("unexpected input \"$(precond)\" in keyword argument precond for scale=\"small\""))
        end
    
        # Prepare linear operator for linear equation.
        # Approximation of Hessian of TVR functional at u
        H = LinearMap(u -> Aᵀ(A(u)) + α * L * u , n+1, n+1)

        # Solve linear equation.
        s = cg(H, -g; Pl=P, tol=cg_tol, maxiter=cg_maxiter)

        show_diagn && println("Iteration $(i):\trel. change = $(norm(s) / norm(u)),\tgradient norm = $(norm(g))")

        # Update current solution
        u += s
    end
    return u[1:end - 1]
end

function _TVRegDiff_large(data::Array{<:Real,1}, iter::Int, α::Real,
    u_0::Array{<:Real,1},
    ε::Real,
    dx::Real,
    cg_tol::Real,
    cg_maxiter::Int,
    precond::String,
    diff_kernel::String,
    show_diagn::Bool,
    )

    n = length(data)
    
    # Since Au(0) = 0, we need to adjust.
    data = data .- data[1]

    #= Assert initialization if provided, otherwise set 
    default initization to naive derivative =#
    if isequal(u_0, [NaN])
        u_0 = [0; diff(data)] / dx
    elseif length(u_0) != n
        throw(DimensionMismatch("in keyword argument u_0, size $(size(u_0)) of intialization doesn't match size ($(n),) required for scale=\"large\"."))
    end
    u = copy(u_0) * dx
    
    # Construct differentiation matrix.
    D = spdiagm(n, n, 0 => -ones(n - 1), 1 => ones(n - 1)) / dx
    Dᵀ = transpose(D)

    # Construct antidifferentiation operator and its adjoint.
    A(x) = cumsum(x)
    
    function Aᵀ(x)
        sum(x) .- [0; cumsum(x[1:end - 1])]
    end

    # Precompute antidifferentiation adjoint on data
    Aᵀd = Aᵀ(data)

    for i = 1:iter
        if diff_kernel == "abs"
            # Diagonal matrix of weights, for linearizing E-L equation.
            Q = Diagonal(1 ./ sqrt.((D * u).^2 .+ ε))
            # Linearized diffusion matrix, also approximation of Hessian.
            L = Dᵀ * Q * D
        elseif diff_kernel == "square"
            L = Dᵀ * D
        else 
            throw(ArgumentError("unexpected input \"$(diff_kernel)\" in keyword argument diff_kernel for scale=\"large\""))
        end

        # Gradient of functional.
        g = Aᵀ(A(u)) - Aᵀd + α * L * u

        # Select preconditioner.
        B = α * L + Diagonal(reverse(cumsum(n:-1:1)))

        if precond == "cholesky"
            # Incomplete Cholesky preconditioner with cut-off level 2
            P = CholeskyPreconditioner(B, 2)
        elseif precond == "diagonal"
            P = DiagonalPreconditioner(B)
        elseif precond == "amg_rs"
            # Ruge-Stuben variant
            P = AMGPreconditioner{RugeStuben}(B)
        elseif precond == "amg_sa"
            # Smoothed aggregation
            P = AMGPreconditioner{SmoothedAggregation}(B)
        elseif precond == "none"
            P = Identity()
        else 
            throw(ArgumentError("unexpected input \"$(precond)\" in keyword argument precond for scale=\"large\""))
        end

        # Prepare linear operator for linear equation.
        # Approximation of Hessian of TVR functional at u
        H = LinearMap(u -> Aᵀ(A(u)) + α * L * u , n, n)

        # Solve linear equation.
        s = cg(H, -g; Pl=P, tol=cg_tol, maxiter=cg_maxiter)
        
        show_diagn && println("Iteration $(i):\trel. change = $(norm(s) / norm(u)),\tgradient norm = $(norm(g))")

        # Update current solution
        u += s
    end
    return u / dx
end