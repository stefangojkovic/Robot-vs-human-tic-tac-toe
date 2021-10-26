function [ok]=okToContinue(scannedField,lastComputerField,lastField)
    count=0;
    ok=0;
    good=1;
    [~,sizeA]=size(scannedField);
    lastMoves=sum(lastField<0);
    % provjera da li je doslo do izmjena na stanju ploce i da li se poklapaju stanja
    for i=1:sizeA
        if(lastField(i)==-1 && lastField(i)==scannedField(i))
            count=count+1;
        end
        if(scannedField(i)==-1 && lastComputerField(i)==1)
            good=0;
            disp('Nedozvoljen potez, protivnik je vec odigrao taj potez!!!');
        end
    end
    if(lastMoves==count && good)
        ok=1;
    end
end