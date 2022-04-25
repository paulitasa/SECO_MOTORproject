#include <DueTimer.h>
#define MASTER_CLOCK 84000000

uint32_t clock_a = 4200; 

int enable = 2;
int in1 = 5;
int in2 = 4;
int enc1 = 7; 
int enc2 = 3;

int counter =0;
int cuenta_tiempo=0;

int datos_array[1200];

int flag=0;

int outA;
int outB;

bool timer= false;

//Maquina de estados
enum State_enum{P00, P01, P11, P10}; //PBA

void state_machine_run();

uint8_t state;

int pinPWMH0 = 35; //chanel 0
int pinPWMH1 = 37; //chanel 1


void setup() {
  Serial.begin(115200);
  pinMode(enable, OUTPUT);
  pinMode(in1, INPUT); //entrada si utilizamos pwmhw
  pinMode(in2, INPUT); //entrada si utilizamos pwmhw
  pinMode (enc1, INPUT);
  pinMode (enc2, INPUT);
  
  attachInterrupt(digitalPinToInterrupt(enc1), state_machine_run, CHANGE);
  attachInterrupt(digitalPinToInterrupt(enc2), state_machine_run, CHANGE);

  Timer3.attachInterrupt(temporizador);
  Timer3.start(1000); // Calls every 1ms
  
  //aqui decidir que estado es el primero 
  if(digitalRead(enc1)==0 && digitalRead(enc2)==0) {
    state=P00;
  }
  else if (digitalRead(enc1)==0 && digitalRead(enc2)==1){
    state=P10;
  }
  else if (digitalRead(enc1)==1 && digitalRead(enc2)==0){
    state=P01;
  }
  else if (digitalRead(enc1)==1 && digitalRead(enc2)==1){
    state=P11;
  }

  SetPin(pinPWMH0); // PWMH0
  SetPin(pinPWMH1); //PWMH1
 
  pmc_enable_periph_clk(PWM_INTERFACE_ID);
  PWMC_ConfigureClocks(clock_a, clock_a, MASTER_CLOCK); 
 
  PWMC_SetPeriod(PWM, 0, 4200); // Channel: 0, frecuencia: 84MHz/4200 = 20 kHz
  PWMC_SetDutyCycle(PWM, 0, 0); // Channel: 0, Duty cycle: 0 %
  PWMC_EnableChannel(PWM, 0); // Channel: 0

  PWMC_SetPeriod(PWM, 1, 4200); // Channel: 1, frecuencia: 84MHz/4200 = 20 kHz
  PWMC_SetDutyCycle(PWM, 1, 0); // Channel: 1, Duty cycle: 0 %
  PWMC_EnableChannel(PWM, 1); // Channel: 1
  
 
}

void loop() {
    if(flag ==1){
      for(int i=0; i<1200; i++){
      Serial.println(datos_array[i]);
      }
      flag=0;
    }   
}

void SetPin(uint8_t pin) {
  PIO_Configure(g_APinDescription[pin].pPort,
                PIO_PERIPH_B,
                g_APinDescription[pin].ulPin,
                g_APinDescription[pin].ulPinConfiguration);
}

void state_machine_run() {
  switch(state)
  {    
    case P00:
      if(digitalRead(enc1) == 1){
        counter++;
        state = P01;
      }
      else if(digitalRead(enc2) == 1){
        counter--;
        state = P10;
      }
      else {
        state = P00;
      }
      break;
 
    case P01:
      if(digitalRead(enc2) == 1){
        counter++;
        state = P11;
      }
      else if(digitalRead(enc1) == 0){
        counter--;
        state = P00;
      }
      else {
        state = P01;
      }
      break; 
      
     case P11:
      if(digitalRead(enc1) == 0){
        counter++;
        state = P10;
      }
      else if(digitalRead(enc2) == 0){
        counter--;
        state = P01;
      }
      else {
        state = P11;
      }
      break;
      
    case P10:
      if(digitalRead(enc2) == 0){
        counter++;
        state = P00;
      }
      else if(digitalRead(enc1) == 1){
        counter--;
        state = P11;
      }
      else {
        state = P10;
      }
      break; 
  }
}

void mover_motor(){
  digitalWrite(enable, HIGH);
  PWMC_SetDutyCycle(PWM, 0, 2800); 
  PWMC_SetDutyCycle(PWM, 1, 0); //100%
  
}

void parar_motor(){
  digitalWrite(enable, HIGH);
  PWMC_SetDutyCycle(PWM, 0, 0);
  PWMC_SetDutyCycle(PWM, 1, 0);
}

void temporizador(){
  cuenta_tiempo=cuenta_tiempo+1;
  datos_array[cuenta_tiempo]=counter;
  if(cuenta_tiempo<600){
    mover_motor();
  }else if ((600<=cuenta_tiempo) && (cuenta_tiempo<1200)){
    parar_motor();
  }else {
    Timer3.stop(); // Stop timer
    parar_motor();
    flag=1;
  }
}
