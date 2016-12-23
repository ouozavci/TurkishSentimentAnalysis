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
          tmp = containers.Map('KeyType','char','ValueType','int32');
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
              
              %eğer daha önce eklenmdiyse
              
                if(~tmp.isKey(word))
                    tmp(word) = 1;
                 %kelimeleri df mapine ekle
                    if df_map.isKey(word)
                        val = df_map(word);
                        df_map(word) = val + 1;
                    else    
                        df_map(word) = 1;
                    end    
                end
          end
          line=fgetl(file_positive);
        i=i+1;
    end
    fclose(file_positive);

    %tf idf hesabı için bir kez daha okunması gerekli
    tfidf_map = containers.Map('KeyType','char','ValueType','int32');
    
    tf_map = containers.Map('KeyType','char','ValueType','any');
    
    tf_idf = zeros(count_map.length,i);
    
    file_positive = fopen('positive.txt','r');
    line = fgetl(file_positive);
    line_count=1;  
    %positive.txt dosyasından kelimeler line olarak alınıyor.
    while ischar(line)
          %harf olmayan karakterleri at hepsini küçük harf haline getir ve
          %boşluklara göre ayır.
          line = regexprep(line,'[^A-Za-z_ğüşıöçĞÜŞİÖÇ]',' ');
          line=lower(line);
          line = strsplit(line);
          
          %line içindeki kelimeler teker teker ele alınıp uygun olanlar map
          %e ekleniyor.
          tmp = containers.Map('KeyType','char','ValueType','int32');
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
                
               %tf hesaplamak için tf say
                if(~tmp.isKey(word))
                    tmp(word) = 1;
                else
                    val = tmp(word);
                    tmp(word) = val + 1; 
                end    
          end
          
          %bu line da geçen kelimeler keys in içinde tf değerleri ile
          %bulunuyor
          keys = tmp.keys;
          %keys in içindeki herkelimenin tf ini ilgili kelime ve line
          %countuna göre indexlenmiş tf değerini yazarak tf_map'inde
          %güncelle
          for c = 1:tmp.length
             tf_cell = cell(1);
             word = char(keys(1,c));
             if(tf_map.isKey(word))
                 tf_cell = tf_map(word);
                 tf_val = tmp(word);
                 tf_cell{1,line_count} = tf_val;
                 tf_map(word) = tf_cell;
             else
                 tf_val = tmp(word);
                 tf_cell{1,line_count} = tf_val;
                 tf_map(word) = tf_cell;
             end
          end   
          line=fgetl(file_positive);
        line_count=line_count+1;
    end
 
    tf_cell = cell(1);
    keys = tf_map.keys();
    for i=1:length(keys)
        word  = char(keys(1,i));
        tf_cell{i,1} = word;
             tmp_cell = tf_map(char(word));
             for j = 1 : length(tmp_cell)
                 tf_cell{i,j+1} = tmp_cell{1,j};
             end   
         
    end    
    fclose(file_positive);
 
    fclose(file_negative);
    result = tf_cell;
end