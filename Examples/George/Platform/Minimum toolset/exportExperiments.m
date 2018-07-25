function [duration,step,values] = exportExperiments...
    (inputs,oed,timeScale,fileName,varargin)
%experiment design - actuation module interface.
%export the experiment designs in "inputs" variable to the actuation model
%by generating a series of .txt files with the commands in the folder (one
%file for one experiment).
%by Zhaozheng Hou (George)
%
%the given parameters can be (inputs,timeScale,fileName,foldername)
% oed        -- true if want to import the experimental design from oed,
%               false if want to import from exps. It just show the
%               preference. If the field is not included, it will use the
%               other field and send a worning.
% timeScale  -- in sedonds,
% fileName   -- if the name is XXX, the name of the .txt file is XXX.txt if
%               there is only one experiment, and XXX-1.txt, XXX-2.txt,...
%               if there are multiple experiments.
% foldername -- if not given, the .txt files would be generated in the
%               current folder.
%
% output     -- the output are duration(array), step(array), and
%               values(cells).


oldCd=cd;
if (~isempty(varargin))
    folder=varargin{1};
    mkdir(folder);
    cd(folder);
end

if (oed)
    if (isfield(inputs,'oed'))
        nofExp=inputs.oed.n_exp;
        duration=cell2mat(inputs.oed.t_f)*timeScale;
        step=zeros(1,nofExp);
        values=cell(1,nofExp);
    elseif (isfield(inputs,'exps'))
        fprintf('oed field does not exist, generate designs in exps.\n');
        oed=false;
        nofExp=inputs.exps.n_exp;
        duration=cell2mat(inputs.exps.t_f)*timeScale;
        step=zeros(1,nofExp);
        values=cell(1,nofExp);
    else
        duration=[];
        step=[];
        values={};
        return;
    end
elseif (isfield(inputs,'exps'))
    nofExp=inputs.exps.n_exp;
    duration=cell2mat(inputs.exps.t_f)*timeScale;
    step=zeros(1,nofExp);
    values=cell(1,nofExp);
elseif (isfield(inputs,'oed'))
    fprintf('exps field does not exist, generate designs in oed.\n');
    oed=true;
    nofExp=inputs.oed.n_exp;
    duration=cell2mat(inputs.oed.t_f)*timeScale;
    step=zeros(1,nofExp);
    values=cell(1,nofExp);
else
    duration=[];
    step=[];
    values={};
    return;
end

for iexp=1:nofExp
    if (oed)
        difftimei=diff(inputs.oed.t_con{iexp}*timeScale);
        step(iexp)=localGcd(difftimei);
        repeati=difftimei/step(iexp);
        values{iexp}=[];
        for i=1:length(repeati)
            values{iexp}=[values{iexp},...
                repmat(inputs.oed.u{iexp}(i),1,repeati(i))];
        end
    else
        switch inputs.exps.u_interp{iexp}
            case 'sustained'
                step(iexp)=duration(iexp)*timeScale;
                values{iexp}=inputs.exps.u{iexp};
            case 'step'
                difftimei=diff(inputs.exps.t_con{iexp}*timeScale);
                step(iexp)=localGcd(difftimei);
                repeati=difftimei/step(iexp);
                values{iexp}=[];
                for i=1:length(repeati)
                    values{iexp}=[values{iexp},...
                        repmat(inputs.exps.u{iexp}(i),1,repeati(i))];
                end
            case 'pulse-up'
                timei=inputs.exps.t_con{iexp}*timeScale;
                step(iexp)=localGcd(diff(timei));
                repeati=diff(timei(1:3))/step(iexp);
                values{iexp}=[repmat(inputs.exps.u_min{iexp},1,repeati(1)),...
                    repmat(inputs.exps.u_max{iexp},1,repeati(2))];
                values{iexp}=repmat(values{iexp},1,inputs.exps.n_pulses{iexp});
            case 'pulse-down'
                timei=inputs.exps.t_con{iexp}*timeScale;
                step(iexp)=localGcd(diff(timei));
                repeati=diff(timei(1:3))/step(iexp);
                values{iexp}=[repmat(inputs.exps.u_max{iexp},1,repeati(1)),...
                    repmat(inputs.exps.u_min{iexp},1,repeati(2))];
                values{iexp}=repmat(values{iexp},1,inputs.exps.n_pulses{iexp});
            otherwise %linear case by default
                timei1=inputs.exps.t_con{iexp}*timeScale;
                step(iexp)=localGcd([timei1,inputs.exps.t_s{iexp}*timeScale]);
                if (step(iexp)> timei1(end)/100)
                    step(iexp)=step(iexp)/ceil(step(iexp)/timei1(end)*100);
                end
                values{iexp}=interp1(timei1,inputs.exps.u{iexp},0:step(iexp):timei1(end));
        end
    end
    command=[step(iexp),values{iexp}];
    if (nofExp==1)
        save([fileName,'.txt'],'command','-ascii');
    else
        save([fileName,'-',num2str(iexp),'.txt'],'command','-ascii');
    end
end
%save([fileName,'.mat'],'duration','step','values');
cd(oldCd);
end

function n = localGcd( n )
n=gcd(sym(n));
end