function result = Laplace(A, B, C, D)
Sys = syslin('c', A,B,C,D);
//переход к Лапласу
Hs = ss2tf(Sys);
//Нахождение числителя и знаменателя
num = Hs.num;
den = Hs.den;
//Нахождение нулей и полюсов
//zero = roots(numer(Hs));
//pole = roots(denom(Hs));
//Отображение нулей и полюсов
plzr(Hs);
//Построение переходной характеристики
plot(csim("step",0:0.1:25,Sys));

result = Hs;
endfunction
