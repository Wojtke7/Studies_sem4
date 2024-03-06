clear all;
load("adsl_x.mat");
idx = [];
r_val = [];
x = reshape(x, 1, []);


for i=1:2017
    prefix = x(i:i+31);
    prefix = reshape(prefix, 1, []);
    corr_prefix = xcorr(prefix,prefix);
    max_val_pref = round(max(corr_prefix),5);

    r = xcorr(x,prefix);
    r = round(r,5);
    max_val_r = round(max(r),5);
    prefix_index = find(r==max_val_pref);
    prefix_index = abs(prefix_index - length(x))+1;
    
    if length(prefix_index)~=1
        find(r==max_val_pref);
        idx = [idx,prefix_index];
    end
end