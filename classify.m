function [] = classify(comment)
    
    load('index.mat');
    
    comment = regexprep(comment,'[^A-Za-z_ğüşıöçĞÜŞİÖÇ]',' ');
    comment = lower(comment);
    comment = strsplit(comment);
    
    pos_point = 0;
    neg_point = 0;
    
    for j=1:length(comment)
        word = char(comment(1,j));
          %3 harften kısa kelimeleri dikkate alma
                if(length(word)<3)
                    continue;
                end
                
              %kelimeleri ilk 5 harfine göre stemming et
                if(length(word)>5)
                 word = word(1:5);
                end    
                
                [r,c] = find(strcmp(map,word));
                
                pos_point = pos_point + cell2mat(map(r,2));  
                neg_point = neg_point + cell2mat(map(r,3));  
                       
    end    
        if(pos_point > neg_point) disp('positive');
                else disp('negative');
        end
end