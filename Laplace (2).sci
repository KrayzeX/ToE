function result = Laplace()
//Заглушка - принятие матриц A, B, C, D.
A = [0 8; -4.5 -3]
B = [0;6]
C = [0.75 0]
D = [0]
Sys = syslin('c', A,B,C,D)
//переход к Лапласу
Hs = ss2tf(Sys)
//Нахождение числителя и знаменателя
num = Hs.num
den = Hs.den
//Нахождение нулей и полюсов
zero = roots(numer(Hs))
pole = roots(denom(Hs))
//Отображение нулей и полюсов
figure(1)
plzr(Hs)
xgrid()
endfunction
