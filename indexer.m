function result = indexer()
    file_positive = fopen('positive.txt','r');
    file_negative = fopen('negative.txt','r');
    
    count_map = containers.Map('KeyType','char','ValueType','int32');
    df_map = containers.Map('KeyType','char','ValueType','int32');
    
   % positiveComments = cell(1,1);
   % negativeComments = cell(1,1);
    line = fgetl(file_positive);
    i=1;  
    
    %positive.txt dosyasından kelimeler line olarak alınıyor.
    while ischar(line)
        
          %harf olmayan karakterleri at hepsini küçük harf haline getir ve
          %boşluklara göre ayır.
          line = regexprep(line,'[^A-Za-z_ğüşıöçĞÜŞİÖÇ]',' ');
          line=lower(line);
          line = strsplit(line);
          
          %line içindeki kelimeler teker teker ele alınıp uygun olanlar map
          %e ekleniyor.
          for j=1:length(line)
               word = char(line(1,j));
           
               %3 harften kısa kelimeleri dikkate alma
                if(length(word)<3)
                    continue;
                end
                
              %kelimeleri ilk 5 harfine göre stemming et
                if(length(word)>5)
                 word = word(1:5);
                end    
                
              %kelimeleri map'e ekle  
                if count_map.isKey(word)
                    val = count_map(word);
                    count_map(word) = val+1;
                else
                    count_map(word) = 1;
                end 
                
          end
          line=fgetl(file_positive);
        i=i+1;
    end
    fclose(file_positive);

%     i=1;       wh 
%     while ischar(line)
%         negativeComments(i,1) = java.lang.String(line);
%         line = fgetl(file_negative);
%         i=i+1;
%   end
 
    fclose(file_negative);
    
    result = count_map;
end