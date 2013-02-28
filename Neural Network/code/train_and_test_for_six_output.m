function [confusionMatrix,recall,precision] = train_and_test_for_six_output(training_sample,test_sample,class,kkTestActualLabel)
%this function receives training_example (45*90) from 10-fold

%% create one six-output trained NN

%% NEED CHANGES ON CONFIG AND PARAM ********

hiddenLayerSize = 10;
net = feedforwardnet(hiddenLayerSize);
net.trainFcn = 'trainlm';
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'purelin';

%% Train with one set of training only
net = configure(net, training_sample, class);

% Configure network training epochs
net.divideParam.trainRatio =80/100;  % Adjust as desired
net.divideParam.valRatio = 20/100;  % Adjust as desired
net.divideParam.testRatio = 0/100;  % Adjust as desired
net.trainParam.epochs = 100;
net.trainParam.goal = 0;
net.trainParam.show = 25;
net.trainParam.time = inf;
net.trainParam.min_grad = 1e-10;
net.trainParam.max_fail = 6;
net.trainParam.mu = 0.001;
net.trainParam.lr = 0.01;

%% Train with one set of training data only
NN = train(net, training_sample, class);


%% 
predictedLabel=[];
testResult = sim(NN,test_sample);
predictedLabel = NNout2labels(testResult); % This returns 1*10 row vector
%predictedLabel = [1 2 3 4 5 6 1 2 3 4] .. 
%This has to be compared with 'kkTestActualLabel' variable to produce
%confusion matrix

confusionMatrix = zeros(6,6) ;
for index = 1:10
    if (kkTestActualLabel(index) == predictedLabel(index))
        confusionMatrix(kkTestActualLabel(index),kkTestActualLabel(index))= confusionMatrix(kkTestActualLabel(index),kkTestActualLabel(index)) + 1 ;
    else 
   confusionMatrix(kkTestActualLabel(index),predictedLabel(index))= confusionMatrix(kkTestActualLabel(index),predictedLabel(index)) + 1 ;
    end
end


%% producing recall and precision values
for n = 1:6
    sumvector=sum(confusionMatrix,2);
    recall(1,n)=confusionMatrix(n,n)/sumvector(n);
    sumvector=sum(confusionMatrix,1);
    precision(1,n)=confusionMatrix(n,n)/sumvector(n);
end


function y = NNout2labels(x)

%NNOUT2LABELS - transforms the output of a NN to a 1 column label representation

%IN:  x: the output of a NN
%OUT: y: a one-column label representation

[v I] = max(x);
y = I';
end


end



