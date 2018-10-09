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

temp=smooth(temp,130);

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




%% start ANN

% % %   vc1 - input data.
% % %   cycle - target data.
Reptition=100;
Nodes=1;   
performance=zeros(Reptition,Nodes);
Rvalue=performance;

all_data=zeros(60*3,410);
for i=1:70
    all_data(1+3*(i-1),:)=Tc(i,:);
    all_data(2+3*(i-1),:)=vc1(i,:);
    all_data(3+3*(i-1),:)=Icharge(i,:);
    all_data2(1+3*(i-1),:)=Tc2(i,:);
    all_data2(2+3*(i-1),:)=vc2(i,:);
    all_data2(3+3*(i-1),:)=Icharge(i,:);
end

for j =31:31
 inputs =vd1(1:(61-j)*1,:);
%  inputs =all_data(1:71-j,:);
% inputs = Tc(1:61-j,:);
targets = cycle;
for i=1:Reptition
% Create a Fitting Network
hiddenLayerSize =7;
net = fitnet(hiddenLayerSize);


% Setup Division of Data for Training, Validation, Testing
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 64/100;
net.divideParam.valRatio = 16/100;
net.divideParam.testRatio = 20/100;
avg=0;

% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network

% errors = gsubtract(targets,outputs);
% outputs = net(inputs);
% tsOut = outputs(tr.testInd);
% tsTarg =targets(tr.testInd);

% performance(i,j) = mse(net,tsTarg,tsOut,'normalization','percent');
% %obtain NMSE for testing set
% %evaluate R square
% [r,m,b] = regression(tsTarg,tsOut);  %for testing set

% outputs_test = net(inputs(:,tr.testInd));
% cycle_test=cycle(:,tr.testInd);
% [r,m,b] = regression(cycle_test,outputs_test); 
% Rvalue_test(i,j)=r;
% err = immse(cycle_test',outputs_test');
% performance_test(i,j)=sqrt(err)/(max(cycle_test)-min(cycle_test));


outputs_test = net(inputs);
cycle_test=cycle(:,tr.testInd);
[r,m,b] = regression(cycle,outputs_test); 
Rvalue_test(i,j)=r;
err = immse(cycle',outputs_test');
performance_test(i,j)=sqrt(err)/(max(cycle)-min(cycle));

outputs_train = net(inputs(:,tr.trainInd));
cycle_train=cycle(:,tr.trainInd);
[r,m,b] = regression(cycle_train,outputs_train); 
Rvalue_train(i,j)=r;
err = immse(cycle_train',outputs_train');
performance_train(i,j)=sqrt(err)/(max(cycle_train)-min(cycle_train));

% second battery
% outputs_2 = net(vd2);
% [r,m,b] = regression(cycle,outputs_2); 
% Rvalue_2(i,j)=r;
% err = immse(cycle',outputs_2');
% performance_2(i,j)=sqrt(err)/(max(cycle)-min(cycle));

end
end
R_test=mean(Rvalue_test);
R_train=mean(Rvalue_train);
% R_2=mean(Rvalue_2);
% R_all={R_train;R_test;R_2}
nMSE_test=mean(performance_test);
%nMSE_test=sqrt(nMSE_test);
nMSE_train=mean(performance_train);
%nMSE_train=sqrt(nMSE_train);
% nMSE_2=mean(performance_2);
%nMSE_2=sqrt(nMSE_2);
% nMSE_all={nMSE_train;nMSE_test;nMSE_2};
clear Nodes Reptition outputs_train   performance_train performance r Rvalue;
clear  Rvalue_2   R_train R_2 nMSE_train 