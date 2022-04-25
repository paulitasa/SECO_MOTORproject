%% Antonio Luis Mata García
%% Paula Sánchez Almagro
%% SECO E3

%% Código para calcular el rango óptimo de cada parámetro para cumplir con las especifiaciones del enunciado. 
%Se recomienda comentar las secciones que no estén evaluandose y evaluar siempre 
%por primera vez la sección de MP si se quiere evaluar alguna de las posteriores. 
%Se necesitan valores que se generan en esta sección MP en las posteriores 
clear all;
close all;
n_figura = 1;

%% MP. Fijanmos B_2 por ser independiente de Mp y calculamos los posibles valores B para diferentes valores de C(coeficiente de amortiguamiento)
%Parametros configurables
K = 2652.28;
r = 23;
k = K/r;
p = 64.986;
B_incremento= 0:0.1:100;
B_2 = 0.5;
C_incremento = [0.2 0.25 0.3 0.35];

%Recorremos C y B
for i = 1:1:length(C_incremento)
    C = C_incremento(i);
    for  j = 1:1:length(B_incremento)
        B = B_incremento(j);
        %Transformacion de los parametros B,B_2 y C a k_p, tau_D1, tau_D2 y tau_I
        k_p =((p.^2)*(2*B+1/(C.^2))) / (((B_2.^2)*k));
        tau_D1 =(B_2*(B+2)) / (p*(2*B+(1/(C.^2))));
        tau_D2 =p/(k*k_p);
        tau_I = (B_2*(C.^2)*(2*B+1/(C.^2)))/(B*p);
        
        %Generación de la funcion de transferencia de un controlador PID-D
        numerador_control_d_pid = [(k*k_p* tau_D1) (k*k_p) (k*k_p*1/tau_I)];
        denominador_control_d_pid = [1 (p +k*k_p* (tau_D1 + tau_D2)) (k*k_p) (k*k_p*1/tau_I)];
        H_d_pid = tf(numerador_control_d_pid,denominador_control_d_pid);
        
        %Función ante la respuesta al impulso
        [y,t]=step(H_d_pid);
        
        %Almacenamiento el valor M_p para cada interación
        M_p(i,j) = max(y);
    end
    %Ploteamos el resultado
    figure(n_figura); hold on
    plot(B_incremento,M_p(i,:))
end
%Representación de los limites 8% y 15%
ref_baja =ones(1,length(B_incremento))*1.08;
ref_alta =ones(1,length(B_incremento))*1.15;
plot (B_incremento,ref_baja,'--');
plot (B_incremento,ref_alta,'--');


legend("\zeta = 0.2","\zeta = 0.25","\zeta = 0.3","\zeta = 0.35","M_P max","M_P min");
title("Relación entre \beta y M_P")
xlabel('\beta')
ylabel('M_P')
n_figura = n_figura +1;
%Almacenamos los intervalos que cumplen tener M_p entre 8% y 15%
[row,col] = find (M_p > 1.08 & M_p < 1.15);
Col_05_i = find(row == 1);
Col_05 = B_incremento(col(Col_05_i));
Col_06_i = find(row == 2);
Col_06 = B_incremento( col(Col_06_i));
Col_07_i = find(row == 3);
Col_07 = B_incremento( col(Col_07_i));
Col_08_i = find(row == 4);
Col_08 = B_incremento( col(Col_08_i));

%Límites de los intervalos para nuestra tabla
C_array = [Col_05(1) Col_05(end) Col_06(1) Col_06(end) Col_07(1) Col_07(end) Col_08(1) Col_08(end)];
n_figura= n_figura +1;

%% TIEMPO DE ESTABLECIMIENTO. Calculamos B_2 para el B minimo y B maximo de cada C que cumple el M_p 
%C = 0.5; %Si queremos fijar C a un valor concreto y estudiar el
%comportamiento

%Arrays de las B máx y min almacenadas en el apartado anterior
C_max=[C_array(1) C_array(3) C_array(5) C_array(7)]; %Array B_max
C_min=[C_array(2) C_array(4) C_array(6) C_array(8)]; %Array B_min


%% TIEMPO DE ESTABLECIMIENTO. CÓDIGO CON MÍNIMOS
%Recorremos C y B
for i = 1:1:length(C_min)
    B = C_min(i);
    B_2_incremento = 0:0.1:100;
    if ~rem(i,2)==0
        C = C+ 0.1;
    end   
    for j = 1:1:length(B_2_incremento)
        B_2 = B_2_incremento(j);
        
        %Generación de la funcion de transferencia de un controlador PID-D
        wn = p/(B_2 * C(i));  
        Q = C(i).^2 - 2 * C_min(i) + 1 / (C_incremento(i).^2);
        r1=C_incremento(i)*wn* (C_min(i) * (1/(C_incremento(i).^2)-4)+ (2/(C_incremento(i).^2)))/Q; 
        r2=wn^2 * (1/(C_incremento(i)^2)-2*C_min(i))/Q;
        r3=C_min(i)^3*C_incremento(i)*wn/Q;
          
        operador1= tf([r1 r2],[1 2*wn*C_incremento(i) wn.^2]);
        operador2= tf([r3],[1 C_min(i)*C_incremento(i)*wn]); 
        
        H_d_pid = operador1 + operador2;
        s=stepinfo(H_d_pid);
        establecimiento_max(j)=s.SettlingTime;
        if(establecimiento_max(j)<=0.5) %ts limite de 0.5
           establecimiento_max_corte(i)=B_2; %Valores limites del rango
        end                    
    end
    figure(n_figura); hold on
    plot(B_2_incremento, establecimiento_max) 
    hold on
end

%Representación del limite 0.5s
ref_baja2 =ones(1,length(B_2_incremento))*0.5;
plot (B_2_incremento,ref_baja2,'--');

legend("\zeta = 0.2  \beta = 46.4","\zeta = 0.25 \beta = 34.9","\zeta = 0.3 \beta = 27.5","\zeta = 0.35 \beta=22.4","ts max");
title("Tiempo de establecimiento")
xlabel('\beta_2')
ylabel('t_s')
axis([0 50 0 2]);
n_figura = n_figura +1;

%% TIEMPO DE ESTABLECIMIENTO. CÓDIGO CON MÁXIMOS
%Recorremos C y B
for i = 1:1:length(C_max)
    B = C_max(i);
    B_2_incremento = 0:0.1:100;
    if ~rem(i,2)==0
        C = C+ 0.1;
    end   
    for j = 1:1:length(B_2_incremento)
        B_2 = B_2_incremento(j);
        
        %Generación de la funcion de transferencia de un controlador PID-D
        wn = p/(B_2 * C(i));  
        Q = C(i).^2 - 2 * C_max(i) + 1 / (C_incremento(i).^2);
        r1=C_incremento(i)*wn* (C_max(i) * (1/(C_incremento(i).^2)-4)+ (2/(C_incremento(i).^2)))/Q; 
        r2=wn^2 * (1/(C_incremento(i)^2)-2*C_max(i))/Q;
        r3=C_max(i)^3*C_incremento(i)*wn/Q;
          
        operador1= tf([r1 r2],[1 2*wn*C_incremento(i) wn.^2]);
        operador2= tf([r3],[1 C_max(i)*C_incremento(i)*wn]); 
        
        H_d_pid = operador1 + operador2;
        s=stepinfo(H_d_pid);
        establecimiento_max(j)=s.SettlingTime;
        if(establecimiento_max(j)<=0.5) %ts limite de 0.5
           establecimiento_max_corte(i)=B_2; %Valores limites del rango
        end                    
    end
    figure(n_figura); hold on
    plot(B_2_incremento, establecimiento_max) 
    hold on
end

%Representación del limite 0.5s
ref_baja2 =ones(1,length(B_2_incremento))*0.5;
plot (B_2_incremento,ref_baja2,'--');

legend("\zeta = 0.2  \beta = 46.4","\zeta = 0.25 \beta = 34.9","\zeta = 0.3 \beta = 27.5","\zeta = 0.35 \beta=22.4","ts max");
title("Tiempo de establecimiento")
xlabel('\beta_2')
ylabel('t_s')
axis([0 50 0 2]);
n_figura = n_figura +1;

%% TIEMPO DE SUBIDA. Calculamos B_2 para el B minimo y B maximo de cada C que cumple el M_p. 
%Arrays de las B máx y min almacenadas en el apartado anterior
C_max=[C_array(1) C_array(3) C_array(5) C_array(7)]; %Array B_max
C_min=[C_array(2) C_array(4) C_array(6) C_array(8)]; %Array B_min

tiempo = 0:0.001:0.5; 

%% TIEMPO DE ESTABLECIMIENTO. CÓDIGO CON MÍNIMOS
%Recorremos C y B_2
for i = 1:1:length(C_min)
    B = C_min(i);
    B_2_incremento = 0.1:0.1:500; 
    if ~rem(i,2)==0
        C = C+ 0.1;
    end   
    for  j = 1:1:length(B_2_incremento)
        B_2 = B_2_incremento(j);
        
        %Generación de la funcion de transferencia de un controlador PID-D
        wn = p/(B_2 * C_incremento(i));  
        Q = C_min(i).^2 - 2 * C_min(i) + 1 / (C_incremento(i).^2);
        r1=C_incremento(i)*wn* (C_min(i) * (1/(C_incremento(i).^2)-4)+ (2/(C_incremento(i).^2)))/Q; 
        r2=wn^2 * (1/(C_incremento(i)^2)-2*C_min(i))/Q;
        r3=C_min(i)^3*C_incremento(i)*wn/Q;
          
        operador1= tf([r1 r2],[1 2*wn*C_incremento(i) wn.^2]);
        operador2= tf([r3],[1 C_min(i)*C_incremento(i)*wn]);  
        H_d_pid = operador1 + operador2;
        [y, t]=step(H_d_pid);
        for k= 1: (length(tiempo)-1)
            if(y(k)>=1.00)
                    break;
                end
            end
            subida_max(j)=t(k);

            if(subida_max(j)<=0.3)%ts limite de 0.3
                subida_max_corte(i)=B_2_incremento(j);%Valores limites del rango
            end    
    end
    figure(n_figura); hold on
    plot(B_2_incremento, tr_max) 
    hold on
end
%Representación del limite 0.3s
ref_baja3 =ones(1,length(B_2_incremento))*0.3;
plot (B_2_incremento,ref_baja3,'--');

legend("\zeta = 0.2  \beta = 46.4","\zeta = 0.25 \beta = 34.9","\zeta = 0.3 \beta = 27.5","\zeta = 0.35 \beta=22.4","tr max");
title("Tiempo de subida")
xlabel('\beta_2')
ylabel('t_r')
axis([0 500 0 0.6]);
n_figura = n_figura +1;


%% TIEMPO DE ESTABLECIMIENTO. CÓDIGO CON MÁXIMOS
%Recorremos C y B_2
for i = 1:1:length(C_max)
    B = C_max(i);
    B_2_incremento = 0.1:0.1:500; 
    if ~rem(i,2)==0
        C = C+ 0.1;
    end   
    for  j = 1:1:length(B_2_incremento)
        B_2 = B_2_incremento(j);
        
        %Generación de la funcion de transferencia de un controlador PID-D
        wn = p/(B_2 * C_incremento(i));  
        Q = C_max(i).^2 - 2 * C_max(i) + 1 / (C_incremento(i).^2);
        r1=C_incremento(i)*wn* (C_max(i) * (1/(C_incremento(i).^2)-4)+ (2/(C_incremento(i).^2)))/Q; 
        r2=wn^2 * (1/(C_incremento(i)^2)-2*C_max(i))/Q;
        r3=C_max(i)^3*C_incremento(i)*wn/Q;
          
        operador1= tf([r1 r2],[1 2*wn*C_incremento(i) wn.^2]);
        operador2= tf([r3],[1 C_max(i)*C_incremento(i)*wn]);  
        H_d_pid = operador1 + operador2;
        [y, t]=step(H_d_pid);
        for k= 1: (length(tiempo)-1)
            if(y(k)>=1.00)
                    break;
                end
            end
            subida_max(j)=t(k);

            if(subida_max(j)<=0.3)%ts limite de 0.3
                subida_max_corte(i)=B_2_incremento(j);%Valores limites del rango
            end    
    end
    figure(n_figura); hold on
    plot(B_2_incremento, tr_max) 
    hold on
end
%Representación del limite 0.3s
ref_baja3 =ones(1,length(B_2_incremento))*0.3;
plot (B_2_incremento,ref_baja3,'--');

legend("\zeta = 0.2  \beta = 46.4","\zeta = 0.25 \beta = 34.9","\zeta = 0.3 \beta = 27.5","\zeta = 0.35 \beta=22.4","tr max");
title("Tiempo de subida")
xlabel('\beta_2')
ylabel('t_r')
axis([0 500 0 0.6]);
n_figura = n_figura +1;