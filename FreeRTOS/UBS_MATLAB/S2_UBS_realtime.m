clear all;
close all;
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
ax = zeros(1,tmax*rate);%Crear el vector v1 y llenarla con ceros
ay = zeros(1,tmax*rate);%Crear el vector v2 y llenarla con ceros
az = zeros(1,tmax*rate);%Crear el vector v2 y llenarla con ceros
degx = zeros(1,tmax*rate);%Crear el vector v1 y llenarla con ceros
degy = zeros(1,tmax*rate);%Crear el vector v2 y llenarla con ceros
degz = zeros(1,tmax*rate);%Crear el vector v2 y llenarla con ceros

i = 1;
t = 0;
 
% ejecutar bucle cronometrado 48513045
tic
while t<tmax
    t = toc;
 % leer del puerto serie
 	a = fscanf(s,'%d,%d,%d');
	ax(i)= a(1)/16896;
	ay(i)= a(2)/16960;
	az(i)= a(3)/19136;
    
    degx(i) = actodeg(ax(i),az(i));
    degy(i) = actodeg(ay(i),az(i));
    degz(i) = actodeg(az(i),az(i));
 % dibujar en la figura
    plano=surf(zeros(10,10),zeros(10,10));%Generando plano
    rotate(plano,[ 1 0 0],degx(i))%Rotando plano en x
    rotate(plano,[ 0 1 0],degy(i))%Rotando plano en y
    axis([0 10 0 10 -10 10])%Estableciendo los ejes
    drawnow%grafica en tiempo real
    
    i = i+1;
end

%% Limpiar los datos del puerto serie
fclose(s);
