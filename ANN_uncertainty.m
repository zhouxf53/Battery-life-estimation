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
%% tc following normal distribution, monte carlo sampling
cn=205;

Tc=Tc-Tambc;
Td=Td-Tambd;

% for i=1:70
% % MC_Tc(i,:) = normrnd(Tc(i,200)',0.01,1,100); %normal distribution
%  MC_Td(i,:)= unifrnd(Tc(i,cn)-0.01,Tc(i,cn)+0.01,1,1000);
% end 

%  MC_Td=mat2gray(-MC_Td,[min(-Tc(:)),max(-Tc(:))]);
 Tc=mat2gray(-Tc,[min(-Tc(:)),max(-Tc(:))]);
 Td=mat2gray(-Td,[min(-Td(:)),max(-Td(:))]);

%% start ANN

% % %   vc1 - input data.
% % %   cycle - target data.
Reptition=1;
Nodes=1;
performance=zeros(Reptition,Nodes);
Rvalue=performance;
for j =1:Nodes
 inputs =Td(1:61-j,:);
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

outputs_test = net(inputs(:,tr.testInd));
cycle_test=cycle(:,tr.testInd);
[r,m,b] = regression(cycle_test,outputs_test); 
performance_test(i,j) = mse(net,cycle_test,outputs_test,'normalization','percent');
Rvalue_test(i,j)=r
outputs_normal = net(inputs(:,cn));



% outputs_train = net(inputs(:,tr.trainInd));
% cycle_train=cycle(:,tr.trainInd);
% [r,m,b] = regression(cycle_train,outputs_train); 
% performance_train(i,j) = mse(net,cycle_train,outputs_train,'normalization','percent');
% Rvalue_train(i,j)=r;
% % second battery
% outputs_2 = net(vd2);
% [r,m,b] = regression(cycle,outputs_2); 
% performance_2(i,j) = mse(net,cycle,outputs_2,'normalization','percent');
% Rvalue_2(i,j)=r;

end
end

%%
%go to conf_interval.m
%%

