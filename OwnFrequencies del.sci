// Чистяков А.А. Подгруппа №3
// Данный модуль принимает на вход матрику коэффицинтов при Uc, Il, I1(U1)
// Возвращает собственные частоты электрической цепи в вещественной или комплексной форме.

function [r1, r2]= OwnFrequencies(KoefMatrix)
    a = 1;
    b = -(KoefMatrix(1,1)+KoefMatrix(2,2));
    c = (KoefMatrix(1,1)*KoefMatrix(2,2))-(KoefMatrix(2,1)*KoefMatrix(1,2));
    D = b^2-4*a*c;
    r1 = (-b+sqrt(D))/(2*a);
    r2 = (-b-sqrt(D))/(2*a);
endfunction
