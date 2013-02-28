function [ta_ac_tc ] = t_test
tree=struct2cell(load('tree.mat'));
ann=struct2cell(load('ANN.mat'));
cbr=struct2cell(load('CBR.mat'));
for i=1:6
    tree_ann(1,i)=ttest2(tree{1}(:,i),ann{1}(:,i));
    ann_cbr(1,i)=ttest2(ann{1}(:,i),cbr{1}(:,i));
    cbr_tree(1,i)=ttest2(cbr{1}(:,i),tree{1}(:,i));
end

ta_ac_tc = [tree_ann;ann_cbr;cbr_tree];
end

