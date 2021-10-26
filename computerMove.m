function [resField,move]=computerMove(field)
    resField=field;             
    move=-1;
    score= -2;
    % pronalazenje najboljeg poteza
    for i=1:9
       if(field(i) == 0)
           field(i)= 1;
           tempScore= -minimax(field,-1);           
           
           if(tempScore>score)
               score=tempScore;
               move=i;
           end
           field(i)=0;
       end
       
    end
    resField(move)=1;           % vracanje rezultata funkcije
end
