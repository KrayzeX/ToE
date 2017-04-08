// Чистяков А.А. Подгруппа №3
// Данный модуль принимает на вход матрику коэффицинтов при Uc, Il, I1(U1)
// Возвращает вынужденные составляющие цепи при постоянном воздействии uCв = const, iLв = const.

function[R] = ForcedComponents (KoefMatrix)
    A = [KoefMatrix(1,1) KoefMatrix(1,2); KoefMatrix(2,1) KoefMatrix(2,2)];
    f=[0 0];
    R=A\f;
    disp(R)
endfunction
