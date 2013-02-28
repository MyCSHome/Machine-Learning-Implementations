function [x y] = ANNdata(a,b);

%ANNDATA - transforms features and labels as returned by loaddata into the matlab NN toolbox format
%
% AUTHOR:	M.F. Valstar
% CREATED:	02102006
%
%IN:  a: features [n x m] 
%     b: labels   [n]
%OUT: x: features [m x n] values are 1...6
%     y: labels [6 x n] sparse matrix (0 = neg, 1 = pos)

x = a';
y = zeros(6, size(a,1));
for i = 1:6
	y(i,find(b == i)) = 1;
end