clear all;
clc;
%Captura de datos mediante MATLAB
%fIGURA EN TRES D
%plano=surf(zeros(10,10),zeros(10,10))
%borrar previos
delete(instrfind({'Port'},{'COM12'})); %ajustar puerto serie!
%crear objeto serie
s = serial('COM12','BaudRate',115200);
warning('off','MATLAB:serial:fscanf:unsuccessfulRead');
%abrir puerto
fopen(s);

% parámetros de medidas
tmax = 30; % tiempo de captura en s
rate = 6.5; % resultado experimental (comprobar)

% inicializar los vectores y matrices
v1 = zeros(1,tmax*rate);%Crear el vector v1 y llenarla con ceros
v2 = zeros(1,tmax*rate);%Crear el vector v2 y llenarla con ceros
v3 = zeros(1,tmax*rate);%Crear el vector v2 y llenarla con ceros


i = 1;
t = 0;
 
% ejecutar bucle cronometrado 48513045
tic
while t<tmax
    t = toc;
 % leer del puerto serie
 	a = fscanf(s,'%d,%d,%d')
	v1(i)=a(1);
	v2(i)=a(2);
	v3(i)=a(3);
    i = i+1;
end

%Calibration
 minx=min(v1);
 maxx=max(v1);
 miny=min(v2);
 maxy=max(v2);
 minz=min(v3);
 maxz=max(v3);
 
 calibx=1/maxx;
 caliby=1/maxy;
 calibz=1/maxz;
 
%% Limpiar los datos del puerto serie
fclose(s);
