//Чистяков А. 5307
//Данный модуль принимает на вход строку [Steady A1 A2 p1 p2 Type],
//где Steady - свободная составляющая, A1 и A2 - постоянные интегрирования,
//p1 и p2 - корни характеристического многочлена, Type - тип решения:
//1 - вещественные разные корни, 2 - вещественные кратные корни, 3 - комплексные корни; 
//не возвращает ничего; 
//строит график переходной характеристики h1(t) выходной реакции.
function [] = PlotTransientResponse(Steady, A1, A2, p1, p2, Type)
        
    //До какого момента времени строим график
    htime = 50 * max(abs(real(p1)), abs(real(p2)));
    Build = [];
    x = [];
    if Type == 1 then
        //Вещественные разные корни
        for t = 0:0.1:htime
            x = [t x];
            Build = [Steady + A1*exp(p1*t) + A2*exp(p2*t) Build];
        end;
    end;
    
    if Type == 2 then
        //Вещественные кратные корни
        for t = 0:0.1:htime
            x = [t x];
            Build = [Steady + A1*exp(p1*t) + A2*t*exp(p1*t) Build];
        end; 
    end;
    
    if Type == 3 then
        //Комплексно-сопряжённые корни
        for t = 0:0.1:htime
            x = [t x];
            Build = [Steady + A1*exp(real(p1)*t)*cos(abs(imag(p1))*t) + A2*exp(real(p1)*t)*sin(abs(imag(p1))*t) Build];
        end;
    end;
        
    subplot(2,1,1); 
    plot2d(x, Build);
    xtitle('График переходной харатеристики цепи ', 't', 'h1(t)');
    
endfunction
