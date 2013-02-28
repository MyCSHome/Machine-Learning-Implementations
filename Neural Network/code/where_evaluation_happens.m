function[CM_normalized,average_recall,average_precision,falpha]= where_evaluation_happens(filename)
%% evaluation function, which returns the normalized confusion matrix, averaged reall, averaged precision, and averaged falpha mearsure
    [example,y]=loaddata(filename);
    confusionMatrix=cell(10,1);
    precision=cell(10,1);
    precisionsix=[];
    recall=cell(10,1);
    Falpha=cell(10,1);
    recallsix=[];
    Falphasix=[];
   
%% implementing tenfold cross validation, generating 10 confusion matrix, 10 precision, 10 recall lists for each fold     
for i=0:9
    training_sample=example;
    training_sample(10*i+1:10*i+10,:)=[];
    class=y;
    class(10*i+1:10*i+10,:)=[];
    test_sample=example(10*i+1:10*i+10,:);
    actual_class=y(10*i+1:10*i+10,:);
    
    kk=actual_class;
    
    
    [xTraining yTraining] = ANNdata(training_sample,class);
    [xTest yTest] = ANNdata(test_sample,actual_class);
    
    bb=yTest;
    
    [confusionMatrix{i+1,1},recall{i+1,1}, precision{i+1,1}] = train_and_test(xTraining,xTest,yTraining,kk);
    precisionsix=[precisionsix;precision{i+1,1}];
    recallsix=[recallsix;recall{i+1,1}];
    for n=1:6
        if ((recallsix(i+1,n)==0 && precisionsix(i+1,n)==0) || isnan(recallsix(i+1,n))||isnan(precisionsix(i+1,n)))
            Falphasix(i+1,n)= 3;
        else
            Falphasix(i+1,n)=(2*recallsix(i+1,n)*precisionsix(i+1,n))/(recallsix(i+1,n)+ precisionsix(i+1,n));
    %%index=find(isnan(Falphasix(i+1,:)));
    %%Falphasix(i+1,index)= 3;
        end
    end
    
end
 figure; 
for i=1 :6
    a = [1 2 3 4 5 6 7 8 9 10];
    subplot(2,3,i);
     scatter(a,Falphasix(:,i),'ms');
    axis([1 10 0 1.1]);
       tt=strcat('Emotion',mat2str(i));
    title(tt);
xlabel('Fold No.');
ylabel('Falpha');
    
end
%% generating averaged recall , precision and Falph measure 
average_precision=zeros(1,6);
average_recall=zeros(1,6);
falpha=zeros(1,6);
for j = 1:6
    sumrecall=0;
    sumprecision=0;
    indexrecall=0;
    indexprecision=0;
    for i= 1:10
        if ~isnan(recallsix(i,j)) 
        sumrecall=sumrecall+recallsix(i,j); 
        indexrecall=indexrecall+1;
        end
        if ~isnan(precisionsix(i,j)) 
        sumprecision=sumprecision+precisionsix(i,j); 
        indexprecision=indexprecision+1;
        end
    end
  
    average_recall(1,j)=sumrecall/indexrecall;
    average_precision(1,j)=sumprecision/indexprecision;
    falpha(1,j)=2*average_recall(1,j)*average_precision(1,j)/(average_recall(1,j)+average_precision(1,j));
end

%% generating normalized confusion matrix
CM_normalized=zeros(6,6);
for i = 1:10
    CM_normalized=CM_normalized+confusionMatrix{i};
end
for i = 1:6
    row=CM_normalized(i,:); 
    result=sum(row);
    for n=1:6
       CM_normalized(i,n)=CM_normalized(i,n)/result;
    end
end
 

end

