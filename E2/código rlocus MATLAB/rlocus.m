polo=38.4237;
ganancia= 1712.2344;
reductora=74.83;

num=[0 0 ganancia/reductora];
denom=[1 polo 0];
sys= tf(num, denom);
rlocus(sys)
