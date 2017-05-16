% calculate word vector of the sequence according to word vectors dictionary
 

clear;
word_vec = importdata('out_influenzafaa_data_2');  %import word vectors dictionary
load('sequence22.mat');  

%%
word = word_vec.textdata;  
vec = word_vec.data;     
[r,c] = size(vec);   
number = 1:1:r;  
wordnumberMap = containers.Map(word,number);  
[sample_num,c1] = size(sequence22);  
sample22 = cell(sample_num,102);   

for i = 1:sample_num
     str = sequence22{i,3};  
     s22 = regexp(str,'\s+','split'); 
     [rs,cs] = size(s22);   
     temp_vec = zeros(1,100);  
     vec_count = 0;   
    
     for j = 1:cs  
          if  isKey(wordnumberMap,s22{1,j})   
               match_num  =  wordnumberMap(s22{1,j});      
               temp_vec = temp_vec + vec(match_num,:);
               vec_count = vec_count+1;
          else
              continue;
          end      
     end
     
     sample22(i,1) = cellstr(sequence22{i,1});   
     
     if  vec_count ~= 0              
          sample22(i,2:101) = num2cell(temp_vec./vec_count);    
     else                           
          sample22(i,2:101) = num2cell(vec(1,:));
     end  
     
     sample22(i,102) = num2cell(sequence22{i,2});   
end  

%%
save  sample22  sample22;