function [ C] = multi
anova_result=anova;
for i=1:6
    stats = anova_result{i}(3);
    C{i}=multcompare(stats{1});
end


end

