//Марчук Л.Б. 5307 подгруппа 3
//Данный модуль принимает на вход контурную матрицу, матрицу сопротивлений ветвей,
//матрицу ЭДС источников, матрицу источников тока, контурные токи,
//решение системы уравнений состояния в виде
//[i1/u1 A1 A2 A3 A4] и номер исследуемой ветви;
//возвращает переходную характеристику выходной реакции h1(t)
//в виде [i/u A1 A2].
function [Steady, A1, A2] = FindTransientResponse(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix, Currents, Solution, Branch)
    [rows columns] = size(Solution);
    
    if rows ~=1 || columns ~=6 then
        error('Ошибка! Матрица решения системы уравнений состояния должна быть размером 1x5.');
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
        
    //Вычисляем постоянную составляющую
    Steady = Response(1, 3);
    Steady = Steady + Response(1, 1)*Solution(1, 1);
    Steady = Steady + Response(1, 2)*Solution(1, 2);
        
    //Находим коэффициенты интегрирования
    A1 = Response(1, 1)*Solution(1, 3);
    A2 = Response(1, 1)*Solution(1, 4);
    A1 = A1 + Response(1, 2)*Solution(1, 5);
    A2 = A2 + Response(1, 2)*Solution(1, 6); 
endfunction

