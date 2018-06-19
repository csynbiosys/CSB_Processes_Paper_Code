cd0=cd;
folders={'Pulse','Step','Random'}';
names={'InduciblePromoter_Pulse';
    'InduciblePromoter_Step';
    'InduciblePromoter_Random'};

fullPEresults=cell(0,10);
parameters=cell(1,8);
for index1=1:length(folders)
    cd([folders{index1},'\MatFiles']);
    for index2=1:100
        load([names{index1},'-',num2str(index2),'.mat'],...
            'best_global_theta_log');
        fullPEresults=[fullPEresults;best_global_theta_log];
    end
    for index2=1:8
        parameters{index2}=cellfun(@(x) x(index2),fullPEresults);
    end
    cd('../..');
    save([folders{index1},'.mat'],'fullPEresults','parameters');
    fullPEresults=cell(0,10); 
end