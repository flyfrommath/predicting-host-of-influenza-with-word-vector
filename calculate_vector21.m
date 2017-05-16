% calculate word vector of the sequence according to word vectors dictionary
 

clear;
word_vec = importdata('out_influenzafaa_data_2');  %import word vectors dictionary
load('sequence21.mat');    

%%
word = word_vec.textdata;  
vec = word_vec.data;     
[r,c] = size(vec);   
number = 1:1:r;    
wordnumberMap = containers.Map(word,number);  
[sample_num,c1] = size(sequence21);  
sample21 = cell(sample_num,102);   

for i = 1:sample_num
     str = sequence21{i,3};  
     s21 = regexp(str,'\s+','split'); 
     [rs,cs] = size(s21);   
     temp_vec = zeros(1,100);  
     vec_count = 0;   
    
     for j = 1:cs  
          if  isKey(wordnumberMap,s21{1,j})   
               match_num  =  wordnumberMap(s21{1,j});      
               temp_vec = temp_vec + vec(match_num,:);
               vec_count = vec_count+1;
          else
              continue;
          end      
     end
     
     sample21(i,1) = cellstr(sequence21{i,1});   
     
     if  vec_count ~= 0              
          sample21(i,2:101) = num2cell(temp_vec./vec_count);    
     else                          
          sample21(i,2:101) = num2cell(vec(1,:));
     end  
     
     sample21(i,102) = num2cell(sequence21{i,2});  
end  

%%
save  sample21  sample21;