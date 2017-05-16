%%
clear;
load  sample21.mat;   
load  sample22.mat;

%%
[m,n] = size(sample21);
sampleIVT = cell(m,102);
for i = 1:m                    
     sampleIVT(i,1) = cellstr(sample21{i,1});
     sampleIVT(i,2:102) = num2cell((cell2mat(sample21(i,2:102)) + cell2mat(sample22(i,2:102)))./2);
end

%%
save  AvianHumanSwine_HA_influenzafaa_2_sample  sampleIVT;

