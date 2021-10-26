function [result]=win(field)
   result=0;
   % provjera da li je pobjedio neki od igraca
   % provjera na osnovu svih mogucih nacina za pobjedu
    for i=-1:2:1
        if field(1)==i && field(2)==i && field(3)==i
            result=i;
        elseif field(4)==i && field(5)==i && field(6)==i
            result=i;
        elseif field(7)==i && field(8)==i && field(9)==i
            result=i;
        elseif field(1)==i && field(4)==i && field(7)==i
            result=i;
        elseif field(2)==i && field(5)==i && field(8)==i
            result=i;
        elseif field(3)==i && field(6)==i && field(9)==i
            result=i;
        elseif field(1)==i && field(5)==i && field(9)==i
            result=i;
        elseif field(3)==i && field(5)==i && field(7)==i
            result=i;
        end
    end
end

