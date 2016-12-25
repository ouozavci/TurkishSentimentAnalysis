function test()
    file_positive = fopen('positive_test.txt','r');
    file_negative = fopen('negative_test.txt','r');
    
    line = fgetl(file_positive);
    line_count=0;
    
    pos_correct_count = 0;
    
    while(ischar(line))
        line_count = line_count + 1;
        result = classify(line);
        if(result == 1) pos_correct_count = pos_correct_count + 1; end
        line = fgetl(file_positive);
    end
    
    line = fgetl(file_negative);
     
    neg_correct_count = 0;
    
    while(ischar(line))
        line_count = line_count + 1;
        result = classify(line);
        if(result == 2) neg_correct_count = neg_correct_count + 1; end
        line = fgetl(file_negative);
    end
    accuracy = double((pos_correct_count+neg_correct_count)/line_count);
    disp([num2str(pos_correct_count+neg_correct_count) ' correct estimation on ' num2str(line_count) ' comments']);
    disp(['Accuracy is ' num2str(accuracy)]);
    
end