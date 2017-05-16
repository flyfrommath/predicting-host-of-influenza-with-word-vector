This is to predict the host of influenza A viruses based on word vectors using the SVM models. It takes HA gene as example. The SVM model used the word vectors as input. Here, the word in the word vectors are two letters long.
Firstly, the data for predicting the host of influenza A viruses should be processed in format like file “Avian_sequence.mat”. Each row is presented as “ID, label, sequence” in these files.
Then, the scripts “divword_dna21.m” and “divword_dna22.m” were used to separate the sequences into words.
Thirdly, transform each sequence into word vectors by sequential running the scripts “calculate_vector21.m，calculate_vector22.m，calculate_vector2.m”. The word vectors is provied in file “out_influenzafaa_data_2”.
Finally, the SVM model were built and tested with the script “SVM_3_CLASSIFY.m”
