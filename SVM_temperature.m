clear;
load Dataofbattery.mat
%% start trunctate data to 410 cycles
vc1=vc1(:,251:660);
vc2=vc2(:,251:660);
vc3=vc3(:,251:660);
vd2=vd2(:,251:660);
vd1=vd1(:,251:660);
vd3=vd3(:,251:660);
cycle=(1:410);
% obtain average surface temperature of melexsis data
temp=Tmel3d(3:11,2:3,:);
avgT=mean(mean(temp));
temp=avgT(1,1:fix(length(avgT)/130)*130);
temp=reshape(temp,130,length(temp)/130);
Tc=temp(1:70,:);
Td=temp(71:130,:);
Tc=Tc(:,251:660);
Td=Td(:,251:660);
% obtain ambient temperature, and subtract it
load ambT.mat
temp=Tamb(1,1:fix(length(Tamb)/130)*130);
temp=reshape(temp,130,length(temp)/130);
Tambc=temp(1:70,:);
Tambd=temp(71:130,:);
clear temp;
Tambc=Tambc(:,251:660);
Tambd=Tambd(:,251:660);


Tc=Tc-Tambc;
Td=Td-Tambd;
Tc=mat2gray(-Tc);
Td=mat2gray(-Td);





%% obtain grid data
 load GridEyedata.mat
temp=Tge3d(2:5,3:4,:);
avgT=mean(mean(temp));
temp=avgT(1,1:fix(length(avgT)/130)*130);
temp=reshape(temp,130,length(temp)/130);
Tc2=temp(1:70,:);
Td2=temp(71:130,:);
Tc2=Tc2(:,251:660);
Td2=Td2(:,251:660);

temp=Tge3d(2:5,5:6,:);
avgT=mean(mean(temp));
temp=avgT(1,1:fix(length(avgT)/130)*130);
temp=reshape(temp,130,length(temp)/130);
Tc3=temp(1:70,:);
Td3=temp(71:130,:);
Tc3=Tc3(:,251:660);
Td3=Td3(:,251:660);

temp=Tamb2(1,1:fix(length(Tamb2)/130)*130);
temp=reshape(temp,130,length(temp)/130);
Tambc=temp(1:70,:);
Tambd=temp(71:130,:);
clear temp;
Tambc=Tambc(:,251:660);
Tambd=Tambd(:,251:660);

Tc2=Tc2-Tambc;
Td2=Td2-Tambd;
Tc3=Tc3-Tambc;
Td3=Td3-Tambd;

Tc2=mat2gray(Tc2);
Td2=mat2gray(Td2);
Tc3=mat2gray(Tc3);
Td3=mat2gray(Td3);


%% load current data
load currentdata.mat;
Icharge=Icharge(:,251:660);
Idischarge=Idischarge(:,251:660);
%% creating training and testing
inputs=Tc;
reptition=60;   %can be nodes

for i=21:31
p = randperm(length(inputs),fix(length(inputs)/3*2));
cycle(p) = [];
q=cycle;
cycle=(1:410);

cycletraining = cycle(:,p);
cycletesting = cycle(:,q);
%%-------------training for battery 2-----------
training = inputs(1:71-i,p);
testing = inputs(1:71-i,q);

%% SVM testing for tempearture


Mdl = fitrsvm(training',cycletraining','OptimizeHyperparameters','auto',...
   'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
   'expected-improvement-plus','MaxObjectiveEvaluations',30,'ShowPlots',0));
% Mdl = fitrsvm(training',cycletraining','Standardize',true,'KernelFunction','gaussian')
% outputs=predict(Mdl,Td2');
% [r,m,b] = regression(outputs',cycle);
% Rvalue(i)=r;
% err = immse(outputs',cycle);
% performance(i)=sqrt(err)/(max(cycle)-min(cycle));

outputs=predict(Mdl,testing');
[r,m,b] = regression(outputs',cycletesting);
Rvalue(i)=r;
err = immse(outputs',cycletesting);
performance(i)=sqrt(err)/(max(cycletesting)-min(cycletesting));
close all;
end
nMSE=mean(performance);
Ravg=mean(Rvalue);
% % Rsq2 = 1 - sum((cycle' - outputs).^2)/sum((cycle' - mean(cycle')).^2);
% %  r=sqrt(Rsq2)
%%

