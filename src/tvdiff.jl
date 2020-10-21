"""
Inputs:  (First three required; omitting the final N parameters for N < 7
           or passing in [] results in default values being used.) 
        data        Vector of data to be differentiated.

        iter        Number of iterations to run the main loop.  A stopping
                    condition based on the norm of the gradient vector g
                    below would be an easy modification.  No default value.

        alph        Regularization parameter.  This is the main parameter
                    to fiddle with.  Start by varying by orders of
                    magnitude until reasonable results are obtained.  A
                    value to the nearest power of 10 is usally adequate.
                    No default value.  Higher values increase
                    regularization strenght and improve conditioning.

        u0          Initialization of the iteration.  Default value is the
                    naive derivative (without scaling), of appropriate
                    length (this being different for the two methods).
                    Although the solution is theoretically independent of
                    the intialization, a poor choice can exacerbate
                    conditioning issues when the linear system is solved.

        scale       'large' or 'small' (case insensitive).  Default is
                    'small'.  'small' has somewhat better boundary
                    behavior, but becomes unwieldly for data larger than
                    1000 entries or so.  'large' has simpler numerics but
                    is more efficient for large-scale problems.  'large' is
                    more readily modified for higher-order derivatives,
                    since the implicit differentiation matrix is square.

        ep          Parameter for avoiding division by zero.  Default value
                    is 1e-6.  Results should not be very sensitive to the
                    value.  Larger values improve conditioning and
                    therefore speed, while smaller values give more
                    accurate results with sharper jumps.

        dx          Grid spacing, used in the definition of the derivative
                    operators.  Default is the reciprocal of the data size.

        plotflag    Flag whether to display plot at each iteration.
                    Default is 1 (yes).  Useful, but adds significant
                    running time.

        diagflag    Flag whether to display diagnostics at each
                    iteration.  Default is 1 (yes).  Useful for diagnosing
                    preconditioning problems.  When tolerance is not met,
                    an early iterate being best is more worrying than a
                    large relative residual.
                   
Output:
        u           Estimate of the regularized derivative of data.  Due to
                    different grid assumptions, length( u ) = 
                    length( data ) + 1 if scale = 'small', otherwise
                    length( u ) = length( data ).
"""
function TVDiff(data::Array{<:Real,1}, iter::Int, α::Real;
    u_0::Array{<:Real,1}=[NaN],
    diag_flag::Bool=true,
    plot_flag::Bool=true,
    dx::Real=NaN,
    ε::Real=1e-6,
    scale::String="small",
    )

    n = length(data)
    if dx === NaN
        dx = 1 / n
    end



    if lowercase(scale) == "small"
        return _TVDiff_small(data, iter, α, u_0, diag_flag, plot_flag, dx, ε)
    elseif lowercase(scale) == "large"
        return _TVDiff_large(data, iter, α, u_0, diag_flag, plot_flag, dx, ε)
    else
        error("in keyword argument scale, expected  \"large\" or \"small\", got \"$(scale)\"")
    end
end

function _TVDiff_small(data::Array{<:Real,1}, u_0::Array{<:Real,1},
    diag_flag::Bool, plot_flag::Bool, dx::Real, ep::Real)

    n = length(data)

    if isequal(u_0, [NaN])
        u_0 = [0; diff(data); 0]
    elseif length(u_0) != (n + 1)
        error("in keyword argument u_0, size $(size(u_0)) of intialization doesn't match size ($(n + 1),) required for scale=\"small\".")
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
        droptol = 1.0e-2
        R = _cholinc(B, droptol); # TODO: cholinc

        # Prepare to solve linear equation.
        tol = 1.0e-4
        maxit = 100
        if diagflag
            # TODO: Use cg methods from IterativeSolvers.jl?
            # s = pcg( @(x) ( alph * L * x + AT( A( x ) ) ), -g, tol, maxit, R', R );
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

function _TVDiff_large(data::Array{<:Real,1}, u_0::Array{<:Real,1},
    diag_flag::Bool, plot_flag::Bool, dx::Real, ep::Real)

    n = length(data)

    if isequal(u_0, [NaN])
        u_0 = [0; diff(data)]
    elseif length(u_0) != n
        error("in keyword argument u_0, size $(size(u_0)) of intialization doesn't match size ($(n),) required for scale=\"large\".")
    end
    u = copy(u_0)

    return u
end