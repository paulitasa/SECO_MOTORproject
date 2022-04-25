%% Antonio Luis Mata García
%% Paula Sánchez Almagro
%% SECO E3

%% Código para a partir de unos valores seleccionados del rango óptimo, calcule los parámetros se deben introducir en el telelaboratorio
clear all;

%Parámetros a introducir
zeta= 0.3;
b2= 5;
b= 20;
p= 64.986;
k= 2652.28/23;
t= 5 * 10^(-3);

%Ecuaciones de cálculo
KP_Telelabo=(p^2 * (2*b + (1/(zeta^2))))/(b2^2*k);
TI=(b2 * zeta^2 * (2* b + (1/zeta^2)))/(b * p);
TD1= (b2 * (b + 2))/(p * (2*b +(1/ zeta^2)));
TD2= -(p)/(k * KP_Telelabo);

KD1 = KP_Telelabo * TD1;
KD2 = KP_Telelabo * TD2;
KI = KP_Telelabo / TI;

KD1_Telelabo = KD1 / t;
KD2_Telelabo = KD2 / t;
KI_Telelabo = KI * t;
