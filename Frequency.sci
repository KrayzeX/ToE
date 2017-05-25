//Модуль построения графиков АЧХ и ФЧХ
function result = Frequency(A,B,C,D)
    exec 'Laplace.sci'
    Hs = Laplace(A,B,C,D)
    //f = linspace(0.01,1,1000);
    //fre = repfreq(Hs,f); // частотная характеристика
    //index_band = find(abs(fre)<0.707); //индекс 
    //bandwidth = f(index_band(1)) // пропускная способность
    [frq,repf] = repfreq(Hs);
    [db,phi] = dbphi(repf);
    figure(1);
    plot(frq,db); //АЧХ
    figure(2);
    plot(frq,phi); //ФЧХ
endfunction
