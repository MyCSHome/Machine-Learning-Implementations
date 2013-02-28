Please type in matlab 
>> [a b c d]=where_evaluation_happens('cleandata_students.txt')
It will generate
a - normlized confusion matrix
b - averaged recall
c - averaged precision
d - averaged Falpha measure
for the ten fold cross validation of single-output NNs.
At same time the function will plot the Falpha for each fold in six emotions.

>> [e f g h]=where_evaluation_happens_six_output('cleandata_students.txt')
It will generate
e - normlized confusion matrix
f - averaged recall
g - averaged precision
h - averaged Falpha measure
for the ten fold cross validation of six-output NNs.
At same time the function will plot the Falpha for each fold in six emotions.