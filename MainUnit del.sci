//Главный модуль
//В качестве параметров принимает контурную матрицу, матрицу сопротивлений ветвей,
//матрицу ЭДС источников, матрицу источников тока, 
//типы реактивных элементов и значения реактивных элементов.
function [] = MainUnit(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix, ReactType, ValueBranch1, ValueBranch2)
    
    //Проверка соответсвия размерностей матриц
    //Считаем число ветвей по контурной матрице
    [rows branches] = size(LoopMatrix);
    
    [rows columns] = size(BranchResistance);
    
    if columns ~= rows then
        error('Ошибка! Второй параметр должен представлять собой квадратную матрицу.');
    end;
    
    if columns ~= branches then
        error('Ошибка! Число ветвей во всех матрицах должно совпадать.');
    end;
    
    [rows columns] = size(EMFMatrix);
    
    if columns ~= 1 then
        error('Ошибка! Третий параметр должен представлять собой матрицу-столбец.');
    end;
    
    if rows ~= branches then
        error('Ошибка! Число ветвей во всех матрицах должно совпадать.');
    end;
    
    [rows columns] = size(CurrentMatrix);
    
    if columns ~= 1 then
        error('Ошибка! Четвёртый параметр должен представлять собой матрицу-столбец.');
    end;
    
    if rows ~= branches then
        error('Ошибка! Число ветвей во всех матрицах должно совпадать.');
    end;
    
    exec 'MethodOfLoopCurrent.sci';
    exec 'ForcedComponents.sci';
    exec 'OwnFrequencies.sci';
    exec 'SolveSystem.sci';
    
    //Применяем МКТ
    Currents = MethodOfLoopCurrent(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix);
    
    //ИСПРАВИТЬ ВЫЗОВЫ ФУНКЦИЙ    
    //Находим систему уравнений состояния электрической цепи
    System = [0 0; 0 0];
    
    //Находим собственные частоты цепи
    [p1 p2] = OwnFrequencies(System);
    
    //Находим решение системы уравнения состояния электрической цепи
    [Steady, A1, A2, A3, A4, Type] = SolveSystem(System, p1, p2);
    
    //Находим переходную характеристику
    
    //Строим график
endfunction
