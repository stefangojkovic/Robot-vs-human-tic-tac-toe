function [color] = whichColor(alabel,blabel)

% odredjivanje boje na osnovu dobijenih eksperimentalnih vrijednosti piksela u lab prostoru za zelenu i plavu boju
    if(alabel<-20 && alabel>-40 && blabel<20 && blabel>0)
        color='green';    
    elseif(alabel<5 && alabel>-35 && blabel<0 && blabel>-45)
        color='blue';
    else
        color='Neither blue, neither green';
    end
end