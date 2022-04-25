%% Antonio Luis Mata García
%% Paula Sánchez Almagro
%% SECO E3

%% Código para calcular la estabilidad del motor dependiendode la entrada: escalón, rampa y prábola

clear all;

%Parametros configurables
k_p =1;
tau_D1 = 1;
tau_D2 = -64.986/2652.28;
tau_I = 0.1;
%Tipo de señal de entrada: 0 escalon, 1 rampa y 2 parabola
entrada= 2; 
k = 2652.28;
p = 64.986;
n_figura = 1;

%% Controlador PID-D
numerador_control_pid_d = [(k*k_p* tau_D1) (k*k_p) (k*k_p*1/tau_I)];
denominador_control_pid_d = [1 (p +k*k_p* (tau_D1 + tau_D2)) (k*k_p) (k*k_p*1/tau_I)];
%Función de transferencia
H_d_pid = tf(numerador_control_pid_d,denominador_control_pid_d);

%ESCALON
if (entrada == 0)
    figure(n_figura); hold on
    step(H_d_pid);
    title("Controlador PID-D, respuesta a escalón (K_P negativo, \tau_{D1}, \tau_{I} positivos)") 
    n_figura = n_figura +1;
    xlabel('T') 
    ylabel('Amp') 
    legend
end

%RAMPA
if(entrada == 1)
    t=0:0.1:10;
    u = t;
    [y,x]=lsim(numerador_control_pid_d,denominador_control_pid_d,u,t);
    u=t;
    figure(n_figura); hold on
    plot(t,y,t,u);
    title("Controlador PID-D, respuesta a rampa (K_P, \tau_{D1}, \tau_{I} positivos)")
    n_figura = n_figura +1;
    xlabel('T')
    ylabel('Amp')
    legend
end

%PARABOLA
if(entrada == 2)
    t=0:0.1:10;
    u=(t.^2)/100;
    [y,x]=lsim(numerador_control_pid_d,denominador_control_pid_d,u,t);
    figure(n_figura); hold on
    plot(t,y,t,u);
    title("Controlador PID-D, respuesta a parabola (K_P, \tau_{D1}, \tau_{I} positivos")
    n_figura = n_figura +1;
    xlabel('T')
    ylabel('Amp')
    legend
end

%rlocus(H_d_pid);