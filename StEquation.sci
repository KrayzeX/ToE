//Решетина Алла, подгруппа 3, 5307
//Данный модуль принимает на вход контурную матрицу, матрицу сопротивлений, матрицу
//ЭДС источников, матрицу источников тока, типы реактивных элементов 
//(0 - два C-элемента, 1 - один C-элемент и один L-элемент, 2 - два L-элемента),
//значения реактивных элементов; возвращает матрицу коэффициентов при [react1; react2]
//и контурные токи.

function [result] = StEquation(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix, ReactType, ValueBranch1, ValueBranch2)
    exec 'MethodOfLoopCurrent.sci';
    exec 'RestoreLoopMatrix.sci';
    exec 'Matrix_Resistance.sci';
    
    result = zeros(2, 3);
    [TRows columns] = size(LoopMatrix);
    
    //Используем комбинацию МН и МКТ  
    //ИН - КЗ, ИТ - ХХ
    //Оставляем сначала ИН/ИТ
    TempLoop = LoopMatrix;
    TempEMF = EMFMatrix;
    TempCurrent = CurrentMatrix;
    TempBranchResistance = BranchResistance;
    
    //Номера "нулевых" контуров
    ZeroLoops = [];
    rows = TRows;
    
    //Удаляем из цепи ёмкости/индуктивности
    for i=1:1:columns
        TempEMF(i, 1) = 0;
        TempEMF(i, 2) = 0;
        
        if TempCurrent(i, 1) ~= 0 || TempCurrent(i, 2) ~= 0
            //Удаляем ИТ - удаляем контур, его содержащий
            for k=rows:-1:1
                if TempLoop(k, i) ~= 0
                    ZeroLoops = [ZeroLoops k];
                    TempLoop(k, :) = [];
                    rows = rows - 1;
                end;
            end;            
            TempCurrent(i, :) = 0;
        end;
    end;
    
    //Первый шаг МН
    //Суммируемые контурные токи
    Summ = 0;
    if size(TempLoop) ~= 0 then
        Summ = MethodOfLoopCurrent(TempLoop, TempBranchResistance, TempEMF, TempCurrent);
        
        //Восстанавливаем "нулевые" контура
        ZeroLoops = gsort(ZeroLoops, 'c', 'i');
        Summ = RestoreLoopMatrix(Summ, ZeroLoops, TRows);
    else
        Summ = zeros(TRows, 3);
    end;
    
    //Второй шаг МН - ищем первый реактивный элемент
    TempLoop = LoopMatrix;
    TempEMF = EMFMatrix;
    TempCurrent = CurrentMatrix;
    TempBranchResistance = BranchResistance;
    ProcessedBranch = 1;
    
    //Номера "нулевых" контуров
    ZeroLoops = [];
    rows = TRows;
    
    //Удаляем из цепи ИН/ИТ
    for i=1:1:columns
        TempEMF(i, 3) = 0;
        
        if TempCurrent(i, 3) ~= 0            
            //Удаляем ИТ - удаляем контур, его содержащий
            for k=rows:-1:1
                if TempLoop(k, i) ~= 0
                    ZeroLoops = [ZeroLoops k];
                    TempLoop(k, :) = [];
                    rows = rows - 1;
                end;
            end;   
            TempCurrent(i, :) = 0;
        end;
        
        if TempEMF(i, 1) ~= 0 || TempEMF(i, 2) ~= 0
            //Нашли конденсатор
            //Удаляем из цепи всё остальное
            for j=1:1:columns
                if TempCurrent(j, 1) ~= 0 || TempCurrent(j, 2) ~= 0 || TempCurrent(j, 3) ~= 0
                    //Удаляем ИТ - удаляем контур, его содержащий
                    for k=rows:-1:1
                        if TempLoop(k, j) ~= 0
                            ZeroLoops = [ZeroLoops k];
                            TempLoop(k, :) = [];
                            rows = rows - 1;
                        end;
                    end;   
                end;
                TempCurrent(j,:) = 0;
            end;
            
            for j=(i + 1):1:columns
                TempEMF(j,:) = 0;
            end;            
            ProcessedBranch = i;
        end;        
        
        if TempCurrent(i, 1) ~= 0 || TempCurrent(i, 2) ~= 0
            //Нашли индуктивность
            //Удаляем из цепи всё остальное
            for j=1:1:columns
                TempEMF(j,:) = 0;
            end;
            
            for j=1:1:columns
                if j == i
                    continue;
                end;
                
                if TempCurrent(j, 2) ~= 0 || TempCurrent(j, 1) ~= 0
                    //Удаляем ИТ - удаляем контур, его содержащий
                    for k=rows:-1:1
                        if TempLoop(k, j) ~= 0
                            ZeroLoops = [ZeroLoops k];
                            TempLoop(k, :) = [];
                            rows = rows - 1;
                        end;
                    end;   
                end;                
                TempCurrent(j,:) = 0;
            end;
            ProcessedBranch = i;
        end;   
    end;
    
    Temp = 0;
    if size(TempLoop) ~= 0 then
        Temp = MethodOfLoopCurrent(TempLoop, TempBranchResistance, TempEMF, TempCurrent);
        
        //Восстанавливаем "нулевые" контура
        ZeroLoops = gsort(ZeroLoops, 'c', 'i');
        Temp = RestoreLoopMatrix(Temp, ZeroLoops, TRows);
    else
        Temp = zeros(TRows, 3);
    end;
    
    //Суммируемые контурные токи
    Summ = Summ + Temp;
    
    //Третий шаг МН - ищем второй реактивный элемент
    TempLoop = LoopMatrix;
    TempEMF = EMFMatrix;
    TempCurrent = CurrentMatrix;
    TempBranchResistance = BranchResistance;
    
    //Номера "нулевых" контуров
    ZeroLoops = [];
    rows = TRows;
    
    //Находим номер контура с обработанным реактивным элементом (если индуктивность)
    if TempCurrent(ProcessedBranch, 3) ~= 0 || TempCurrent(ProcessedBranch, 2) ~= 0 || TempCurrent(ProcessedBranch, 1) ~= 0
        //Удаляем ИТ - удаляем контур, его содержащий
            for k=rows:-1:1
                if TempLoop(k, ProcessedBranch) ~= 0
                    ZeroLoops = [ZeroLoops k];
                end;
            end;   
    end;     
    
    //Удаляем из цепи ИН/ИТ
    for i=1:1:columns
        TempEMF(i, 3) = 0;
        
        if TempCurrent(i, 3) ~= 0
            //Удаляем ИТ - удаляем контур, его содержащий
            for k=rows:-1:1
                if TempLoop(k, i) ~= 0
                    ZeroLoops = [ZeroLoops k];
                    TempLoop(k, :) = [];
                    rows = rows - 1;
                end;
            end;   
            TempCurrent(i, :) = 0;
        end;
    end;
    
    //Удаляем обработанный реактивный элемент
    TempEMF(ProcessedBranch, :) = 0;
    if TempCurrent(ProcessedBranch, 3) ~= 0 || TempCurrent(ProcessedBranch, 2) ~= 0 || TempCurrent(ProcessedBranch, 1) ~= 0
        //Удаляем ИТ - удаляем контур, его содержащий
            for k=rows:-1:1
                if TempLoop(k, ProcessedBranch) ~= 0
                    //ZeroLoops = [ZeroLoops k];
                    TempLoop(k, :) = [];
                    rows = rows - 1;
                end;
            end;   
        TempCurrent(ProcessedBranch, :) = 0;
    end; 
    
    Temp = 0;
    if size(TempLoop) ~= 0 then
        Temp = MethodOfLoopCurrent(TempLoop, TempBranchResistance, TempEMF, TempCurrent);
        
        //Восстанавливаем "нулевые" контура
        ZeroLoops = gsort(ZeroLoops, 'c', 'i');
        Temp = RestoreLoopMatrix(Temp, ZeroLoops, TRows);
    else
        Temp = zeros(TRows, 3);
    end;
    
    //Суммируемые контурные токи
    Summ = Summ + Temp;    
    rows = TRows;
    
    //Если реактивный элемент - конденсатор, ищем ток на нём,
    //иначе - ищем напряжение на нём
    if ReactType == 0 then
        //Два C-элемента
        //Ищем ветвь с первым C-элементом
        Branch = 1;
        while EMFMatrix(Branch, 1) == 0
            Branch = Branch + 1;
        end;
        
        //Ищем ток на первом C-элементе
        ic = [0 0 0];
        for i=1:1:rows
            for j=1:1:3
                ic(1, j) = ic(1, j) + Summ(i, j)*abs(LoopMatrix(i, Branch));
            end;
        end;
        
        //Если конденсатор входит в контурную матрицу с минусом,
        //то переполюсовка не нужна
        for i=1:1:rows
            if LoopMatrix(i, Branch) > 0
                ic = -ic; 
                break;
            end;
        end;
        
        result(1, :) = ic(1, :);
        
        //Ищем ветвь со вторым C-элементом
        Branch = 1;
        while EMFMatrix(Branch, 2) == 0
            Branch = Branch + 1;
        end;
        
        //Ищем ток на втором C-элементе
        ic = [0 0 0];
        for i=1:1:rows
            for j=1:1:3
                ic(1, j) = ic(1, j) + Summ(i, j)*abs(LoopMatrix(i, Branch));
            end;
        end;
        
        //Если конденсатор входит в контурную матрицу с минусом,
        //то переполюсовка не нужна
        for i=1:1:rows
            if LoopMatrix(i, Branch) > 0
                ic = -ic; 
                break;
            end;
        end;
        
        result(2, :) = ic(1, :);
    end;
    
    if ReactType == 1 then
        //C-элемент и L-элемент
        //Ищем ветвь с C-элементом
        Branch = 1;
        while EMFMatrix(Branch, 1) == 0 && EMFMatrix(Branch, 2) == 0
            Branch = Branch + 1;
        end;
        
        //Ищем ток на C-элементе
        ic = [0 0 0];
        for i=1:1:rows
            for j=1:1:3
                ic(1, j) = ic(1, j) + Summ(i, j)*abs(LoopMatrix(i, Branch));
            end;
        end;
        
        //Если конденсатор входит в контурную матрицу с минусом,
        //то переполюсовка не нужна
        for i=1:1:rows
            if LoopMatrix(i, Branch) > 0
                ic = -ic; 
                break;
            end;
        end;
        
        result(1, :) = ic(1, :);
        
        //Ищем ветвь с L-элементом
        Branch = 1;
        while CurrentMatrix(Branch, 1) == 0 && CurrentMatrix(Branch, 2) == 0
            Branch = Branch + 1;
        end;
        
        //Ищем контур с L-элементом
        LLoop = 1;
        while LoopMatrix(LLoop, Branch) == 0
            LLoop = LLoop + 1;
        end;
        
        //Ищем напряжение на L-элементе
        //Ищем напряжение как сумму напряжений на сопротивлениях, входящих
        //в контур с катушкой, путём умножения сопротивления на сумму контурных
        //токов, протекающих через него
        ul = zeros(1, 3);
        
        //Проходим в цикле по всем сопротивлениям контура
        for i=1:1:columns
            if BranchResistance(i, i) ~= 0 && LoopMatrix(LLoop, i) ~= 0 && i ~= Branch
                //Если найденное сопротивление входит в контур
                //Находим, в какой ещё контур входит сопротивление
                OtherLoop = 0;
                for j=1:1:rows
                    if j == LLoop
                        continue;
                    end;
                    
                    if LoopMatrix(j, i) ~= 0
                        OtherLoop = j;
                    end;
                end;
                
                //Находим ток на сопротивлении
                Cur = zeros(1, 3);
                for j=1:1:3
                    if OtherLoop ~= 0
                        Cur(1, j) = Cur(1, j) + Summ(LLoop, j)*LoopMatrix(LLoop, i) + Summ(OtherLoop, j)*LoopMatrix(OtherLoop, i);
                    else
                        Cur(1, j) = Cur(1, j) + Summ(LLoop, j)*LoopMatrix(LLoop, i);
                    end;
                end;
                
                //Находим напряжение на сопротивлении
                ul = ul + BranchResistance(i, i)*Cur;
            end;
            
            //Если нашли ИН
            if LoopMatrix(LLoop, i) ~= 0 && i ~= Branch && (EMFMatrix(i, 1) ~=0 || EMFMatrix(i, 2) ~=0 || EMFMatrix(i, 3) ~=0)
                //Учитываем найденный ИН
                for j=1:1:3
                    ul(1, j) = ul(1, j) + LoopMatrix(LLoop, i)*EMFMatrix(i, j);
                end;
            end;
        end;
        result(2, :) = ul(1, :);
    end;
    
    if ReactType == 2 then
        //Два L-элемента
        //Ищем ветвь с первым L-элементом
        Branch = 1;
        while CurrentMatrix(Branch, 1) == 0
            Branch = Branch + 1;
        end;
        
        //Ищем контур с L-элементом
        LLoop = 1;
        while LoopMatrix(LLoop, Branch) == 0
            LLoop = LLoop + 1;
        end;
        
        //Ищем напряжение на L-элементе
        //Ищем напряжение как сумму напряжений на сопротивлениях, входящих
        //в контур с катушкой, путём умножения сопротивления на сумму контурных
        //токов, протекающих через него
        ul = zeros(1, 3);
        
        //Проходим в цикле по всем сопротивлениям контура
        for i=1:1:columns
            if BranchResistance(i, i) ~= 0 && LoopMatrix(LLoop, i) ~= 0 && i ~= Branch
                //Если найденное сопротивление входит в контур
                //Находим, в какой ещё контур входит сопротивление
                OtherLoop = 0;
                for j=1:1:rows
                    if j == LLoop
                        continue;
                    end;
                    
                    if LoopMatrix(j, i) ~= 0
                        OtherLoop = j;
                    end;
                end;
                
                //Находим ток на сопротивлении
                Cur = zeros(1, 3);
                for j=1:1:3
                    if OtherLoop ~= 0
                        Cur(1, j) = Cur(1, j) + Summ(LLoop, j)*LoopMatrix(LLoop, i) + Summ(OtherLoop, j)*LoopMatrix(OtherLoop, i);
                    else
                        Cur(1, j) = Cur(1, j) + Summ(LLoop, j)*LoopMatrix(LLoop, i);
                    end;
                end;
                
                //Находим напряжение на сопротивлении
                ul = ul + BranchResistance(i, i)*Cur;
            end;
            
            //Если нашли ИН
            if LoopMatrix(LLoop, i) ~= 0 && i ~= Branch && (EMFMatrix(i, 1) ~=0 || EMFMatrix(i, 2) ~=0 || EMFMatrix(i, 3) ~=0)
                //Учитываем найденный ИН
                for j=1:1:3
                    ul(1, j) = ul(1, j) + LoopMatrix(LLoop, i)*EMFMatrix(i, j);
                end;
            end;
        end;
        
        result(1, :) = ul(1, :);
        
        //Ищем ветвь со вторым L-элементом
        Branch = 1;
        while CurrentMatrix(Branch, 2) == 0
            Branch = Branch + 1;
        end;
        
        //Ищем контур с L-элементом
        LLoop = 1;
        while LoopMatrix(LLoop, Branch) == 0
            LLoop = LLoop + 1;
        end;
        
        //Ищем напряжение на L-элементе
        //Ищем напряжение как сумму напряжений на сопротивлениях, входящих
        //в контур с катушкой, путём умножения сопротивления на сумму контурных
        //токов, протекающих через него
        ul = zeros(1, 3);
        
        //Проходим в цикле по всем сопротивлениям контура
        for i=1:1:columns
            if BranchResistance(i, i) ~= 0 && LoopMatrix(LLoop, i) ~= 0 && i ~= Branch
                //Если найденное сопротивление входит в контур
                //Находим, в какой ещё контур входит сопротивление
                OtherLoop = 0;
                for j=1:1:rows
                    if j == LLoop
                        continue;
                    end;
                    
                    if LoopMatrix(j, i) ~= 0
                        OtherLoop = j;
                    end;
                end;
                
                //Находим ток на сопротивлении
                Cur = zeros(1, 3);
                for j=1:1:3
                    if OtherLoop ~= 0
                        Cur(1, j) = Cur(1, j) + Summ(LLoop, j)*LoopMatrix(LLoop, i) + Summ(OtherLoop, j)*LoopMatrix(OtherLoop, i);
                    else
                        Cur(1, j) = Cur(1, j) + Summ(LLoop, j)*LoopMatrix(LLoop, i);
                    end;
                end;
                //Находим напряжение на сопротивлении
                ul = ul + BranchResistance(i, i)*Cur;
            end;
            
            //Если нашли ИН
            if LoopMatrix(LLoop, i) ~= 0 && i ~= Branch && (EMFMatrix(i, 1) ~=0 || EMFMatrix(i, 2) ~=0 || EMFMatrix(i, 3) ~=0)
                //Учитываем найденный ИН
                for j=1:1:3
                    ul(1, j) = ul(1, j) + LoopMatrix(LLoop, i)*EMFMatrix(i, j);
                end;
            end;
        end;
        
        result(2, :) = ul(1, :);
    end;
    
    result(1,:) = result(1,:)./ValueBranch1;
    result(2,:) = result(2,:)./ValueBranch2;    
endfunction
