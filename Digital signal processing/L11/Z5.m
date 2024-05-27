clear all; close all;
rng(0);
x4 = randi([1,5],1,10);

%coding
x4_codes = ["1111","1110","110","10","0"];
x4_num = {2,3,4,1,5};
coder = containers.Map(x4_num,x4_codes);

huf_code = "";
for i=1:length(x4)
    huf_code = huf_code + coder(x4(i));
end
disp(huf_code);

%decoding
decode_codes = ["1111","1110","110","10","0"];
decode_numbers = {2,3,4,1,5};
decoder = containers.Map(decode_codes,decode_numbers);

x_decoded = "";
temp_str = "";
for i=1:strlength(huf_code)
    temp_str = temp_str + extract(huf_code,i);
    if ismember(temp_str,decode_codes)
        x_decoded = x_decoded + decoder(temp_str);
        temp_str = "";
    end
end 
disp(x_decoded);

%part2

[x_symb,x_prawd] = sortuj(x4);
tr = drzewo(x_symb,x_prawd);
kod = tablicaKodera(struct('symbol', tr.symbol, 'bits', []),tr);


