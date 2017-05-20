//Данный модуль получает матрицу сопротивлений из поля objs структуры scicos_diagram
function [result] = GetResistances(lst)
    //Номер очередного найденного блока
    BlockNumber = 0;
    
    //Число элементов в списке
    Count = length(lst);
    
    result = [];    
    for i=1:1:Count
        if type(lst(i)) == scicos_block
            BlockNumber = BlockNumber + 1;
            
            if lst(i).gui == "Resistor"
                result(BlockNumber, BlockNumber) = 0;
            end;
            
        end;
    end;
endfunction
