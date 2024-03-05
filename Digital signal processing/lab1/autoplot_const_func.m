function autoplot_const_func(f, T, m)
    v = values(m);
    k = keys(m);

    for i = 1:length(m)
        x = 0: 1/v{i} :T;
        plot(x, f(x), k{i});
    end    
end
