// Чистяков А.А. Подгруппа №3
// Данный модуль принимает на вход матрику коэффицинтов при Uc, Il, I1(U1)
// Возвращает вынужденные составляющие цепи при постоянном воздействии uCв = const, iLв = const.

function[R] = ForcedComponents (KoefMatrix)
    A = [KoefMatrix(1,1) KoefMatrix(1,2); KoefMatrix(2,1) KoefMatrix(2,2)];
    f=[-KoefMatrix(1, 3); -KoefMatrix(2,3)];
    R=A\f;
endfunction
