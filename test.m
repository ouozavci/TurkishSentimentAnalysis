function test()
    file_positive = fopen('positive_test.txt','r');
    file_negative = fopen('negative_test.txt','r');
    
    line = fgetl(file_positive);
    line_count=0;
    
    tp = 0.0;
    tn = 0.0;
    fp = 0.0;
    fn = 0.0;
   
    pos_correct_count = 0;
    
    while(ischar(line))
        line_count = line_count + 1;
        result = classify(line);
        if(result == 1)
            pos_correct_count = pos_correct_count + 1;
            tp = tp+1;
        else
            fp = fp+1;
        end
        line = fgetl(file_positive);
    end
    
    line = fgetl(file_negative);
     
    neg_correct_count = 0;
    
    while(ischar(line))
        line_count = line_count + 1;
        result = classify(line);
        if(result == 2)
            neg_correct_count = neg_correct_count + 1; 
            tn = tn+1;
        else
            fn = fn+1;
        end
        line = fgetl(file_negative);
    end
    accuracy = double((pos_correct_count+neg_correct_count)/line_count);
    precision = tp/(tp+fp);
    recall = tp/(tp+fn);
    fScore = 2*((precision*recall)/(precision+recall));
    
    
    disp([num2str(pos_correct_count+neg_correct_count) ' correct estimation on ' num2str(line_count) ' comments']);
    disp(['Accuracy is ' num2str(accuracy)]);
    disp(['Precision: ' num2str(precision)]);
    disp(['Recall: ' num2str(recall)]);
    disp(['Balanced F Score: ' num2str(fScore)]);
    
end