function _plot_diff(f, u)
    #= Plot data f and total variance regularized 
    numerical differences u =#
    pf = plot(f, ylabel=L"f")
    pu = plot(u, ylabel=L"u^{*}_{tv}")
    return plot(pf, pu, layout=(2,1), legend=false)
end