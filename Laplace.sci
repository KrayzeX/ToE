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
subplot(3,1,2); 
plzr(Hs);
xtitle('Отображение нулей и полюсов ');


//Построение переходной характеристики
subplot(3,1,3); 
plot(csim("step",0:0.1:25,Sys));
xtitle('Построение переходной характеристики ', 't', 'h1(t)');

result = Hs;
endfunction
