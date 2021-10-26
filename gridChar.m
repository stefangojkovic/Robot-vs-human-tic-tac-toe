function [result]= gridChar(i)
    switch i
        case -1
            result='X';
        case 0
            result=' ';
        case 1
            result='O';    
    end
end