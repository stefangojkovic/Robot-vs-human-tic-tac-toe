% X Y Z A B C
or=[180 0 90];                                      % orijentacija robota
    
p0=[7.53 269.10 457.06 or];                         % pocetna pozicija

z=121;                                              % vrijednost po z osi na kojoj se nalazi ploca za igru
zs=183;                                             % vrijednost po z osi na kojoj se nalazi magacin
% t1=[-90 265 119 or];
% t9=[84 431 120.56 or];
% t3=[-88.91 435.22 118.94 or];


tb=zeros(9,6);

tb(1,:)=[-84.87 270.01 z or];                       % pozicija prvog polja ploce za igru u koordinatnom sistemu robota
tb(9,:)=[92.34 441.61 z or];                        % pozicija devetog polja ploce za igru u koordinatnom sistemu robota

offset= abs((tb(1,1)-tb(9,1))/2);                   % preracunati offset
% odredjivanje pozicija ostalih polja
tb(2,:)=[tb(1,1) tb(1,2)+offset z or];
tb(3,:)=[tb(1,1) tb(9,2) 120.7 or];
tb(4,:)=[tb(1,1)+offset tb(1,2) 120.8 or];  
tb(5,:)=[tb(1,1)+offset tb(1,2)+offset 120.8 or];
tb(6,:)=[tb(1,1)+offset tb(1,2)+2*offset 120.8 or];
tb(7,:)=[tb(1,1)+2*offset tb(1,2) 120.8 or];
tb(8,:)=[tb(1,1)+2*offset tb(1,2)+offset z or];

s(1,:)=[180.81 209.53 zs or];                       % pozicija jednog polja magacina
s(2,:)=[201.82 315.19 zs or];                       % pozicija drugog polja magacina


dx=s(2,1)-s(1,1);
dy=s(2,2)-s(1,2);
% odredjivanje ugla zakrivljenosti magacina
if(dx<0)
    teta=atan2d(-dx,dy);
elseif(dx>0)
    teta=-atan2d(dx,dy);
elseif(dx==0 && dy<0)
    teta=-1;
elseif(dx==0 && dy>0)
    teta=0;
end

Rz=[cosd(teta) -sind(teta) 0; sind(teta) cosd(teta) 0;0 0 1];       % matrica rotacije oko z ose

% odredjivanje ostalih polja magacina
skl3=Rz*[67 0 0]';                              
skl4=Rz*[67 115 0]';
s(3,:)=[s(1,1:3)+skl3' or];
s(4,:)=[s(1,1:3)+skl4' or];

% skladista(1,:)=[120.95 247.77 171.85 or];
% skladista(2,:)=[194.87 335.51 171.85 or];
% skladista(1,:)=[183.29 249.63 171.85 or];
% skladista(2,:)=[99.90 327.78 171.85 or];
     