using Plots
using LaTeXStrings

function plot_example(x, f, data, u, u_diff, û)
    pf = plot(x, [data,f], c=[:grey :2], ylabel=L"f", label=[L"f" L"f_{noisy}"])
    pu = plot(x, [u,u_diff,û], c=[:grey :2 :1], ylabel=L"u", label=[L"u" L"\hat{u}_{diff}" L"\hat{u}_{TVRegDiff}"])
    
    plot(pf, pu, layout=(2, 1))
end