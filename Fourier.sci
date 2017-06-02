//Решетина Алла, 5307 подгруппа 3
function [] = Fourier(Hs, tau, A)
    exec 'Heaviside.sci';
    exec 'delta2.sce';
    //A = 10; tau = 2;   
    T = 2*tau; N = 1000; fd = N/T; td= T/N; count_garm = 10;
    w = 2*%pi/T; apr_f1 = zeros(1,N); AmpCH = zeros(1,N), PhCH = zeros(1,N); 
    A2 = zeros(1:N), Ph2 = zeros(1:N); apr_f2 = zeros(1,N);
    t = linspace(0,T,N);
//signal = A.*sin(t.*%pi./tau)-A.*sin(t.*%pi./tau).*Heaviside(t-tau); //Колокол
//signal = 2*A/tau*delta2(t)-4*A/tau*delta2(t-0.5*tau)+2*A/tau*delta2(t-tau);//Треугольник
signal = A.*cos(t.*%pi./tau)-A.*cos(t.*%pi./tau).*Heaviside(t-tau); //Косинус
//signal = A*Heaviside(t)-2*A*Heaviside(t-tau/2)+A*Heaviside(t-tau);//Меандр


//вычисление ДПФ
F = fft(signal)*td;

//Вычисление дискретных спектров
A_k = 2/T*F; //см страницу 76-80 методических указаний
Amp = abs(A_k);
for i = 1:N
    if real(A_k(i)) > 0 then
    Phase(i) = atan(imag(A_k(i))/real(A_k(i)));
    else
        if imag(A_k(i)) >= 0 then
            Phase(i) = atan(imag(A_k(i))/real(A_k(i))) + %pi;
        else
            Phase(i) = atan(imag(A_k(i))/real(A_k(i))) - %pi;
        end
    end
end

//Phase = atan(imag(A_k),real(A_k));
//count_garm = fix(max(Amp))
//Аппроксимация
for i = 1:N
    apr_f1(1,i) = Amp(1)/2;
    for k = 2:count_garm
        apr_f1(1,i) = apr_f1(1,i)+Amp(k)*cos((k-1)*w*t(i)+Phase(k));
    end 
end



//реакция в виде отрезка Фурье
//заменяем s на jw
for i = 1:N
    num = numer(Hs) 
    den = denom(Hs)
    Values = freq(numer(Hs), denom(Hs), %i*w*(i-1)); 
    AmpCH(i) = sqrt(real(Values)^2 + imag(Values)^2);
    
    PhCH(i) = atan(imag(Values),real(Values));
    A2(i) = Amp(i) * AmpCH(i);
    Ph2(i) = Phase(i) + PhCH(i);
end
for i = 1:N
    apr_f2(1,i) = A2(1)/2;
    for k = 2:count_garm
        apr_f2(1,i) = apr_f2(1,i)+A2(k)*cos((k-1)*w*t(i)+Ph2(k));
    end
end

//Построение дискретных спектров
figure()
plot2d3('gnn',Amp(1:count_garm))
title('Ампплитудный спектр входного сигнала')
xlabel('Частота, Гц')
figure()

plot2d3('gnn',Phase(1:count_garm))
title('Фазовый спектр выходного сигнала')
xlabel('Частота, Гц')

//Аппроксимации
figure()
plot(t,signal,t,apr_f1)
title('Входной сигнал и его аппроксимация')
xlabel('Время, с')
figure()
plot(t,apr_f1,t,apr_f2)
title('Аппроксимации входного и выходного сигналов')
xlabel('Время, с') 

figure()
plot2d3('gnn',AmpCH(1:count_garm))
title('Ампплитудный спектр выходного сигнала')
xlabel('Частота, Гц')

figure()
plot2d3('gnn',PhCH(1:count_garm))
title('Фазовый спектр выходного сигнала')
xlabel('Частота, Гц')
endfunction


