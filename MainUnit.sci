//Главный модуль
//В качестве параметров принимает контурную матрицу, матрицу сопротивлений ветвей,
//матрицу ЭДС источников, матрицу источников тока. Возвращает матрицу найденных
//контурных токов.
function LoopCurrent = MainUnit(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix)
    [rows columns] = size(BranchResistance);
    
    if columns ~= 1 then
        error('Ошибка! Второй параметр должен представлять собой матрицу-столбец.');
    end;
    
    [rows columns] = size(EMFMatrix);
    
    if columns ~= 1 then
        error('Ошибка! Третий параметр должен представлять собой матрицу-столбец.');
    end;
    
    [rows columns] = size(CurrentMatrix);
    
    if columns ~= 1 then
        error('Ошибка! Четвёртый параметр должен представлять собой матрицу-столбец.');
    end;
    
    //Проверка соответсвия размерностей матриц
    
    //Преобразовываем ИТ
    
    //Вычисляем матрицу сопротивлений
    Resistances = Matrix_Resistance(LoopMatrix, BranchResistance);
    
    //Находим матрицу-столбец сумм напряжений источников напряжений контуров
    EMFSumm = FindLoopEMF(LoopMatrix, EMFMatrix);
    
    //Решаем систему уравнений
    LoopCurrent = Resistances' * EMFSumm;
endfunction
