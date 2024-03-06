function autoplot_funs(f, fs, T, m)
    v = values(m);
    k = keys(m);

    for i = 1:length(m)
        t = 0: 1/fs :T;
        k{i}, v{i}
        plot(t, f(v{i} * t), k{i});
    end    
end
