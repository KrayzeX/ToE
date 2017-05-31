//Марчук Л.Б. 5307 подгруппа 3
//Данный модуль задаёт входной одиночный импульс в S-области
//Входные параметры: тип входного одиночного импульса:
//0 - прямоугольный одиночный импульс;
//1 - синусный одиночный импульс;
//2 - треугольный одиночный импульс;
//3 - косинусный одиночный импульс;
//4 - меандр;
// длительность входного одиночного импульса tau и передаточная функция.
//Выходной параметр - матрица-столбец изображений частей реакции цепи
//на заданный входной одиночный импульс.

//СЛОЖЕНИЕ - ПАРАЛЛЕЛЬНОЕ СОЕДИНЕНИЕ (ТРЕБУЕТСЯ ОДИНАКОВЫЙ СДВИГ В t-ОБЛАСТИ)
//УМНОЖЕНИЕ - ПОСЛЕДОВАТЕЛЬНОЕ СОЕДИНЕНИЕ (МОГУТ БЫТЬ РАЗНЫЕ СДВИГИ В t-ОБЛАСТИ)
function [] = InputLaplace(Type, tau, Hs)
    exec 'iodelay/loader.sce';
    
    //Объявляем переменную Лапласа
    s = poly(0, 's');
    
    //Исследуемый отрезок частот
    w = 1.01:0.001:4.01;
    
    //Определяем тип входного одиночного импульса
    switch Type
    case 0
        //Прямоугольный одиночный импульс
        P1 = 1/s;
        P2 = -1/s;
        P1 = syslin('c', P1);
        P2 = syslin('c', P2);
        
        //АЧХ и ФЧХ входного одиночного импульса
        Values1 = freq(numer(P1), denom(P1), %i*w);
        Real1 = real(Values1);
        Imag1 = imag(Values1);
        
        Values2 = freqd(numer(P2), denom(P2), tau/2, %i*w);
        Real2 = real(Values2);
        Imag2 = imag(Values2);
        
        Real = (Real1 + Real2);
        Imag = (Imag1 + Imag2);
        
        //АЧХ
        A = sqrt(Real.^2 + Imag.^2);
        plot2d(w, A);
        
        //Находим полосу пропускания цепи
        Level = 0.1*max(A);
        xpts = [0 max(w)];
        ypts = [Level Level];
        plot2d(xpts, ypts);
        halt;
        
        //ФЧХ
        for i = 1:1:3001
            if Real > 0
                Fr(i) = atan(Imag(i)/Real(i));
            else
                Fr(i) = atan(Imag(i)/Real(i)) + %pi;
            end;
        end;
        
        plot(w, Fr);
        halt; 
        
        //АЧХ и ФЧХ реакции
        P1 = P1*Hs;
        P2 = P2*Hs;
        
        Values1 = freq(numer(P1), denom(P1), %i*w);
        Real1 = real(Values1);
        Imag1 = imag(Values1);
        
        Values2 = freqd(numer(P2), denom(P2), tau/2, %i*w);
        Real2 = real(Values2);
        Imag2 = imag(Values2);
        
        Real = (Real1 + Real2);
        Imag = (Imag1 + Imag2);
        
        //АЧХ и ФЧХ входного одиночного импульса
        //АЧХ
        A = sqrt(Real.^2 + Imag.^2);
        plot2d(w, A);
        
        //Находим полосу пропускания цепи
        Level = 0.1*max(A);
        xpts = [0 max(w)];
        ypts = [Level Level];
        plot2d(xpts, ypts);
        halt;
        
        //ФЧХ
        for i = 1:1:3001
            if Real > 0
                Fr(i) = atan(Imag(i)/Real(i));
            else
                Fr(i) = atan(Imag(i)/Real(i)) + %pi;
            end;
        end;
        
        plot(w, Fr);
        halt;
        //Сдвиг во временной области
        P2 = iodelay(P2, tau);
        R = [P1; P2];
        break;
    case 1
        //Синусный одиночный импульс
        P1 = tau/(s^2 + tau^2);
        P2 = tau/(s^2 + tau^2);
        P1 = syslin('c', P1);
        P2 = syslin('c', P2);
        
        //АЧХ и ФЧХ входного одиночного импульса
        Values1 = freq(numer(P1), denom(P1), %i*w);
        Real1 = real(Values1);
        Imag1 = imag(Values1);
        
        Values2 = freqd(numer(P2), denom(P2), tau/2, %i*w);
        Real2 = real(Values2);
        Imag2 = imag(Values2);
        
        Real = (Real1 + Real2);
        Imag = (Imag1 + Imag2);
        
        //АЧХ
        A = sqrt(Real.^2 + Imag.^2);
        plot2d(w, A);
        
        //Находим полосу пропускания цепи
        Level = 0.1*max(A);
        xpts = [0 max(w)];
        ypts = [Level Level];
        plot2d(xpts, ypts);
        halt;
        
        //ФЧХ
        for i = 1:1:3001
            if Real > 0
                Fr(i) = atan(Imag(i)/Real(i));
            else
                Fr(i) = atan(Imag(i)/Real(i)) + %pi;
            end;
        end;
        
        plot(w, Fr);
        halt; 
        
        //АЧХ и ФЧХ реакции
        P1 = P1*Hs;
        P2 = P2*Hs;
        
        Values1 = freq(numer(P1), denom(P1), %i*w);
        Real1 = real(Values1);
        Imag1 = imag(Values1);
        
        Values2 = freqd(numer(P2), denom(P2), tau/2, %i*w);
        Real2 = real(Values2);
        Imag2 = imag(Values2);
        
        Real = (Real1 + Real2);
        Imag = (Imag1 + Imag2);
        
        //АЧХ и ФЧХ входного одиночного импульса
        //АЧХ
        A = sqrt(Real.^2 + Imag.^2);
        plot2d(w, A);
        
        //Находим полосу пропускания цепи
        Level = 0.1*max(A);
        xpts = [0 max(w)];
        ypts = [Level Level];
        plot2d(xpts, ypts);
        halt;
        
        //ФЧХ
        for i = 1:1:3001
            if Real > 0
                Fr(i) = atan(Imag(i)/Real(i));
            else
                Fr(i) = atan(Imag(i)/Real(i)) + %pi;
            end;
        end;
        
        plot(w, Fr);
        halt;
        
        //Сдвиг во временной области
        P2 = iodelay(P2, tau);
        R = [P1; P2];
        break;
    case 2
        //Треугольный одиночный импульс
        P1 = 1/s^2;
        P2 = -1/s^2 + tau/s;
        P3 = 1/s^2 - tau/s;
        P1 = syslin('c', P1);
        P2 = syslin('c', P2);
        P3 = syslin('c', P3);
        
        //АЧХ и ФЧХ входного одиночного импульса
        Values1 = freq(numer(P1), denom(P1), %i*w);
        Real1 = real(Values1);
        Imag1 = imag(Values1);
        
        Values2 = freqd(numer(P2), denom(P2), tau/2, %i*w);
        Real2 = real(Values2);
        Imag2 = imag(Values2);
        
        Values3 = freqd(numer(P3), denom(P3), tau, %i*w);
        Real3 = real(Values3);
        Imag3 = imag(Values3);
        
        Real = (Real1 + Real2 + Real3);
        Imag = (Imag1 + Imag2 + Imag3);
        
        //АЧХ
        A = sqrt(Real.^2 + Imag.^2);
        plot2d(w, A);
        
        //Находим полосу пропускания цепи
        Level = 0.1*max(A);
        xpts = [0 max(w)];
        ypts = [Level Level];
        plot2d(xpts, ypts);
        halt;
        
        //ФЧХ
        for i = 1:1:3001
            if Real > 0
                Fr(i) = atan(Imag(i)/Real(i));
            else
                Fr(i) = atan(Imag(i)/Real(i)) + %pi;
            end;
        end;
        
        plot(w, Fr);
        halt; 
        
        //АЧХ и ФЧХ реакции
        P1 = P1*Hs;
        P2 = P2*Hs;
        P3 = P3*Hs;
        
        Values1 = freq(numer(P1), denom(P1), %i*w);
        Real1 = real(Values1);
        Imag1 = imag(Values1);
        
        Values2 = freqd(numer(P2), denom(P2), tau/2, %i*w);
        Real2 = real(Values2);
        Imag2 = imag(Values2);
        
        Values3 = freqd(numer(P3), denom(P3), tau, %i*w);
        Real3 = real(Values3);
        Imag3 = imag(Values3);
        
        Real = (Real1 + Real2 + Real3);
        Imag = (Imag1 + Imag2 + Imag3);
        
        //АЧХ и ФЧХ входного одиночного импульса
        //АЧХ
        A = sqrt(Real.^2 + Imag.^2);
        plot2d(w, A);
        
        //Находим полосу пропускания цепи
        Level = 0.1*max(A);
        xpts = [0 max(w)];
        ypts = [Level Level];
        plot2d(xpts, ypts);
        halt;
        
        //ФЧХ
        for i = 1:1:3001
            if Real > 0
                Fr(i) = atan(Imag(i)/Real(i));
            else
                Fr(i) = atan(Imag(i)/Real(i)) + %pi;
            end;
        end;
        
        plot(w, Fr);
        halt;

        //Сдвиг во временной области
        P2 = iodelay(P2, tau/2);
        P3 = iodelay(P3, tau);
        R = [P1; P2; P3];
        break;
    case 3
        //Косинусный одиночный импульс
        P1 = s/(s^2 + tau^2);
        P2 = -s/(s^2 + tau^2);
        P1 = syslin('c', P1);
        P2 = syslin('c', P2);
        
        //АЧХ и ФЧХ входного одиночного импульса
        Values1 = freq(numer(P1), denom(P1), %i*w);
        Real1 = real(Values1);
        Imag1 = imag(Values1);
        
        Values2 = freqd(numer(P2), denom(P2), tau/2, %i*w);
        Real2 = real(Values2);
        Imag2 = imag(Values2);
        
        Real = (Real1 + Real2);
        Imag = (Imag1 + Imag2);
        
        //АЧХ
        A = sqrt(Real.^2 + Imag.^2);
        plot2d(w, A);
        
        //Находим полосу пропускания цепи
        Level = 0.1*max(A);
        xpts = [0 max(w)];
        ypts = [Level Level];
        plot2d(xpts, ypts);
        halt;
        
        //ФЧХ
        for i = 1:1:3001
            if Real > 0
                Fr(i) = atan(Imag(i)/Real(i));
            else
                Fr(i) = atan(Imag(i)/Real(i)) + %pi;
            end;
        end;
        
        plot(w, Fr);
        halt; 
        
        //АЧХ и ФЧХ реакции
        P1 = P1*Hs;
        P2 = P2*Hs;
        
        Values1 = freq(numer(P1), denom(P1), %i*w);
        Real1 = real(Values1);
        Imag1 = imag(Values1);
        
        Values2 = freqd(numer(P2), denom(P2), tau/2, %i*w);
        Real2 = real(Values2);
        Imag2 = imag(Values2);
        
        Real = (Real1 + Real2);
        Imag = (Imag1 + Imag2);
        
        //АЧХ
        A = sqrt(Real.^2 + Imag.^2);
        plot2d(w, A);
        
        //Находим полосу пропускания цепи
        Level = 0.1*max(A);
        xpts = [0 max(w)];
        ypts = [Level Level];
        plot2d(xpts, ypts);
        halt;
        
        //ФЧХ
        for i = 1:1:3001
            if Real > 0
                Fr(i) = atan(Imag(i)/Real(i));
            else
                Fr(i) = atan(Imag(i)/Real(i)) + %pi;
            end;
        end;
        
        plot(w, Fr);
        halt;
        
        //Сдвиг во временной области
        P2 = iodelay(P2, tau);
        R = [P1; P2];
        break;
    case 4
        //Меандр
        P1 = 1/s;
        P2 = -2/s;
        P3 = 1/s;
        P1 = syslin('c', P1);
        P2 = syslin('c', P2);
        P3 = syslin('c', P3);
        
        //АЧХ и ФЧХ входного одиночного импульса
        Values1 = freq(numer(P1), denom(P1), %i*w);
        Real1 = real(Values1);
        Imag1 = imag(Values1);
        
        Values2 = freqd(numer(P2), denom(P2), tau/2, %i*w);
        Real2 = real(Values2);
        Imag2 = imag(Values2);
        
        Values3 = freqd(numer(P3), denom(P3), tau, %i*w);
        Real3 = real(Values3);
        Imag3 = imag(Values3);
        
        Real = (Real1 + Real2 + Real3);
        Imag = (Imag1 + Imag2 + Imag3);
        
        //АЧХ
        A = sqrt(Real.^2 + Imag.^2);
        plot2d(w, A);
        
        //Находим полосу пропускания цепи
        Level = 0.1*max(A);
        xpts = [0 max(w)];
        ypts = [Level Level];
        plot2d(xpts, ypts);
        halt;
        
        //ФЧХ
        for i = 1:1:3001
            if Real > 0
                Fr(i) = atan(Imag(i)/Real(i));
            else
                Fr(i) = atan(Imag(i)/Real(i)) + %pi;
            end;
        end;
        
        plot(w, Fr);
        halt; 
        
        //АЧХ и ФЧХ реакции
        P1 = P1*Hs;
        P2 = P2*Hs;
        P3 = P3*Hs;
        
        Values1 = freq(numer(P1), denom(P1), %i*w);
        Real1 = real(Values1);
        Imag1 = imag(Values1);
        
        Values2 = freqd(numer(P2), denom(P2), tau/2, %i*w);
        Real2 = real(Values2);
        Imag2 = imag(Values2);
        
        Values3 = freqd(numer(P3), denom(P3), tau, %i*w);
        Real3 = real(Values3);
        Imag3 = imag(Values3);
        
        Real = (Real1 + Real2 + Real3);
        Imag = (Imag1 + Imag2 + Imag3);
        
        //АЧХ и ФЧХ входного одиночного импульса
        //АЧХ
        A = sqrt(Real.^2 + Imag.^2);
        plot2d(w, A);
        
        //Находим полосу пропускания цепи
        Level = 0.1*max(A);
        xpts = [0 max(w)];
        ypts = [Level Level];
        plot2d(xpts, ypts);
        halt;
        
        //ФЧХ
        for i = 1:1:3001
            if Real > 0
                Fr(i) = atan(Imag(i)/Real(i));
            else
                Fr(i) = atan(Imag(i)/Real(i)) + %pi;
            end;
        end;
        
        plot(w, Fr);
        halt; 
        
        //Сдвиг во временной области
        P2 = iodelay(P2, tau/2);
        P3 = iodelay(P3, tau);
        R = [P1; P2; P3];
        break;
    otherwise
        R = 0;
        error('Ошибка! Неопределённый тип входного одиночного импульса.');
    end;
    
endfunction
