function [ f_energy_all ] = get_signal_energy_9_part( z_direction_force_d,xt )
%UNTITLED using this func to get the energy of signal
%   此处显示详细说明 input shoud be the z direction force_d, xt is time of the data
cut_frequence=20;
sfft=fft(z_direction_force_d); 
        %% get the energy in different frequence
        m = abs(sfft);                               % Magnitude
        sfft(m<1e-6) = 0;
        p = unwrap(angle(sfft));     
        f = (0:length(sfft)-1)*100/length(sfft);        % Frequency vector

        idf= f(:)>cut_frequence ;
        f(idf)=[];
        m(idf)=[];
        p(idf)=[];
        
        data_freq=(xt(end)-xt(1))/(length(xt)-1);
        
        for freq_window=1:9
            if freq_window ==1
                freq_begin=0;
                freq_end=3.5;
            elseif freq_window==2
                freq_begin=0;
                freq_end=7;
            elseif freq_window==3
                freq_begin=0;
                freq_end=14;
            elseif freq_window==4
                freq_begin=0;
                freq_end=20;
            elseif freq_window==5
                freq_begin=0;
                freq_end=1.75;
            elseif freq_window==6
                freq_begin=1.75;
                freq_end=3.5;
            elseif freq_window==7
                freq_begin=3.5;
                freq_end=7;
            elseif freq_window==8
                freq_begin=7;
                freq_end=14;
            elseif freq_window==9
                freq_begin=14;
                freq_end=20;
            end
            idf1= f(:)>=freq_begin & f(:)<=freq_end;
            f_5=m(idf1);
            f_energy_5=0;
            for i=2:length(f_5)
            f_energy_5=f_energy_5+(f_5(i-1)+f_5(i))*data_freq*0.5;
            end
            f_energy_all_tissue{freq_window}=f_energy_5;
            clear idf f_5 f_energy_5
        end

end

