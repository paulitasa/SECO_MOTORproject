%% Antonio Luis Mata García
%% Paula Sánchez Almagro
%% SECO E3

%% Código para plotear controladores dependiendo de sus parámetros y poder sacar conclusiones de su comportamiento. Descomentar y comentar la sección del controlador a estudiar.
clear all;
close all;

%% Parametros configurables a cambiar para las distintas representaciones
k_p = 1; 
tau_D1 = 3; 
tau_D2 = 1;
tau_I = 0.5; 

%% Inicialización o parametros fijos
k = 2652.28;
p = 64.986;
n_figura = 1;

%% Controlador P
numerador_control_p = [k*k_p];
denominador_control_p = [1, p, k*k_p];
%Funcion de transferencia
H_p = tf(numerador_control_p,denominador_control_p);
figure(n_figura); hold on
step(H_p);
title("Controlador tipo P")
n_figura = n_figura +1;
xlabel('T') 
ylabel('Amp') 
legend 

%% Controlador P-D
numerador_control_p_d = [k*k_p];
denominador_control_p_d = [1 (p+ k_p * k * tau_D1) k*k_p];
%Funcion de transferencia
H_p_d = tf(numerador_control_p_d,denominador_control_p_d);
figure(n_figura); hold on
step(H_p_d);
title("Controlador tipo P-D con K_P = 5")
n_figura = n_figura +1;
xlabel('T') 
ylabel('Amp') 
legend 

%% Controlador PD
numerador_control_pd = [(k*k_p* tau_D1) (k*k_p)];
denominador_control_pd = [1 (p+ k_p * k * tau_D1) k*k_p];
%Funcion de transferencia
H_pd = tf(numerador_control_pd,denominador_control_pd);
figure(n_figura); hold on
step(H_pd);
title("Controlador PD")
n_figura = n_figura +1;
xlabel('T') 
ylabel('Amp') 
legend

%% Controlador PI
numerador_control_pi = [(k*k_p) (k*k_p*1/tau_I)];
denominador_control_pi = [1 p (k_p * k) (k*k_p*1/tau_I)];
%Funcion de transferencia
H_pi = tf(numerador_control_pi,denominador_control_pi);
figure(n_figura); hold on
step(H_pi);
title("Controlador PI")
n_figura = n_figura +1;
xlabel('T') 
ylabel('Amp') 
legend

%% Controlador PID
numerador_control_pid = [(k*k_p*tau_D1) (k*k_p) (k*k_p*1/tau_I)];
denominador_control_pid = [1 (p +k*k_p*tau_D1) (k*k_p) (k*k_p*1/tau_I)];
%Funcion de transferencia
H_pid = tf(numerador_control_pid,denominador_control_pid);
figure(n_figura);
hold on;
step(H_pid);
title("Controlador PID")
n_figura = n_figura +1;
xlabel('T') 
ylabel('Amp') 
legend

%% Controlador PI-D
numerador_control_pi_d = [(k*k_p) (k*k_p*1/tau_I)];
denominador_control_pi_d = [1 (p +k*k_p* tau_D1) (k*k_p) (k*k_p*1/tau_I)];
%Funcion de transferencia
H_pi_d = tf(numerador_control_pi_d,denominador_control_pi_d);
figure(n_figura);
hold on;
step(H_pi_d);
title("Controlador PI-D")
n_figura = n_figura +1;
xlabel('T') 
ylabel('Amp') 
legend

%% Controlador PID-D
numerador_control_pid_d = [(k*k_p* tau_D1) (k*k_p) (k*k_p*1/tau_I)];
denominador_control_pid_d = [1 (p +k*k_p* (tau_D1+tau_D2)) (k*k_p) (k*k_p*1/tau_I)];
%Funcion de transferencia
H_pid_d = tf(numerador_control_pid_d,denominador_control_pid_d);
figure(n_figura);
hold on;
step(H_pid_d);
title("Controlador PID-D") 
n_figura = n_figura +1;
xlabel('T') 
ylabel('Amp') 
legend

%% Controlador D|PID
num_control_d_pid = [(k*k_p* (tau_D1+tau_D2)) (k*k_p) (k*k_p*1/tau_I)];
den_control_d_pid = [1 (p +k*k_p* tau_D1) (k*k_p) (k*k_p*1/tau_I)];
%Funcion de transferencia
H_d_pid = tf(num_control_d_pid,den_control_d_pid);
figure(n_figura);
hold on;
step(H_d_pid);
title("Controlador D|PID") 
n_figura = n_figura +1;
xlabel('T') 
ylabel('Amp') 
legend