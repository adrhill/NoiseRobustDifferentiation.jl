function _plot_diff(f, u, dx)
    #= Plot data f and total variance regularized 
    numerical differences u =#
    n = length(f)
    x = range(0, step=dx, length=n)

    pf = plot(x, f, ylabel=L"f")
    pu = plot(x, u, ylabel=L"\hat{u}")

    plot(pf, pu, layout=(2, 1), legend=false, show=true)
end