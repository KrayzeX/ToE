//Марчук Л.Б. 5307 подгруппа 3
//Данный модуль принимает на вход контурную матрицу, матрицу сопротивлений ветвей,
//матрицу ЭДС источников, матрицу источников тока, контурные токи,
//матрицу коэффициентов уравнений состояния и номер исследуемой ветви;
//возвращает матрицу коэффициентов уравнений состояния для исследуемой ветви.
function [result] = FindCD(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix, Currents, Branch)
    
    disp(Currents);
    halt;
    
    [rows columns] = size(LoopMatrix);
    result = zeros(1, 3);
    
    for g = 1:1:3
        for i = 1:1:columns
            if g < 3 
                if EMFMatrix(i, g) ~= 0
                    //Найден ИН - находим ток
                    //Ищем контура, в которые входит исследуемая ветвь и суммируем токи
                    for k=1:1:rows
                        if LoopMatrix(k, Branch) ~= 0
                            result(1, g) = result(1, g) + LoopMatrix(k, Branch)*Currents(k, g);
                        end;
                    end;
                    break;
                else
                    if CurrentMatrix(i, g) ~= 0
                        //Найден ИТ - находим напряжение
                        //Ищем контура, в которые входит исследуемая ветвь и суммируем токи
                        for k=1:1:rows
                            if LoopMatrix(k, Branch) ~= 0
                                result(1, g) = result(1, g) + LoopMatrix(k, Branch)*Currents(k, g);
                            end;
                        end;
                        
                        //Ищем напряжение
                        result(1, g) = result(1, g) * BranchResistance(Branch, Branch);
                        break;
                    end;
                end;
            else
                if CurrentMatrix(i, g) ~= 0
                    //Найден ИТ - находим ток
                    //Ищем контура, в которые входит исследуемая ветвь и суммируем токи
                    for k=1:1:rows
                        if LoopMatrix(k, Branch) ~= 0
                            result(1, g) = result(1, g) + LoopMatrix(k, Branch)*Currents(k, g);
                        end;
                    end;
                    break;
                else
                    if EMFMatrix(i, g) ~= 0
                        //Найден ИН - находим напряжение
                        //Ищем контура, в которые входит исследуемая ветвь и суммируем токи
                        for k=1:1:rows
                            if LoopMatrix(k, Branch) ~= 0
                                result(1, g) = result(1, g) + LoopMatrix(k, Branch)*Currents(k, g);
                            end;
                        end;
                        
                        //Ищем напряжение
                        result(1, g) = result(1, g) * BranchResistance(Branch, Branch);
                        break;
                    end;
                end;
            end;
        end;
    end;
endfunction
