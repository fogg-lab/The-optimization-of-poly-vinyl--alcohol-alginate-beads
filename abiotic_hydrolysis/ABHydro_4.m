%Harris,Conor
clear all;close all;clc

%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 7);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "B1:H8";

% Specify column names and types
opts.VariableNames = ["VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7","VarName8"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double","double"];

% Import the data
verifydata = readtable("verify_data_v1_v3.xlsx", opts, "UseExcel", false);

%% Convert to output type
verifydata = table2array(verifydata);

%% Clear temporary variables
clear opts
name2 = [{'1'}; {'2'}];
cats = categorical(name2)
cats = reordercats(cats,name2);


num_sam = 2;
reps = 3;

% d = [1;4;9;13;16;20;27;34];
% PA = [14212672, 15076111,14248536,13528165,16095041,15588911,5704898,7981656,5203380;...
%     19042521,20273445,21343262,20156585,21308728,21750763,13228725,15016131,10507746;...
%     24462759,25491208,25021992,27215435,27563393,26935800,19967720,21722678,19057495;...
%     31643271,32432389,32530069,31178879,33656020,33070557,27875729,33605037,29064388;...
%     37715031,37422629,39798976,40321329,41670205,41246262,34239832,42781864,38799124]; %B1, B2, B3, W1, W2, W3
% % RF=5.41E-06;
d = verifydata(:,1);
PA = verifydata(:,2:end);

MWBut = 74.121; %ug/umol

mlb = 100./1000; %L in bottle
mli = 51.7*10^(-6);%uL pulled from bottle
% mli = mlb;
mlf = 25*10^(-3)+51.7*10^(-6); % uL in voa 
concf = mli./mlf; % concentration factor ml_initial / ml_final
df = 1./concf; %dilution factor volume %ml_final / ml_initial
% conc = PA.*RF; %ug/L
% mmoh = 128543;
% bmoh = -599920;
mmoh = 128231;
bmoh = -4222;
conc = (PA-bmoh)./(mmoh); %ug/L
% conc = conc./concf./1000;
% conc = conc;
%*mlb./MWBut*1000;
%.*mlb./MWBut;
conc = conc*df; % ug/L
conc= conc./(74.121); % umol/L
conc = (100./1000)*conc; % umol
% conc = conc*10^(-6); %umol



c=1
sz = size(conc);
for i = 1:sz(2);
    rates(:,i) = polyfit(d,conc(:,i),1);
end

for i = 1:num_sam
    for m = 1:sz(1)
    c_mean(m,i) = mean(conc(m,c:(c+reps-1)));
    c_std(m,i) = std(conc(m,c:(c+reps-1)));
    end
    r_mean(:,i) = mean(rates(1,c:(c+reps-1)))./2;
    r_std(:,i) = std(rates(1,c:(c+reps-1)))./2;
    c = c+reps;
end
x = [0:10:100]
for j = 1:num_sam
f(:,j) = polyfit(d,c_mean(:,j),1);
fit1(:,j) = x*f(1,j) + f(2,j);
end

leg = length(c_std);

ind = find(c_std < 0.0001);
c_std(ind) = NaN;

shapes = {'o','d'}
lines = {'--','-'}
fontsz = 22;
figure(1)
hold on
for j = 1:num_sam
% pk(j) = plot(d,c_mean(:,j),'-','LineWidth',2);
err(j) = errorbar(d,c_mean(:,j),c_std(:,j),'LineWidth',1,'CapSize',16, 'LineStyle','none','Color',[0 0 0]);
err(j).Color(4) = 0.75;
pks(j) = scatter(d,c_mean(:,j),200,'Marker',shapes{j},'LineWidth',1.5,'CData',[0 0 0]);%'MarkerEdgeColor',pk(j).Color,'MarkerFaceColor',pk(j).Color,'MarkerEdgeAlpha',0.5,'MarkerFaceAlpha',0.2);%,'Marker','.','Size',30,'MarkerFaceColor','auto','MarkerFaceAlpha',0.2);
pkl(j) = plot(x,fit1(:,j),lines{j},'LineWidth',3,'Color',pks(j).CData);
pkl(j).Color(4) = 0.5;

end

[ lgd(i), objh ] = legend([pks(1) pks(2) ],{'Optimal';'Pessimal'},'Location','NorthWest','FontSize',fontsz);
objhl = findobj( objh, 'type', 'patch' ); %// objects of legend of type line
set( objhl, 'Markersize',11 ); %// set marker size as desired
set( objhl, 'LineWidth',2 ); %// set marker size as desired
% text(10,0.04,['k_{TBOS,1} =' num2str(f(1,1)) '[umol d^{-1}]'])
ax = gca;
ax.XLim = [0 40];
ax.YLim = [0 400];
ylab = ylabel({'\boldmath$\mathsf{1-BuOH \: [ \mu mol]}$'});
ylab.Interpreter = 'latex'
ylab.FontSize = fontsz;
ylab.FontWeight = 'bold'
xlab = xlabel({'\boldmath$\mathsf{Time \: [d]}$'});
xlab.Interpreter = 'latex'
xlab.FontWeight = 'bold'
xlab.FontSize = fontsz;
ax.LineWidth = 3;
ax.FontSize = 22;
ax.FontWeight = 'bold';
box on


hold off

figure(2)
hold on
b = bar(cats,r_mean);
err = errorbar(cats,r_mean,r_std,'LineStyle','none','linewidth',2,'Color','k')
b(1).FaceColor = '#999999'; %'#a6a6a6'
% b(1).EdgeColor = '#999999';
b(1).FaceAlpha = 0.4;
b.LineWidth = 3;
ylab = ylabel({'';'\boldmath$\mathsf{k_{1-BuOH} \: [\frac{ \mu mol \: 1-BuOH}{g_{bead} \: d}]}$'});
ylab.Interpreter = 'latex'
xlab = xlabel({'\boldmath$\mathsf{Experiment}$'});
xlab.Interpreter = 'latex'

high = 1.15;
low = 1.1;
asth = 1.25;

plot([1,1],[(max(r_mean(:,1))*low) (max(r_mean(:,2))*high)],'k-') 
plot([1,2],[(max(r_mean(:,2))*high) (max(r_mean(:,2))*high)],'k-')
plot([2,2],[(max(r_mean(:,2))*high) (max(r_mean(:,2))*low)],'k-')
text(mean([1 2]), (max(r_mean(:,2))*asth), '\ast','FontSize',24)

ax = gca;
ax.YLim = [0 5];
ytickformat('%.1f')
ax.LineWidth = 3;
ax.FontSize = 22;
ax.FontWeight = 'bold';
xticklabels({'\boldmath$\mathsf{Optimal}$','\boldmath$\mathsf{Pessimal}$'})
ax.TickLabelInterpreter = 'latex';
% b.FaceAlpha = 0.60;
% b(2).FaceColor = '#a6a6a6'; 
box on
hold off
