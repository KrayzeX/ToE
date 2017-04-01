//Главный модуль
//В качестве параметров принимает контурную матрицу, матрицу сопротивлений ветвей,
//матрицу ЭДС источников, матрицу источников тока. Возвращает матрицу найденных
//контурных токов.
function LoopCurrent = MainUnit(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix)
    
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
    
    exec 'exec 'C:\maxima-5.39.0\overload\builder.sce'';
    exec 'Matrix_Resistance.sci';
    exec 'FindLoopEMF.sci';
    exec 'FindUnknownLoopCurrent.sci';
    
    //Преобразовываем ИТ
    
    //Вычисляем матрицу сопротивлений
    Resistances = Matrix_Resistance(LoopMatrix, BranchResistance);
    
    //Находим матрицу-столбец сумм напряжений источников напряжений контуров
    EMFSumm = FindLoopEMF(LoopMatrix, EMFMatrix);
    
    //Решаем систему уравнений
    LoopCurrent = FindUnknownLoopCurrent(Resistances, EMFSumm);
endfunction
