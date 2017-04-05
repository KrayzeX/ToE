//Модуль, реализующий метод контурных токов
function LoopCurrent = MethodOfLoopCurrent(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix)
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
