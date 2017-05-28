//Главный модуль
//В качестве параметров принимает контурную матрицу, матрицу сопротивлений ветвей,
//матрицу ЭДС источников, матрицу источников тока, 
//типы реактивных элементов и значения реактивных элементов (ValueBranch1 - значение
//реактивного элемента с меньшим номером ветви), тип входного одиночного импульса:
//0 - прямоугольный одиночный импульс;
//1 - синусный одиночный импульс;
//2 - треугольный одиночный импульс;
//3 - косинусный одиночный импульс;
//4 - меандр;
//длительность входного одиночного импульса.

//ВНИМАНИЕ!!!
//ЕСЛИ В ЦЕПИ КОНДЁР И КАТУШКА, СТАВИМ КОНДЁР НА ПЕРВОЕ МЕСТО.
//ТОГДА ValueBranch1 - ЁМКОСТЬ
//ЗАДАЁМ КОНТУРНЫЕ ТОКИ ТАК, ЧТОБЫ НА РЕАКТИВНЫХ ЭЛЕМЕНТАХ ОНИ БЫЛИ СОНАПРАВЛЕНЫ
function [] = MainUnit(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix, ReactType, ValueBranch1, ValueBranch2, Branch, PulseType, tau)
    
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
    exec 'FindCD.sci';
    exec 'Laplace.sci';
    exec 'InputLaplace.sci';
    exec 'PTime.sci';
    exec 'Frequency.sci';
    exec 'Fourier.sci';
    
    //Применяем МКТ
    //Currents = MethodOfLoopCurrent(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix);
       
    //Находим систему уравнений состояния электрической цепи
    [System, Currents] = StEquation(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix, ReactType, ValueBranch1, ValueBranch2);
    //disp(System);
    //halt;
    //disp(Currents);
    //halt;
    
    //Находим собственные частоты цепи
    [p1, p2] = OwnFrequencies(System);
    //disp(p1);
    //disp(p2);
    //halt;
    
    //Находим практическую длительность переходного процесса
    PractTime = PTime(p1, p2);
    //disp(PractTime);
    //halt;
    
    //Находим решение системы уравнения состояния электрической цепи
    [Steady, A1, A2, A3, A4, Type] = SolveSystem(System, p1, p2);
    
    //Находим переходную характеристику
    [Steady, A1, A2] = FindTransientResponse(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix, Currents, [Steady, A1, A2, A3, A4], Branch);    
    
    //Строим график
    PlotTransientResponse(Steady, A1, A2, p1, p2, Type);
    
    //Находим матрицы C и D
    CD = FindCD(LoopMatrix, BranchResistance, EMFMatrix, CurrentMatrix, Currents, Branch);
    disp(CD);
    halt;
    
    //Находим изображение найденной реакции по Лапласу
    Hs = Laplace([System(1, 1) System(1, 2); System(2, 1) System(2, 2)], [System(1, 3); System(2, 3)], [CD(1, 1) CD(1, 2)], CD(1, 3));
    
    //Задаём входной одиночный импульс в S-области и находим реакцию
    InputLaplace(PulseType, tau, Hs);

    //Определение амплитудно-частотной и фазочастотной характеристики цепи
    halt;
    Frequency(Hs);
    
    //Анализ цепи частотным методом при заданном периодическом воздействии
    Fourier();
    
endfunction
