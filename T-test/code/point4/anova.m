function [ anovo_result,m] = anova
tree=struct2cell(load('tree.mat'));
ann=struct2cell(load('ANN.mat'));
cbr=struct2cell(load('CBR.mat'));
for i=1:6
    combination{i}=[tree{1}(:,i) ann{1}(:,i) cbr{1}(:,i)];
    [p,anovatab,stats]=anova1(combination{i});
    anovo_result{i}={p,anovatab,stats};
end

for i=1:6
     b = anovo_result{i}(1);
     m(i)= cell2mat(b);
end
for i = 1:12
    close
end

end

