//Марчук Л.Б. 5307 подгруппа 3
//Данный модуль принимает на вход контурную матрицу, матрицу сопротивлений ветвей,
//матрицу ЭДС источников, матрицу источников тока, контурные токи,
//матрицу коэффициентов уравнений состояния и номер исследуемой ветви;
//возвращает матрицу коэффициентов уравнений состояния для исследуемой ветви.
function [result] = FindCD(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix, Currents, System, Branch)
    [rows columns] = size(System);
    
    if rows ~= 2 || columns ~= 3 then
        error('Ошибка! Матрица коэффициентов уравнений состояния должна быть размером 2x3.');
    end;
    
    [rows columns] = size(LoopMatrix);
    
    //Определяем тип реакции (1 - ток, 2 - напряжение)
    ResponseType = 0;
    
    for i=1:1:rows
        if EMFMatrix(i, 3) ~= 0
            ResponseType = 2;
            break;
        end;
    end;
    
    if ResponseType == 0 then
        for i=1:1:rows
            if CurrentMatrix(i, 3) ~= 0
                ResponseType = 1;
                break;
            end;
        end;
    end;
    
    //Определяем реакцию
    Response = [0 0 0];
    
    //Ищем ток
    //Ищем контура, в которые входит исследуемая ветвь и суммируем токи
    for i=1:1:rows
        if LoopMatrix(i, Branch) ~= 0
            for j=1:1:3
                Response(1, j) = Response(1, j) + LoopMatrix(i, Branch)*Currents(i, j);
            end;
        end;
    end;
    
    if ResponseType == 2
        //Ищем напряжение
        Response = Response*BranchResistance(Branch, Branch);
    end;
    
    //Находим матрицу коэффициентов реакции
    //Находим коэффициенты при u1/i1
    result = zeros(2, 3);
    for i = 1:1:2
        for j = 1:1:3
            result(i, j) = System(i, j) * Response(1, j);
        end;
    end;
endfunction
