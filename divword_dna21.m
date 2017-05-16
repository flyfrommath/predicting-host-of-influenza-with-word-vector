% divide sequence£¬insert blanks into them
% situation 1


clear;
load('Avian_sequence.mat');
load('Human_sequence.mat');
load('Swine_sequence.mat');

sequencefile = cat(1,Asequence,Hsequence,Ssequence);
[m1,n1] = size(sequencefile);
sequence21 = cell(m1,3);


for i=1:m1
     sequence21(i,1) = cellstr(sequencefile{i,1});    
     sequence21(i,2) = num2cell(sequencefile{i,2});    
     a1 = sequencefile{i,3};
     alen = length(a1);
     ay = mod(alen,2);
     a = a1(1:alen-ay);
     
     c = split_2_word(a);   
     sequence21(i,3) = cellstr(c);    
end

save  sequence21   sequence21

