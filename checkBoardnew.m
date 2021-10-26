function [field,okscan]=checkBoardnew(I,playerColor,computerColor)
    load CameraParameters.mat                   % ucitavanje parametara kamere
%     [I,~] = undistortImage(I, cameraParams);
    I1=rgb2gray(I);                             % transformacija rgb slike u grayscale
%     I1=imclearborder(I1);
    BW=imbinarize(I1);                          % binarizacija slike
%     BW=imclearborder(BW);
    BW=bwareaopen(BW,2500);                     % prociscavanje slike uklanjanjem sitnih grupa piksela
    tempProp=regionprops(~logical(BW),'Area','BoundingBox','EulerNumber'); %izdvajanje regiona na slici
    
    areas=[tempProp.Area];                      % novi vektor povrsina
    [~,index]=max(areas);                       % pronalazenje indeksa regiona sa najvecom povrsinom
    
    BiggestBox=tempProp(index).BoundingBox;     % izdvajanje vektora dimenzija iz najveceg regiona
    BW=imcrop(BW,BiggestBox);                   % isjecanje slike
    BW=imclearborder(BW);                       % popunjavanje piksela po ivicama slike
    BW=bwareaopen(BW,3000);                     % vec pomenuto uklanjanje sitnih grupa piksela
    f=bwlabel(BW)';                             % oznacavanje konektovanih komponenti na slici,
                                                % transponovani rezultat je kako bi se odgovarajucim 
                                                % redoslijedom oznacavale komponente

    g=regionprops(f,'Area','BoundingBox'  ,'EulerNumber'); %izdvajanje regiona na slici    
    Num_reg=numel(g);                           % broj izdvojenih regiona

    I=imcrop(I,BiggestBox);                     % isjecanje slike
    b=zeros(1,9);                               % novi vektor nula

    for i=1:Num_reg
        temp_I=imcrop(I,g(i).BoundingBox);      % isjecanje slike tako da je samo jedno polje prikazano 
        temp_I1=rgb2gray(temp_I);               % transformacija iz rgb u grayscale
        temp_BW=imbinarize(temp_I1);            % binarizacija te slike
        
        % erodiranje slike
        se=strel('disk',4,4);                   
                
        temp_BW = imerode(temp_BW,se);
        [k,j,~]=size(temp_BW);
        
        % pronalazenje krugova na slici
        [centers,radii] = imfindcircles(temp_BW,[25 30],'ObjectPolarity','dark','Sensitivity',0.96,'EdgeThreshold',0.24);
        
        [num_circles,~]=size(centers);          % broj pronadjenih krugova
        if(num_circles==1)
            
            pix_of_center_x=round(centers(1));  
            pix_of_center_y=round(centers(2));
            
            % provjera da li je pronadjeni krug u odgovarajucim stranicama
            if((pix_of_center_x-radii)<0 || (pix_of_center_x+radii)>k || (pix_of_center_y-radii)<0 || (pix_of_center_y+radii)>j)
                okscan=0;
                disp('Odigrajte potez u dozvoljenim granicama polja predvidjenog za igru!!!');
                imshow('fair.jpg');
                pause(5);
                close;  
            else
                
                % isjecanje slike oko pronadjenog kruga
                CircleBoundingBox=[round(pix_of_center_x-radii-2),round(pix_of_center_y-radii-2),4+2*round(radii),4+2*round(radii)];
                temp_BW1=imcrop(temp_BW,CircleBoundingBox);
                temp_I2=imcrop(temp_I,CircleBoundingBox);
                label=bwlabel(~temp_BW1);
                temp_LAB=rgb2lab(temp_I2);      % transformacija slike iz rgb prostora u lab prostor
        
                [r,c,~]=size(temp_LAB);

                imA=squeeze(temp_LAB(:,:,2));
                imB=squeeze(temp_LAB(:,:,3));

                aLabel=zeros(r,c);
                bLabel=zeros(r,c);
                % pronalazak kruga na isjecenoj slici
                [centers,~] = imfindcircles(temp_BW1,[25 30],'ObjectPolarity','dark','Sensitivity',0.96,'EdgeThreshold',0.24);
                pix_of_center_x=round(centers(1));
                pix_of_center_y=round(centers(2));
                
                % usrednjavanje vrijednosti piksela kruga
                num_label=1;
                aLabel(label==num_label)=median(imA(label==num_label));
                bLabel(label==num_label)=median(imB(label==num_label));
        
                alab_center=aLabel(pix_of_center_x,pix_of_center_y);
                blab_center=bLabel(pix_of_center_x,pix_of_center_y);
                color=whichColor(alab_center,blab_center);      % poziv funkcije za odredjivanje boje kruga
                
                % odredjivanje da li pronadjena boja odgovara igracu ili robotu
                if(strcmp(color,computerColor))
                    b(i)=1;
                elseif(strcmp(color,playerColor))
                    b(i)=-1;
                end
                okscan=1;
            end
        elseif(num_circles==0)
            b(i)=0;                         % ukoliko nije pronadjen nijedan krug
            okscan=1;
        
        elseif(num_circles>1)               % ukoliko je pronadjeno vise krugova
            disp('Nije dozvoljeno igrati dva poteza odjednom, kao ni igrati na polje na kojem je vec odigran potez');
            imshow('fair.jpg');
            pause(5);
            close;
            okscan=0;
        end
    end
    field=b;                                % vracanje vektora stanja kao rezulat funkcije
end