function [result] = classify(comment)
    
    load('index.mat');
    
    comment = regexprep(comment,'[^A-Za-z_ğüşıöçĞÜŞİÖÇ]',' ');
    comment = lower(comment);
    comment = strsplit(comment);
    
    pos_point = 1;
    neg_point = 1;
    
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
                
                    pos_bayes = cell2mat(map(r,2));
                    neg_bayes = cell2mat(map(r,3));
                
%                     disp([word '-->' num2str(pos_bayes) '--' num2str(neg_bayes)]);
                    
                    
                    if isempty(pos_bayes) | pos_bayes == 0
                        pos_bayes = 1;
                    end    
                    
                    if isempty(neg_bayes) | neg_bayes == 0
                        neg_bayes = 1;
                    end                     
                pos_point = pos_point * pos_bayes;  
                neg_point = neg_point * neg_bayes;  
                
                while(pos_point<0.01 && neg_point<0.01)
                    pos_point = pos_point*10;
                    neg_point = neg_point*10;
                end                          
    end    
%         disp(['positive point: ' num2str(pos_point)]);
%         disp(['negative point: ' num2str(neg_point)]);

        if(pos_point > neg_point)
            disp('positive');
            result = 1;
        else
            disp('negative');
            result = 2;
        end
end