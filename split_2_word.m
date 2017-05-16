function  [c] = split_2_word(s)
%  split_word.m split the string s into c that contains one blank every
%  two  character,like s is 'AAGCTGCA',c is 'AA GC TG CA'

%  s: input string
%  c: output string

sl = length(s);   
bl = ceil(sl/2);   
c = blanks(bl+sl); 

start = 1;  
id = 1;
while  start < sl && (sl-start) >= 2    
         c(id:id+1) = s(start:start+1);  
         start = start + 2;
         id = id + 3; 
end
c(id:id+(sl-start)) = s(start:sl);   

