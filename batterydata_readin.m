clear;
m = 1;
d = fopen('datafile.asc');

while ~feof(d)
  tline = fgetl(d);
  A(m).data = tline;
  m = m+1;
end
fclose(d);



%% Preallocate B to a cell array
C =struct2table(A);
C=table2array(C); 
C = C(~cellfun(@isempty, C));
%% current data

for i=1:(fix(length(C)/18))-1
    current(i)=C(17+i*18);
end

current=[cellfun(@str2num, current(:,1:end))];

%% voltage data
for i=1:(fix(length(C)/18))-1
    voltage(i)=C(18+i*18);
end
D = regexp(voltage, ' ', 'split');
newA = [D{:}]; %to redistribute into individual cells.
newA=[cellfun(@str2num, newA(:,1:end))];
voltage=reshape(newA,3,length(voltage));
%plot three lines
%plot(voltage(:,1:1000)')

 %% melexsis data
% for i=1:(fix(length(C)/18))-2  %-2 to discard the last data, might be incomplete
%     Tmel(4*i-3)=C(3+i*18);
%     Tmel(4*i-2)=C(4+i*18);
%     Tmel(4*i-1)=C(5+i*18);
%     Tmel(4*i-0)=C(6+i*18);
% end
% D = regexp(Tmel, ' ', 'split');
% newA = [D{:}]; %to redistribute into individual cells.
% newA=[cellfun(@str2num, newA(:,1:end))];
% Tmel=reshape(newA,64,length(newA)/64);
% Tmel3d=reshape(Tmel,16,4,length(Tmel));

%% grid-eye data
% for i=1:(fix(length(C)/18))-2  %-2 to discard the last data, might be incomplete
%     Tge(8*i-7)=C(8+i*18);
%     Tge(8*i-6)=C(9+i*18);
%     Tge(8*i-5)=C(10+i*18);
%     Tge(8*i-4)=C(11+i*18);
%     Tge(8*i-3)=C(12+i*18);
%     Tge(8*i-2)=C(13+i*18);
%     Tge(8*i-1)=C(14+i*18);
%     Tge(8*i-0)=C(15+i*18);
% end
%  D = regexp(Tge, ' ', 'split');
%  newA = [D{:}]; %to redistribute into individual cells.
%  newA = newA(~cellfun(@isempty, newA));
%  newA=[cellfun(@str2num, newA(:,1:end))];
%  Tge=reshape(newA,8*8,length(newA)/64);
% 
%  Tge3d=reshape(Tge,8,8,length(Tge));
% 
% %% ambient T
% for i=1:(fix(length(C)/18))-1
%     Tamb2(i)=C(16+i*18);
% end
% 
% Tamb2=[cellfun(@str2num, Tamb2(:,1:end))];