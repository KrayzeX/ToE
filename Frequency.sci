//Марчук Л.Б. 5307 подгруппа 3
//Модуль построения графиков АЧХ и ФЧХ
function [] = Frequency(Hs)
    //S = jw
    //Исследуемый отрезок частот
    w = 0:0.01:30;
    Values = freq(numer(Hs), denom(Hs), %i*w);
    
    //АЧХ
    A = sqrt(real(Values)^2 + imag(Values)^2);
    plot2d(w, A);
    
    //Находим полосу пропускания цепи
    Level = 0.707*max(A);
    xpts = [0 max(w)];
    ypts = [Level Level];
    plot2d(xpts, ypts);
    halt;
    
    //ФЧХ
    for i = 1:1:3001
        if real(Values( i)) > 0
            Fr(i) = atan(imag(Values(i))/real(Values(i)));
        else
            if imag(Values(i)) >= 0
                Fr(i) = atan(imag(Values(i))/real(Values(i))) + %pi;
            else
                Fr(i) = atan(imag(Values(i))/real(Values(i))) - %pi;
            end;
        end;
    end;

    plot2d(w, Fr);
    halt;    
endfunction
