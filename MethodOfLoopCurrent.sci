//Модуль, реализующий метод контурных токов
//В качестве параметров принимает контурную матрицу, матрицу сопротивлений ветвей,
//матрицу ЭДС источников, матрицу источников тока. Возвращает матрицу-столбец контурных токов.
//УПРОЩЁННЫЙ МКТ - ТОЛЬКО ДЛЯ ЦЕПЕЙ С ОДНИМ ИТ

//В данном модуле введено представление для ИТ и ИН в виде [uc1 uc2 u1] ([il1 il2 i1]),
//где u1/i1 - воздействие, uc1/il1 - реактивный элемент с меньшим номером ветви,
//uc2/il2 - реактивный элемент с большим номером ветви.
function LoopCurrent = MethodOfLoopCurrent(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix)
    exec 'Matrix_Resistance.sci';
    exec 'FindLoopEMF.sci';
    exec 'FindUnknownLoopCurrent.sci';
    
    //Вычисляем матрицу сопротивлений контуров
    Resistances = Matrix_Resistance(LoopMatrix, BranchResistance);
    
    //Находим матрицу-столбец сумм напряжений источников напряжений контуров
    EMFSumm = FindLoopEMF(LoopMatrix, EMFMatrix);
    
    //Проверяем, есть ли в цепи ИТ
    [rows columns] = size(CurrentMatrix);
    
    //Число контуров
    [Loops columns] = size(Resistances);
    
    Module = [0 0 0];
    CurrentBranch = 0;
    for i=1:1:rows
        for j=1:1:3
            Module(1, j) = Module(1, j) + abs(CurrentMatrix(i, j));
            
            if CurrentMatrix(i, j) ~= 0
                CurrentBranch = i;
            end;
        end;
    end;
    
    disp(Module);
    if Module == [0 0 0]
        //Цепь без ИТ
        //Решаем систему уравнений
        LoopCurrent = FindUnknownLoopCurrent(Resistances, EMFSumm);
    else
        //Цепь с ИТ
        LoopCurrent = zeros(Loops, 3);
        
        //Ищем контур, в котором найден ИТ
        RequiredLoop = 1;        
        for i=1:1:Loops
            if LoopMatrix(i, CurrentBranch) == 1
                RequiredLoop = i;
                break;
            end;
        end;
        
        //Третий контурный ток протекает через непреобразованный ИТ
        //и совпадает с ним по направлению
        LoopCurrent(RequiredLoop, :) = Module;
        
        //Находим взаимное сопротивление третьего и первого контуров
        R13 = 0;
        Choose = 1;
        if(Loops > 1)
            for i=1:1:2
                if i == RequiredLoop
                    continue;
                end;
                R13 = Resistances(RequiredLoop, i);
                Choose = i;
                break;
            end;
        end;
        
        //Находим взаимное сопротивление третьего и второго контуров
        if Loops > 2
            R23 = 0;
            for i=(Choose + 1):1:Loops
                if i == RequiredLoop
                    continue;
                end;
                R23 = Resistances(RequiredLoop, i);
                break;
            end;
        end;
        
        //Выбрасываем из матрицы сопротивлений строку и столбец
        //с номером контура, в котором ИТ
        Resistances(RequiredLoop, :) = [];
        Resistances(:, RequiredLoop) = [];
        
        //Выбрасываем из матрицы-столбца сумм напряжений источников напряжений 
        //контуров контур с ИТ
        EMFSumm(RequiredLoop, :) = [];
        
        //Формируем правую часть уравнения
        if Loops > 2
            Temp = [R13*Module; R23*Module];
        else
            Temp = [R13*Module];
        end;
        EMFSumm = EMFSumm - Temp;
        
        if(Loops > 1)
            //Решаем систему уравнений
            Temp = FindUnknownLoopCurrent(Resistances, EMFSumm);
            
            //Добавляем ток непреобразованного ИТ
            //Переформировываем матрицу
            if Loops == 2
                if RequiredLoop == 2
                    LoopCurrent = [Temp; LoopCurrent(2, :)];
                else
                    LoopCurrent = [LoopCurrent(1, :); Temp];
                end;
            else
                if RequiredLoop == 1
                    LoopCurrent = [LoopCurrent(1, :); Temp];
                else
                    if RequiredLoop == 2
                        LoopCurrent = [Temp(1, :); LoopCurrent(2, :); Temp(2, :)];
                    else
                        LoopCurrent = [Temp; LoopCurrent(3, :)];
                    end;
                end;
            end;
        end;
    end;
endfunction
