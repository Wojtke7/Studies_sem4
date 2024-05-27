function kod=tablicaKodera( kod,tr )
if( 0==isempty( tr.symbol ) )
    kod(length(kod)).symbol = tr.symbol;
    kod(end).bits = [];
    return;
end
kodleft = tablicaKodera( kod, tr.left );
kodright = tablicaKodera( kod, tr.right );
for n=1:length(kodleft)
    kodleft(n).bits = ['1', kodleft(n).bits];
end
for n=1:length(kodright)
    kodright(n).bits = ['0', kodright(n).bits];
end
kod = [ kodleft, kodright];
% 
% function kod = tablicaKodera(kod, tr)
%     if ( 0==isempty( tr.symbol ) )
%         kod = struct('symbol', tr.symbol, 'bits', '');
%         return;
%     end
% 
%     kodleft = tablicaKodera(struct('symbol', {}, 'bits', {}), tr.left);
%     kodright = tablicaKodera(struct('symbol', {}, 'bits', {}), tr.right);
% 
%     for n = 1:length(kodleft)
%         kodleft(n).bits = ['0', kodleft(n).bits];
%     end
% 
%     for n = 1:length(kodright)
%         kodright(n).bits = ['1', kodright(n).bits];
%     end
% 
%     kod = [kodleft, kodright];
% end
