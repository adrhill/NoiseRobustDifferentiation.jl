function _plot_diff(f, u, dx)
    #= Plot data f and total variance regularized 
    numerical differences u =#
    n = length(f)
    x = range(0, n * dx, step=dx)

    pf = plot(x, f, ylabel=L"f")
    pu = plot(x, u, ylabel=L"\hat{u}_{TVRegDiff}")

    plot(pf, pu, layout=(2, 1), legend=false, show=true)
end