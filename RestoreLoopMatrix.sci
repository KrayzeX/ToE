//Данный модуль восстанавливает в контурной матрице удалённые контура.
function [result] = RestoreLoopMatrix(LoopMatrix, ZeroLoops, Loops)
    [rows columns] = size(ZeroLoops);
    if rows ~= 0 then
        if Loops == 1
            //Был единственный контур - удалили его
            result = zeros(1, 3);
        else
            if Loops == 2
                //Было два контура
                if rows == columns && rows == 1 then
                    //Удалён один контур
                    if ZeroLoops == 1
                        //Удалён первый контур
                        result = [0 0 0; LoopMatrix];
                    else
                        //Удалён второй контур
                        result = [LoopMatrix; 0 0 0];
                    end;
                else
                    //Удалены оба контура
                    result = zeros(2, 3);
                end;
            else
                //Было три контура
                if rows == columns && rows == 1 then
                    //Удалён один контур
                    if ZeroLoops == 1
                        //Удалён первый контур
                        result = [0 0 0; LoopMatrix];
                    else
                        if ZeroLoops == 2
                            //Удалён второй контур
                            result = [LoopMatrix(1, 1) LoopMatrix(1, 2) LoopMatrix(1, 3); 0 0 0; LoopMatrix(2, 1) LoopMatrix(2, 2) LoopMatrix(2, 3)];
                        else
                            //Удалён третий контур
                            result = [LoopMatrix; 0 0 0];
                        end;
                    end;        
                else
                    if rows == 1 && columns == 2
                        //Удалено два контура
                        if ZeroLoops(1, 1) == 1
                            //Удалён первый контур
                            if ZeroLoops(1, 2) == 2
                                //Удалён второй контур
                                result = [0 0 0; 0 0 0; LoopMatrix];
                            else
                                //Удалён третий контур
                                result = [0 0 0; LoopMatrix; 0 0 0];
                            end;
                        else
                            //Удалены второй и третий контура
                            result = [LoopMatrix; 0 0 0; 0 0 0];
                        end;
                    else
                        //Удалены все контуры
                        result = zeros(3);
                    end;
                end;
            end;
        end;
    else
        result = LoopMatrix;
    end;
endfunction
