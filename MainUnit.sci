//Главный модуль
//В качестве параметров принимает контурную матрицу, матрицу сопротивлений ветвей,
//матрицу ЭДС источников, матрицу источников тока, 
//типы реактивных элементов и значения реактивных элементов (ValueBranch1 - значение
//реактивного элемента с меньшим номером ветви).

//ВНИМАНИЕ!!!
//ЕСЛИ В ЦЕПИ КОНДЁР И КАТУШКА, СТАВИМ КОНДЁР НА ПЕРВОЕ МЕСТО.
//ТОГДА ValueBranch1 - ЁМКОСТЬ
//ЗАДАЁМ КОНТУРНЫЕ ТОКИ ТАК, ЧТОБЫ НА РЕАКТИВНЫХ ЭЛЕМЕНТАХ ОНИ БЫЛИ СОНАПРАВЛЕНЫ
function [] = MainUnit(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix, ReactType, ValueBranch1, ValueBranch2, Branch)
    
    //Запускаем графическую оболочку, из которой будем загружать матрицы, описывающие цепь
    exec 'StartGUI.sci';
    exec 'GetResistances.sci';
    
    /*StartGUI();
    
    //Получаем диаграмму из стандартного файла
    diagram = xcosDiagramToScilab("Default.zcos");
    lst = diagram.objs;
    
    //Считываем контурную матрицу
    
    //Считываем матрицу сопротивлений
    BranchResistance = GetResistances(lst);*/
    
    //Считываем матрицу ЭДС источников
    
    //Считываем матрицу источников тока
    
    exec 'MethodOfLoopCurrent.sci';
    exec 'ForcedComponents.sci';
    exec 'OwnFrequencies.sci';
    exec 'SolveSystem.sci';
    exec 'PlotTransientResponse.sci';
    exec 'FindTransientResponse.sci';
    exec 'StEquation.sci';
    
    //Применяем МКТ
    Currents = MethodOfLoopCurrent(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix);
       
    //Находим систему уравнений состояния электрической цепи
    System = StEquation(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix, ReactType, ValueBranch1, ValueBranch2);
    
    //Находим собственные частоты цепи
    [p1, p2] = OwnFrequencies(System);
    
    //Находим решение системы уравнения состояния электрической цепи
    [Steady, A1, A2, A3, A4, Type] = SolveSystem(System, p1, p2);
    
    //Находим переходную характеристику
    [Steady, A1, A2] = FindTransientResponse(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix, Currents, [Steady, A1, A2, A3, A4], Branch);    
    
    //Строим график
    PlotTransientResponse(Steady, A1, A2, p1, p2, Type);
endfunction
