function result = indexer()
    file_positive = fopen('positive.txt','r');
    file_negative = fopen('negative.txt','r');
    

    pos_df_map = containers.Map('KeyType','char','ValueType','int32');  
    tf_map = containers.Map('KeyType','char','ValueType','any');
    
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
                    if pos_df_map.isKey(word)   % o ara df i de aradan çıkaralım
                        val = pos_df_map(word);
                        pos_df_map(word) = val + 1;
                    else    
                        pos_df_map(word) = 1;
                    end   
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
 
    neg_df_map = containers.Map('KeyType','char','ValueType','int32');  
    
    line = fgetl(file_negative);
     
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
                    if neg_df_map.isKey(word)   % o ara df i de aradan çıkaralım
                        val = neg_df_map(word);
                        neg_df_map(word) = val + 1;
                    else    
                        neg_df_map(word) = 1;
                    end   
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
          line=fgetl(file_negative);
        line_count=line_count+1;
    end
 
    stop_words = containers.Map('KeyType','char','ValueType','int32');   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %tf lerin yazılacağı bir cell tablosu oluşturuluyor.
%     idf_cell = cell(1);
%     keys = tf_map.keys();                           %keyler tf_map ten çekildi
%     for i=1:length(keys)    
%         word  = char(keys(1,i));                    %her kelime ayrı ayrı alınıyor.
%         
%         df = double(pos_df_map(word))+double(neg_df_map(word));                  %df değerleri df mapinden alınıyor.
%                  if(double(df/line_count)>0.5)
%                      stop_words(word) = 1;
%                      break;                         %stop word removing;
%                  end
%                  
%         idf_cell{i,1} = word;                       %ve cellin 1. sütununa yazılıyor
%              tmp_cell = tf_map(char(word));         %ve ilgili kelimenin tf değerlerini içeren cell arrayi alınıyor
%              for j = 1 : length(tmp_cell)
%                  if(~isempty(tmp_cell{1,j}))
%                  tf = tmp_cell{1,j};                %tf değerleri tf mapinden alınıyor.         
%                  idf = double(double(tf) * log(double(line_count/df))); %idf hesaplanıyor
%                  idf_cell{i,j+1} = idf;              %ve diğer sütunlara idf değerleri yazılıyor.
%                  else
%                  idf_cell{i,j+1} = 0;                %eğer tf değeri boş dönmüş ise 0 yazılyor.
%                  end
%              end   
%     end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    tf_idf_cell = cell(1);
    keys = tf_map.keys();
    for i=1:length(keys)
        word = char(keys(1,i));
       
            if(pos_df_map.isKey(word))pos_df = pos_df_map(word);
            else pos_df=0;
            end 
             if(neg_df_map.isKey(word))neg_df = neg_df_map(word);
            else neg_df=0;
             end 
        tf_idf_cell{i,1} = word;
        tf_idf_cell{i,2} = double(pos_df)*log(double(line_count/(pos_df+neg_df)));
        tf_idf_cell{i,3} = double(neg_df)*log(double(line_count/(pos_df+neg_df)));
    end
    
    %fileları kapatalım
    fclose(file_positive);
    fclose(file_negative);
  
    save('index.mat',tf_idf_cell);
    
    %
    result = tf_idf_cell;
end