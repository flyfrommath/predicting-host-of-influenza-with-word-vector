%% classify using Support Vector Machine 

%classifier1£ºAvian(0)¡ª¡ªSwine(2£©
%classifier2: Avian(0)¡ª¡ªHuman(1£©
%classifier3£ºSwine(2)¡ª¡ªHuman(1£©

load  AvianHumanSwine_HA_influenzafaa_2_sample;     
outputfile = 'AvianHumanSwine_HA_svm_influenzafaa_data_2_10foldresult.xls';  

%%     
ACCURACY = zeros(1,10);   

% 
avian_respective_accuracy = zeros(1,10); 
human_respective_accuracy = zeros(1,10);
swine_respective_accuracy = zeros(1,10);

%% 

Avian_ind = find(cell2mat(sampleIVT(:,102)) == 0);
Avian = sampleIVT(Avian_ind,:);   
[Avian_num,C0] = size(Avian);
indicesA = crossvalind('Kfold',Avian_num,10);  

Human_ind = find(cell2mat(sampleIVT(:,102)) == 1);  
Human = sampleIVT(Human_ind,:);  
[Human_num,C1] = size(Human);
indicesH = crossvalind('Kfold',Human_num,10);   

Swine_ind = find(cell2mat(sampleIVT(:,102)) == 2);  
Swine = sampleIVT(Swine_ind,:);   
[Swine_num,C2] = size(Swine);
indicesS = crossvalind('Kfold',Swine_num,10);   


%% do ten times
for k=1:10
     % cross validation
     testA = (indicesA == k);  
     trainA = ~testA;     
     Avian_test = Avian(testA,:);
     Avian_train = Avian(trainA,:);
     
     testH = (indicesH == k);  
     trainH = ~testH;     
     Human_test = Human(testH,:);
     Human_train = Human(trainH,:);
     
     testS = (indicesS == k);  
     trainS = ~testS;    
     Swine_test = Swine(testS,:);
     Swine_train = Swine(trainS,:);
     
     % test  sets
     TEST = cat(1,Avian_test,Human_test,Swine_test); 
     [testnum,C3] = size(TEST);
     X_test = cell2mat(TEST(:,2:end-1));  
     Y_test = cell2mat(TEST(:,end));      
     Y_PREDICT = zeros(testnum,3);   
     Y_predict = zeros(testnum,1);  
     
    
     % train sets
     TRAIN02 = cat(1,Avian_train,Swine_train); 
     X_train02 = cell2mat(TRAIN02(:,2:end-1));
     Y_train02 = cell2mat(TRAIN02(:,end));
     
     TRAIN01 = cat(1,Avian_train,Human_train); 
     X_train01 = cell2mat(TRAIN01(:,2:end-1));
     Y_train01 = cell2mat(TRAIN01(:,end));
     
     TRAIN21 = cat(1,Swine_train,Human_train);
     X_train21 = cell2mat(TRAIN21(:,2:end-1));
     Y_train21 = cell2mat(TRAIN21(:,end));
     
     % Construct three classifiers of SVM
     option_new02 = statset('MaxIter',20000);
     SVMStruct02 = svmtrain(X_train02,Y_train02,'kernel_function','rbf','options',option_new02);
     Y_PREDICT(:,1) = svmclassify(SVMStruct02,X_test);
         
     option_new01 = statset('MaxIter',20000);
     SVMStruct01 = svmtrain(X_train01,Y_train01,'kernel_function','rbf','options',option_new01);
     Y_PREDICT(:,2) = svmclassify(SVMStruct01,X_test);
     
     option_new21 = statset('MaxIter',20000);
     SVMStruct21 = svmtrain(X_train21,Y_train21,'kernel_function','rbf','options',option_new21);
     Y_PREDICT(:,3) = svmclassify(SVMStruct21,X_test);

     
     %% get the label of classify using vote 
     
     class = [0,1,2];
     for  i = 1:testnum   
          count0 = 0;   
          count1 = 0;   
          count2 = 0;   
          for j = 1:3
              if  Y_PREDICT(i,j) == 0
                  count0 = count0+1;
              end  
              if  Y_PREDICT(i,j) == 1
                  count1 = count1+1;
              end
              if  Y_PREDICT(i,j) == 2
                  count2 = count2+1;
              end  
          end
          [count,clsss_ind] = max([count0,count1,count2]);  
          if count == 1                    
             sjs = randperm(3);          
             Y_predict(i,1) = class(sjs(1));   
          else
             Y_predict(i,1) = clsss_ind-1;  
          end
     end
     
     %% calculate accuracy rate
     Ytp = cat(2,Y_test,Y_predict);
     a0_ind = find(Ytp(:,1) == 0);
     h1_ind = find(Ytp(:,1) == 1);
     s2_ind = find(Ytp(:,1) == 2);
     
     Ya = Ytp(a0_ind,:);
     [a0_row,a0_col] = size(Ya);
     a0_count = 0;    
     for  ai = 1:a0_row
           if  Ya(ai,1) == Ya(ai,2)
                a0_count = a0_count + 1;
           end
     end
     avian_respective_accuracy(1,k) = a0_count/a0_row;
     
     Yh = Ytp(h1_ind,:);
     [h1_row,h1_col] = size(Yh);
     h1_count = 0;    
     for  hi = 1:h1_row
           if  Yh(hi,1) == Yh(hi,2)
                h1_count = h1_count + 1;
           end
     end
     human_respective_accuracy(1,k) = h1_count/h1_row;
     
     Ys = Ytp(s2_ind,:);
     [s2_row,s2_col] = size(Ys);
     s2_count = 0;    
     for  si = 1:s2_row
           if  Ys(si,1) == Ys(si,2)
                s2_count = s2_count + 1;
           end
     end
     swine_respective_accuracy(1,k) = s2_count/s2_row;
     
     
     % overall accuracy rate
     ACCURACY(1,k) = (a0_count + h1_count + s2_count)/(a0_row + h1_row + s2_row);
     
end

% calculate average value and standard deviation of accuracy rate 
accuracy_average = mean(ACCURACY);  
accuracy_sd = std(ACCURACY);       

%  
avian_respective_accuracy_average = mean(avian_respective_accuracy);  
avian_respective_accuracy_sd = std(avian_respective_accuracy);        
human_respective_accuracy_average = mean(human_respective_accuracy);  
human_respective_accuracy_sd = std(human_respective_accuracy);        
swine_respective_accuracy_average = mean(swine_respective_accuracy);  
swine_respective_accuracy_sd = std(swine_respective_accuracy);        


xlswrite(outputfile,ACCURACY,1,'B6');    
xlswrite(outputfile,avian_respective_accuracy,1,'B7');    
xlswrite(outputfile,human_respective_accuracy,1,'B8');     
xlswrite(outputfile,swine_respective_accuracy,1,'B9'); 


xlswrite(outputfile,accuracy_average,1,'B13');   
xlswrite(outputfile,accuracy_sd,1,'C13');      
xlswrite(outputfile,avian_respective_accuracy_average,1,'B14');   
xlswrite(outputfile,avian_respective_accuracy_sd,1,'C14');      
xlswrite(outputfile,human_respective_accuracy_average,1,'B15');
xlswrite(outputfile,human_respective_accuracy_sd,1,'C15');
xlswrite(outputfile,swine_respective_accuracy_average,1,'B16');
xlswrite(outputfile,swine_respective_accuracy_sd,1,'C16');




