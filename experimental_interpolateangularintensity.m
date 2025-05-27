%% Import data
clear;clc;
load('A4/A4_angularintensity');
bkg=intensity;
%  bkg(180:183)=bkg(179);
load('A5/A5_angularintensity');
intensity=intensity-bkg;
%% Parameters
obj_NA=0.9; % objective NA
pxsize=0.5;
kx=[-90,kx,90];
intensity=[0,intensity',0];

%% Create mask for calculation
mask=@(x,r)(x<=r);

%% Interpolate
kx_int=-90:pxsize:90;
I_int = interp1(kx,intensity,kx_int);
%% Integrate
I_int=I_int(kx_int>=0);
kx_int=kx_int(kx_int>=0);


eta=zeros(1,length(kx_int));
total=sum(I_int);
for i1=1:length(eta)
    eta(i1)=sum(I_int(1:i1))/total;
end
figure('Position',[488.2000 109 560 652.8000])
ax1=subplot(2,1,1);
plot(kx_int,I_int,kx,intensity)
xlabel('\theta [deg]');
ylabel('I [a.u.]');
xlim([-90,90])
ax1.YLim(1)=0;
subplot(2,1,2)
plot(sind(kx_int),eta)
hold on
plot([0.9,0.9],[0,1],'-r','LineWidth',2);
xlabel('NA')
ylabel('\eta')
xlim([0,1])
ylim([0,1])
grid on