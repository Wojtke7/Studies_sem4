%% Jaki jest cel kwantyzacji?
% Kwantyzacja jest kluczowym krokiem w cyfrowym przetwarzaniu sygnałów, 
% w tym w kompresji sygnałów audio. Jej głównym celem jest zmniejszenie 
% liczby bitów potrzebnych do reprezentacji sygnału, 
% co przekłada się na efektywniejsze przechowywanie i przesyłanie danych.

function y = lab11_kwant(x,b) %(sygnał, liczba bitów)
      % rozdzielamy na kanal lewy i prawy sygnału stereo, ze względu na
      % dokładne obliczanie szerokości przedziału kwantyzacji
      xlewy = x(:,1);
      xprawy = x(:,2);
      % znajduje min i max amplitudy w każdym kanale
      xMinLewy = min(xlewy);
      xMaxLewy = max(xlewy);
      xMinPrawy = min(xprawy);
      xMaxPrawy = max(xprawy);
      
      % zakres amplitudy (max-min)
      x_zakresLewy=xMaxLewy-xMinLewy; 
      x_zakresPrawy=xMaxPrawy-xMinPrawy;
      
      % liczba bitów, liczba przedzialów kwantowania
      Nb=b; % przypisanie liczby bitów do zmiennej Nb
      Nq=2^Nb; % obliczenie liczby poziomów kwantyzacji na podstawie liczby bitów

      %% szerokosc przedzialu kwantowania
      
      % kanał lewy:
      dx=x_zakresLewy/Nq; %dzielę na równe progi
      xqlewy=dx*round(xlewy/dx); %zaokrąglam do najbliższego progu
      
      % kanał prawy:
      dx=x_zakresPrawy/Nq;
      xqprawy=dx*round(xprawy/dx);
      
      % funkcja zwraca sygnal stereo - zlozenie horyzontalne
      y = horzcat(xqlewy,xqprawy);  %składa sygnał z dwóch kanałów
end