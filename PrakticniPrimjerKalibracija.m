clear 
close all

load CameraParameters.mat           % ucitavanje parametara kamere dobijenih kalibracijom kamere
I=imread('ProbaKalibracijaNajnovija.jpg');

[I1, newOrigin] = undistortImage(I, cameraParams, 'OutputView', 'full');    % pozivanje funkcije za ispravljanje distorzirane slike

figure;                             % prikaz ispravljene slike  
imshow(I1);
title('Undistorted Image');

temp=rgb2gray(I1);                  % transformacija slike iz rgb prostora u grayscale prostor
BW=imbinarize(temp);                % binarizovanje slike, odnosno transformacija slike u crno-bijelu

% se=strel('disk',2,4);
% BW = imerode(BW,se);

% detektovanje tacaka checkerboard kalibracionog sablona na slici
[imagePoints, boardSize] = detectCheckerboardPoints(I1); 

squareSize = 23;                    % stranica kvadrata kalibracionog sablona

% generisanje tacaka sablona u prostoru
worldPoints = generateCheckerboardPoints(boardSize, squareSize);          

imagePoints = imagePoints + newOrigin;                                      % dodaje se newOrigin svakom redu imagePoints

% dobijanje 3D rotacione matrice i 3D translacione matrice,kako bi se transformisale tacke iz 
% prostornog koordinatnog sistema u koordinatni sistem kamere
[R, t] = extrinsics(imagePoints, worldPoints, cameraParams)                 
                                                                            
% Dobijanje prostornih koordinata          
worldPoints1 = pointsToWorld(cameraParams, R, t, imagePoints);

distanceInPixels=norm(imagePoints(1,:)-imagePoints(2,:));
distanceInMillimeters=norm(worldPoints1(1,:)-worldPoints1(2,:));
pixelToMillimeteres= distanceInMillimeters /distanceInPixels; % jedan pixel, koliko je milimetara
millimeterToPixels=distanceInPixels/distanceInMillimeters;    % jedan milimetar, koliko je pixela

% pronalazenje novcica na slici
[centers3,radii3] = imfindcircles(temp,[15 19],'ObjectPolarity','bright','Sensitivity',0.94,'EdgeThreshold',0.1);
[centers2,radii2] = imfindcircles(temp,[15 19],'ObjectPolarity','dark','Sensitivity',0.94,'EdgeThreshold',0.1);
centers=[centers2, centers3];
radii=[radii2,radii3];

% pronalazenje zetona za igru
[centers1,radii1] = imfindcircles(temp,[25 30],'ObjectPolarity','dark','Sensitivity',0.94,'EdgeThreshold',0.1);

[num_penny,~]=size(centers);          % broj pronadjenih novcica

% prikaz novcica i zetona na slici 
viscircles(centers,radii,'Color','r');
% viscircles(centers1,radii1,'Color','b');

% poluprecnici pronadjenih novcica i zetona u milimetrima
radiusInMillimeters= radii*pixelToMillimeteres
radiusInMillimeters1= radii1*pixelToMillimeteres

if(num_penny>0)
    % dobijanje prostornih koordinata
    pennyWorld= pointsToWorld(cameraParams, R, t, centers(1,:));  
    CircleWorld= pointsToWorld(cameraParams, R, t, centers1(1,:));
    % dodavanje vrijednosti z ose za koordinatni pocetak prostornog k. s.
    originWorld=[worldPoints(1,:),0];      
    
    % racunanje 3D prostornih koordinata centra novcica
    pennyWorld3D= [pennyWorld,0]; 
    
    % racunanje orijentacije kamere i njena lokacija u prostornom k. s.
    [orijentacija, cameraLocation] = extrinsicsToCameraPose(R, t);         
    
    % udaljenost novcica od koordinatnog pocetka 
    distanceToPenny = norm(pennyWorld - worldPoints(1,:));      
    
    % udaljenost koordinatnog pocetka od kamere
    distanceToCamera = norm(originWorld - cameraLocation); 
    
    % udaljenost novcica od kamere
    distanceCameraToPenny = norm(pennyWorld3D - cameraLocation);  
    
    % udaljenost kruznog objekta od novcica
    distanceCircleToPenny = norm(pennyWorld - CircleWorld);
    
    % prikaz dobijenih rezultata
    fprintf('Distanca od centra koordinatnog pocetka do kamere = %0.2f mm\n',distanceToCamera);
    fprintf('Distanca od novcica do kamere = %0.2f mm\n',distanceCameraToPenny);
    fprintf('Distanca od centra novcica do koordinatnog pocetka = %0.2f mm\n',distanceToPenny);
    fprintf('Distanca od centra novcica do kruznog objekta = %0.2f mm\n',distanceCircleToPenny);
end
