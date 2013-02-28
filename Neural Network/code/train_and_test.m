%Ok OK
function [confusionMatrix,recall,precision] = train_and_test(training_sample,test_sample,class,kk)
%% create all 6 trained NNs and store in an array 'NNArrays'
for index = 1:6
    
	NNArrays{index} = getEachNN(training_sample,class,index) ; 
end


testSet= test_sample;


%% this function takes NNArray  (containing all six NNs) and feature x 
%% and return a vector of label predictions in the format of loaddata.
%% 'predictedResult' has 6 columns for each NN 
predictedResult = testNNs(NNArrays,testSet) ;



%% strategy towards ambiguity
%% In each row which represents one training example
%% check if the row is all zeros or there are more than one '1' value

for i= 1:10
    %% check whether all are zeros in the row
    %% if so, randomly choose one column to fill 1
    if ((min(predictedResult(i,:))==max(predictedResult(i,:)))&&min(predictedResult(i,:))==0)
        first_random=randperm(6);
        predictedResult(i,first_random(1))=1;
    end
    %% check if more than one '1' values on the same row
    %% if so, randomly pick one column from them, fill the row all with zeros, then fill that
    %% particular column with '1'
    if (size(find(predictedResult(i,:)),2)>1)
        
        picked_column=find(predictedResult( i,:));
        random_value=randperm(size(find(predictedResult(i,:)),2));
        predictedResult(i,:)=[0 0 0 0 0 0];
        predictedResult(i,picked_column(random_value(1))) =1;
    end
end







%% producing the confusionMatrix from the predictedresult 

confusionMatrix = zeros(6,6) ;
precision_recall=zeros(1,12);
for n = 1:6
	oneColumn = predictedResult(:,n) ;
	for j = 1:size(oneColumn,1)
		if ( (kk(j) == n) && (oneColumn(j) == 1) )
			confusionMatrix(n,n) = confusionMatrix(n,n) + 1 ; %increment by 1 
		elseif ( (kk(j) ~= n) && (oneColumn(j) == 1) )
			confusionMatrix(kk(j),n) = confusionMatrix(kk(j),n) + 1 ;

			
		end
		
	end
end

%% producing recall and precision
for n = 1:6
    sumvector=sum(confusionMatrix,2);
    recall(1,n)=confusionMatrix(n,n)/sumvector(n);
    sumvector=sum(confusionMatrix,1);
    precision(1,n)=confusionMatrix(n,n)/sumvector(n);
end

end

%%  subfunction to get the NN
function [NN] = getEachNN(training_sample,class,target)

hiddenLayerSize = 10;
net = feedforwardnet(hiddenLayerSize);
net.trainFcn = 'trainlm';
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'purelin';

%% configure network
% Configure network inputs and outputs to best match input and target data
net = configure(net, training_sample, class(target,:));

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

% Weights for input
%net.IW{1} = zeros(hiddenLayerSize,28);
% Weights for hidden 6 for output num
%net.LW{2,1} = zeros(1, hiddenLayerSize);
% Bias


%% Train the network
NN = train(net, training_sample, class(target,:));
end
%
%


%OK OK
%% subfunction to get the predicted result
function [SixPredictedClasses] = testNNs(NNArrays,testSet) 
SixPredictedClasses=[];
for count = 1:6
	% process one NN by one NN from 6 NNs
	eachTrainedNN = NNArrays{count} ;
	
	% each NN tested with one test set produces 'predictedLabels' array
	predictedLabels = testSamples(testSet,eachTrainedNN) ;
	
	% SixPredictedClasses is 2D array which has 6 columns
	SixPredictedClasses = [SixPredictedClasses,predictedLabels];
    
    
end
end

%
% 
%
%OK OK
function [finalResult] = testSamples(sampleSet,NN)
    testResult = sim(NN,sampleSet);
    finalResult = NNout2labelsForOneEmotion(testResult);
end

function [finalClass] = NNout2labelsForOneEmotion(testResult)  
    [a b] = size(testResult);
    sizeVector = a*b ;
     for i = 1:sizeVector
        if(abs(testResult(i)-1) < 0.1)
            finalClass(i) = 1 ;
        else
            finalClass(i) = 0 ;
        end
     end
     finalClass=finalClass';

end
