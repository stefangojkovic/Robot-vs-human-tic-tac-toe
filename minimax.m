function [result]=minimax(field, player)
    % primjena minimax algoritma
    winner=win(field);
    if(winner==0) 
        move=-1;
        score=-2;
        for i=1:9
            if(field(i) == 0)
                field(i)=player;
                tempScore= -minimax(field,player*-1);
                if(tempScore>score)
                    score=tempScore;
                    move=i;
                end
                field(i)=0;
            end
        end
        if(move == -1) 
            result=0;
        else
            result=score;
        end
    else
        result=winner*player;
    end
end


