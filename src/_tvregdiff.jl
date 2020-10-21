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