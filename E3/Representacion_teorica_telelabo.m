%% Antonio Luis Mata García
%% Paula Sánchez Almagro
%% SECO E3

%% Código para la representación teórica de los resultados que se esperan en el motor real del telelabo.
clear all;

%Datos a introducir
k = 2652.28;
p = 64.986;
B_2= 6;
B = 46.4;
Z = 0.2;

%Está hecho con un bucle por si se quiere iterar entre alguno de los
%intervalos posibles de un parámetro(en este caso B (beta_1).
i=0;
for i = 1:1:length(B)
    B_in = B(i);
    k_p =((p.^2)*(2*B_in+1/(Z.^2))) / (((B_2.^2)*k));
    tau_D1 =(B_2*(B_in+2)) / (p*(2*B_in+(1/(Z.^2))));
    K_d1 = k_p *  tau_D1;
    tau_D2 =-p/(k*k_p);
    K_d2 = k_p *  tau_D2;
    tau_I = (B_2*(Z.^2)*(2*B_in+1/(Z.^2)))/(B_in*p);
    K_I = k_p/tau_I;
    num_control_d_pid = [(k*k_p* (tau_D1)) (k*k_p) (k*k_p*1/tau_I)];
    den_control_d_pid = [1 (p +k*k_p* (tau_D1+ tau_D2)) (k*k_p) (k*k_p*1/tau_I)];
    H_d_pid = tf(num_control_d_pid,den_control_d_pid);
    figure(1); hold on
    step(H_d_pid,1);
end
x= 0:0.01:1;
y= 0: 0.01 : 1.2;

%Ploteo de las líneas límites de las especificaciones
ref_baja =ones(1,length(x))*0.98;
ref_alta =ones(1,length(x))*1.02;
ref_mpalta =ones(1,length(x))*1.15;
ref_mpbaja =ones(1,length(x))*1.08;
ref_ts =ones(length(y), 1)*0.5;
ref_tr =ones(length(y), 1)*0.3;
plot(x, ref_baja)
plot(x, ref_alta)
plot(x, ref_mpalta)
plot(x, ref_mpbaja)
plot(ref_ts, y)
plot(ref_tr, y)
