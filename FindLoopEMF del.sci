//Марчук Л.Б. 5307 подгруппа 3
//Данный модуль принимает на вход контурную матрицу
//и матрицу-столбец источников напряжений ветвей;
//возвращает матрицу-столбец сумм напряжений источников напряжений контуров.
function [result] = FindLoopEMF(LoopMatrix, EMFBranches)
    [rows columns] = size(EMFBranches);
    
    /*if columns ~= 1 then
        error('Ошибка! Второй параметр должен представлять собой матрицу-столбец.');
    end;*/
    
    Temp = rows;
    [rows columns] = size(LoopMatrix);
    
    if Temp ~= columns then
        error('Ошибка! Число ветвей в контурной матрице должно совпадать с числом элементов матрицы-столбца источников напряжений ветвей.');
    end;
    
    //Для каждого контура суммируем произведения элементов контура на ЭДС соответствующей ветви
    result = [];
    
    for i=1:1:rows
        Loop = [0 0 0];
        
        for j=1:1:columns
            for k=1:1:3
                Loop(1, k) = Loop(1, k) + LoopMatrix(i, j) * EMFBranches(j, k);
            end;
        end;
        
        result = [result; Loop];
    end;
    
    //result = result';
     
endfunction
