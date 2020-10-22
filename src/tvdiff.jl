"""
    TVDiff(data::Array{<:Real,1}, iter::Int, α::Real; kwargs...) -> u
# Arguments
-`data::Array{<:Real,1}`:    Vector of data to be differentiated.

-`iter::Int`:   Number of iterations to run the main loop.  A stopping
                condition based on the norm of the gradient vector g
                below would be an easy modification.  No default value.

-`α::Real`:     Regularization parameter.  This is the main parameter
                to fiddle with.  Start by varying by orders of
                magnitude until reasonable results are obtained.  A
                value to the nearest power of 10 is usally adequate.
                No default value.  Higher values increase
                regularization strenght and improve conditioning.

## Keywords
-`u0Array{<:Real,1}`:          
                Initialization of the iteration.  Default value is the
                naive derivative (without scaling), of appropriate
                length (this being different for the two methods).
                Although the solution is theoretically independent of
                the intialization, a poor choice can exacerbate
                conditioning issues when the linear system is solved.

-`scale::String`:
                'large' or 'small' (case insensitive).  Default is
                'small'.  'small' has somewhat better boundary
                behavior, but becomes unwieldly for data larger than
                1000 entries or so.  'large' has simpler numerics but
                is more efficient for large-scale problems.  'large' is
                more readily modified for higher-order derivatives,
                since the implicit differentiation matrix is square.
                
-`preconditioner::String`:    
                Method used for preconditioning. 

-`ε::Real`:     Parameter for avoiding division by zero.  Default value
                is 1e-6.  Results should not be very sensitive to the
                value.  Larger values improve conditioning and
                therefore speed, while smaller values give more
                accurate results with sharper jumps.

-`dx::Real`:    Grid spacing, used in the definition of the derivative
                operators.  Default is the reciprocal of the data size.

-`plot_flag::Bool`:    
                Flag whether to display plot at each iteration.
                Default is 1 (yes).  Useful, but adds significant
                running time.

-`diag_flag::Bool`:    
                Flag whether to display diagnostics at each
                iteration.  Default is 1 (yes).  Useful for diagnosing
                preconditioning problems.  When tolerance is not met,
                an early iterate being best is more worrying than a
                large relative residual.

# Output
        u           Estimate of the regularized derivative of data.  Due to
                    different grid assumptions, length( u ) = 
                    length( data ) + 1 if scale = 'small', otherwise
                    length( u ) = length( data ).
"""
function TVDiff(data::Array{<:Real,1}, iter::Int, α::Real;
    u_0::Array{<:Real,1}=[NaN],
    scale::String="small",
    preconditioner::String="cholesky",
    ε::Real=1e-6,
    dx::Real=NaN,
    diag_flag::Bool=true,
    plot_flag::Bool=true,
    )

    n = length(data)
    if dx === NaN
        dx = 1 / n
    end

    preconditioner = lowercase(preconditioner)
    preconditioner ∉ ["cholesky","diagonal","noting"] && error(
        "unexpected input in keyword argument preconditioner")

    scale = lowercase(scale)
    if scale == "small"
        return _TVDiff_small(data, iter, α, u_0, preconditioner, ε, dx, diag_flag, plot_flag)
    elseif scale == "large"
        return _TVDiff_large(data, iter, α, u_0, preconditioner, ε, dx, diag_flag, plot_flag)
    else
        error("in keyword argument scale, expected  \"large\" or \"small\", got \"$(scale)\"")
    end
end

function _TVDiff_small(data::Array{<:Real,1}, iter::Int, α::Real,
    u_0::Array{<:Real,1},
    preconditioner::String,
    ε::Real,
    dx::Real, 
    diag_flag::Bool, 
    plot_flag::Bool, 
    )

    n = length(data)

    # if isequal(u_0, [NaN])
    #     u_0 = [0; diff(data); 0]
    # elseif length(u_0) != (n + 1)
    #     error("in keyword argument u_0, size $(size(u_0)) of intialization doesn't match size ($(n + 1),) required for scale=\"small\".")
    # end
    if isequal(u_0, [NaN])
        u_0 = [0; diff(data)]
    elseif length(u_0) != n
        error("in keyword argument u_0, size $(size(u_0)) of intialization doesn't match size ($(n),) required for scale=\"large\".")
    end

    u = copy(u_0)

    # Construct differentiation matrix.
    # D = spdiagm(n, n + 1, 0 => -ones(n), 1 => ones(n)) / dx
    D = spdiagm(n, n, 0 => -ones(n), 1 => ones(n - 1)) / dx
    Dᵀ = transpose(D)

    # display(Matrix(D))
    # display(Matrix(Dᵀ))

    # Construct antidifferentiation operator and its adjoint.
    A(x)  = _antidiff(x, dx)
    Aᵀ(x) = _antidiff_transpose(x, dx)

    # Precompute antidifferentiation adjoint on data
    # Since A([0]) = 0, we need to adjust.
    offset = data[1]
    Aᵀb = Aᵀ(offset .- data)

    for i = 1:iter
        # Diagonal matrix of weights, for linearizing E-L equation.
        q = 1 ./ sqrt.((D * u).^2 .+ ε)
        Q = spdiagm(n, n, 0 => q)

        # Linearized diffusion matrix, also approximation of Hessian.
        L = dx * Dᵀ * Q * D

        # Gradient of functional.
        g = Aᵀ(A(u)) + Aᵀb + α * L * u

        # Simple preconditioner.
        P = α * spdiagm(n, n, 0 => diag(L) .+ 1)
        # display(Matrix(L))
        # display(Matrix(P))

        # Solve linear equation.
        s = zero(u)
        linop = LinearOperator(n, n, false, false, v -> α * L * v + Aᵀ(A(v)))
        cg!(s, linop, -g; tol=1.0e-4, maxiter=100) # s is updated in place
        
        diag_flag && println("Iteration $(i):\t
                    relative change = $(norm(s) / norm(u)),\t
                    gradient norm = $(norm(g))")

        # Update current solution
        u += s
        
        # Display plot.
        if plot_flag
            p = plot!(u)
            display(p)
        end
    end
    return u
end

function _TVDiff_large(data::Array{<:Real,1}, iter::Int, α::Real,
    u_0::Array{<:Real,1},
    preconditioner::String,
    ep::Real,
    dx::Real, 
    diag_flag::Bool, 
    plot_flag::Bool, 
    )

    n = length(data)

    if isequal(u_0, [NaN])
        u_0 = [0; diff(data)]
    elseif length(u_0) != n
        error("in keyword argument u_0, size $(size(u_0)) of intialization doesn't match size ($(n),) required for scale=\"large\".")
    end
    u = copy(u_0)

    # Construct differentiation matrix.
    c = ones(n) / dx
    D = spdiagm(n, n + 1, 0 => -c, 1 => c)
    Dᵀ = transpose(D)

    # display(Matrix(D))
    # display(Matrix(Dᵀ))

    # Construct antidifferentiation operator and its adjoint.
    A(x)  = _antidiff(x, dx)
    Aᵀ(x) = _antidiff_transpose(x, dx)

    # Precompute antidifferentiation adjoint on data
    Aᵀd = Aᵀ(data)

    for i = 1:iter_segments
        # Diagonal matrix of weights, for linearizing E-L equation.
        q = 1 ./ sqrt.((D * u).^2 + ε)
        Q = spdiagm(n, n, 0 => q)

        # Linearized diffusion matrix, also approximation of Hessian.
        L = Dᵀ * Q * D

        # Gradient of functional.
        g = Aᵀ(A(u)) - Aᵀd
        g += α * L * u

        # Build preconditioner.
        c = cumsum(n:-1:1)'
        B = α * L + spdiagm(n, n, 0 => reverse(c))
        R = precondtion(B)

        # Prepare to solve linear equation.
        tol = 1.0e-4
        maxit = 100
        s = zero(u)
        if diagflag
            cg!(s, ) # s is updated in place
            """
            # s = pcg( 
                A = @(x) ( alph * L * x + AT( A( x ) ) )
                b = -g, 
                tol, 
                maxit, 
                M1 = R', 
                M2 = R );
            """
                # fprintf( 'iteration %2d: relative change = %.3e, gradient norm = %.3e\n', ii, norm( s ) / norm( u ), norm( g ) );
        else
            # [ s, ~ ] = pcg( @(x) ( alph * L * x + AT( A( x ) ) ), -g, tol, maxit, R', R );
        end

        # Update current solution
        u += s
        
        # Display plot.
        if plotflag
            p = plot(u)
            display(p)
        end
    end
    return u
end