//Решетина А.С. 5307, подгруппа 3
//Модуль принимает контурную матрицу и матрицу сопротивлений ветвей
//Возврщает матрицу сопротивлений
function Result = Matrix_Resistance (Matrix_contour, Matrix_res_branch)
    [row_cont, column_cont] = size(Matrix_contour);
    [row_branch,column_branch] = size(Matrix_res_branch);
    Result = zeros(row_cont,row_cont);
    for i = 1:row_cont
        for j = i:row_cont
            if (i == j) then 
                for k = 1:column_branch
                    if Matrix_contour(i,k) == -1 then
                        Result(i,j) = Result(i,j) + (-1)*(Matrix_contour(i,k) * Matrix_res_branch(k,k))
                    else
                        Result(i,j) = Result(i,j) + (Matrix_contour(i,k) * Matrix_res_branch(k,k))
                    end
                end
            else 
                for k = 1:column_branch
                    if ((Matrix_contour(i,k) ~= 0)&(Matrix_contour(j,k) ~= 0))  then
                        if ((Matrix_contour(i,k) + Matrix_contour(j,k)) == 0) then 
                            Result(i,j) = Result(i,j) - Matrix_res_branch(k,k)
                        else
                            Result(i,j) = Result(i,j) + Matrix_res_branch(k,k)
                        end
                    end
                 end
                Result(j,i) = Result(i,j)
            end 
        end
    end
endfunction
