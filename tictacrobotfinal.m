clear 
close all
pause ('on');


portopen(60);
% pause(5);
positions;
pause
speed=40;

robotcontrol(p0,speed);
% pause(5)

% biranje boja igraca
computerColor='blue';               
playerColor='green';


% b=[0 0 0 0 0 0 0 0 0];

cam = webcam('Logitech');           % incijalizacija kamere

I=cam.snapshot;                     % cuvanje u promjenljivu jednog frejma
I=imrotate(I,180);                   % rotiranje slike za 180 stepeni u smjeru suprotno od kazaljke na satu

% I=imread('Proba1.jpg');

% Incijalizacija pocetnih promjenljivih
Loser=imread('loser.jpg');
tieGame=imread('draw.jpg');
playerFirst=1;
done=0;
goodscan=0;
i=1;
withoutRobot=1;
winner=0;
b_computer=[0 0 0 0 0 0 0 0 0];
b_result=[0 0 0 0 0 0 0 0 0];
b_new=[0 0 0 0 0 0 0 0 0];
playerTurns=0;
computerTurns=0;
computerPlayed=0;
okscan=0;


[b,~]=checkBoardnew(I,playerColor,computerColor);   % pocetna provjera table

if(sum(b==0)==9)            %da li je tabla prazna ili ne
%     pause
    while(done==0)
        
        
            
          

            playerTurns=sum(b<0);       %broj poteza igraca
            
            
        
        
        
            
            
            
            % Potez igraca
            if(mod(playerTurns+computerTurns+playerFirst,2)==1 && winner==0 && (computerTurns+playerTurns)<9)
                imshow('igracpotez.jpg')
                b_last=-1*(b<0);                % prethodno stanje samo igracevih poteza
                
                % Petlja koja ne dopusta da se nastavi sa programom, ukoliko se uspjesno ne odigra potez
                % , tj. ako se ne registruje uspjesno odigrani potez
                while(goodscan==0)
                    I=cam.snapshot;
                    I=imrotate(I,180);
                    
                    [b,okscan]=checkBoardnew(I,playerColor,computerColor);
                    
                    if(sum(b<0)-playerTurns==1 && okscan==1)
                        goodscan=okToContinue(b,b_computer,b_last);
                    end
                    pause(2);
                end
                goodscan=0;
                b_new=-1*(b<0);
                close;
            end
            
            winner=win(b_result);                           % provjera trenutnog rezultata
            
            
            % Potez racunara
            if(mod(playerTurns+computerTurns+playerFirst,2)==0 && (computerTurns+playerTurns)<9 && winner==0)
                imshow('robotpotez.jpg');
                
                [b_result,PlayedMove]=computerMove(b_new+b_computer);        % rezultujuci vektor stanja table
                b_computer=b_result>0;                      % vektor stanja table samo poteza racunara 
                computerTurns=computerTurns+1;              % broj poteza racunara
                draw(b_result);                             % iscrtavanje trenutnog stanja
                  
                
                % upravljanje robotom, zadavanje pozicija i brzina
                robotcontrol(s(computerTurns,:)+[0 0 50 0 0 0],speed+10);
                pause(3)
                robotcontrol(s(computerTurns,:),speed);
                pause(3)
                robotcontrol(s(computerTurns,:)+[-100 0 200 0 0 0],speed+10);
                pause(4)
                robotcontrol(tb(PlayedMove,:),speed);
                pause(8)
                robotcontrol(p0,speed+10);
                pause(8)
                
                % provjera stanja ploce za igru, kako ne bi doslo do nelegalne promjene u toku odigravanja poteza robota
                I=cam.snapshot;
                I=imrotate(I,180);
                    
                [b,okscan]=checkBoardnew(I,playerColor,computerColor);
                
                b_scannedCheck=b>0;
                while(~isequal(b_scannedCheck,b_computer))
                                       
                    disp('Promjenjeno stanje na ploci, igrajte FER!!!');
                    imshow('fair.jpg');
                    pause(2);
                     
                    I=cam.snapshot;
                    I=imrotate(I,180);
                    
                    [b,okscan]=checkBoardnew(I,playerColor,computerColor);
                    b_scannedCheck=b>0;
                end
                close;
                
            end
            
            
            b_result=b_new+b_computer;      % osvjezavanje trenutnog stanja 
            
            winner=win(b_result);       % provjera rezultata igre
            
%             i=i+1;
            % ako su zadovoljeni uslovi, izlazak iz petlje
            if(winner~=0 || (computerTurns+playerTurns)>=9)
                done=1; 
                break;
            end

        
    end
else
            winner=-2; 
end

b_result=b_computer+b_new;        

% Prikaz mogucih konacnih slucajeva, po zavrsetku igre ili prije njenog samog pocetka
switch winner
    case -2
        disp('Ploca nije prazna na pocetku igre! Postaviti plocu za pocetak igre!');
        draw(b);
        imshow('praznaploca.jpg');
        pause(5);
        close;
    case -1
        disp('Bravo! Pobjedio si racunar!');
        draw(b_result);
        imshow('pobjeda.jpg');
        pause(5);
        close;
    case 1
        disp('Nazalost, izgubio si! Pobjedio te racunar!');
        draw(b_result);
        imshow(Loser); 
        pause(5);
        close;
    case 0 
        disp('Bravo! Izvukao si nerijesen rezultat protiv racunara!');
        draw(b_result);
        imshow(tieGame);
        pause(5);
        close;
end