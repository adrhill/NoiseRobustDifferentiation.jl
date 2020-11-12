using Plots
using LaTeXStrings

function plot_example_abs(f, u, x, data, û_FDM, û)
    x_opt = range(x[1], x[end], length=1000)
    f_opt = f.(x_opt)
    u_opt = u.(x_opt)

    append!(û_FDM, NaN)

    pf = plot(x_opt, f_opt, c=:grey, ylabel=L"f", label=L"f")
    pf = plot!(x, data, c=:2, ylabel=L"f", 
            label=L"f_{noisy}",
            legend=:bottomright)
    pu = plot(x_opt, u_opt, c=:grey, ylabel=L"u", label=L"u")
    pu = plot!(x, [û_FDM,û], c=[ :2 :1], ylabel=L"u", 
            label=[L"\hat{u}_{FDM}" L"\hat{u}_{TVRD}"],
            legend=:bottomright)
    
    plot(pf, pu, layout=(2, 1), show=true)
end

function plot_FDM(f)
    n = length(f)
    dx = 1/(n-1)

    û_FDM = diff(f) / dx  # FDM
    plot_FDM(f, û_FDM)
end

function plot_FDM(f, û)
    append!(û, NaN)

    n = length(f)
    x = range(0, 1, length=n)

    pf = plot(x, f, c=:1, ylabel=L"f")
    pu = plot(x, û, c=:1, ylabel=L"\hat{u}_{FDM}")
    
    plot(pf, pu, layout=(2, 1), legend=false, show=true)
end

function plot_demo_large_diff(f)
    dx = 1
    û = diff(f) / dx  # FDM
    append!(û, NaN) # hide

    pf = plot(f, c=:1, ylabel=L"f (L/min)")
    pu = plot(û, c=:1, ylabel=L"\hat{u}_{FDM} (L/min/s)", xlabel=L"t (s)")
    
    plot(pf, pu, layout=(2, 1), legend=false, show=true)
end

function plot_demo_large_TVReg(f, û)
    append!(û, NaN) # hide

    pf = plot(f, c=:1, ylabel=latexstring("f (L/min)"))
    pu = plot(û, c=:1, ylabel=L"\hat{u}_{TVRD} (L/min/s)", xlabel=L"t (s)")

    plot(pf, pu, layout=(2, 1), legend=false, show=true)
end

function plot_TVRegDiff(f, û)
    n = length(f)
    dx = 1/(n-1)

    plot_TVRegDiff(f, û, dx)
end

function plot_TVRegDiff(f, û, dx::Real)
    #= Plot data f and total variance regularized 
    numerical differences u =#
    n = length(f)
    x = range(0, step=dx, length=n)

    pf = plot(x, f, ylabel=L"f")
    pu = plot(x, û, ylabel=L"\hat{u}_{TVRD}")

    plot(pf, pu, layout=(2, 1), legend=false, show=true)
end

function plot_TVRegDiff_all(f, û_TVR)
    n = length(f)
    dx = 1/(n-1)
    û_FDM = diff(f) / dx  # FDM

    plot_TVRegDiff_all(f, û_FDM, û_TVR)
end

function plot_TVRegDiff_all(f, û_FDM, û_TVR)
    pf = plot(f, c=:1, ylabel=L"f")
    pu1 = plot(û_FDM, c=:1, ylabel=L"\hat{u}_{FDM}")
    pu2 = plot(û_TVR,  c=:1, ylabel=L"\hat{u}_{TVRD}")

    plot(pf, pu1, pu2, layout=(3, 1), legend=false, show=true)
end


