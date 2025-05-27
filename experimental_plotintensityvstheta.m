%% Import data
clear;clc;
load('A3/A3_kspace_normalized');
%% Parameters
obj_NA=0.9; % objective NA
pxsize=0.5;

theta_NA=64;%rad2deg(asin(obj_NA));
kx=kx(abs(kx)<=theta_NA);
ky=ky(abs(ky)<=theta_NA);
data=data(abs(ky)<=theta_NA,abs(kx)<=theta_NA);
%% Create mask for calculation
mask=@(x,y,r)(x.^2+y.^2<=r.^2);
mask_ring=@(x,y,r)(x.^2+y.^2==(abs(r)).^2);

% mask_ring=@(x,y,r)(x.^2+y.^2<=(abs(r)+pxsize/10).^2 & x.^2+y.^2>=(abs(r)-pxsize/10).^2);

%% Mesh data
[KX,KY]=meshgrid(kx,ky);
ktemp=double(data);
kx_int=-theta_NA:pxsize:theta_NA;
ky_int=-theta_NA:pxsize:theta_NA;
[KX_int,KY_int]=meshgrid(kx_int,ky_int);

%% Choose data within NA 
% ind=mask(KX,KY,theta_NA)&ktemp~=0;
% kxscatter=KX(ind);
% kyscatter=KY(ind);
% kspacescatter=ktemp(ind);%-250;

% fullkspace=griddata(kxscatter,kyscatter,kspacescatter,KX_int,KY_int,'cubic');
%%
% fullkspace = interp2(KX,KY,ktemp-250,KX_int,KY_int,'linear');
%% Calculate coll eff;
tot_counts=1;%sum(sum(abs(fullkspace).*mask(KX_int,KY_int,theta_NA)));
intensity=zeros(length(kx),1);
for i1=1:length(kx)
%     counts=sum(sum(abs(fullkspace).*mask_ring(KX_int,KY_int,kx_int(i1))));
    counts=sum(sum(abs(ktemp).*mask_ring(KX,KY,kx(i1))));
    intensity(i1)=counts/tot_counts;
    if kx(i1)==0
        intensity(i1)=intensity(i1-1);
    end
end

%% Plot
screensize = get( groot, 'Screensize' );
f=figure;
f.Position=[screensize(3)*0.1,screensize(4)*0.3,screensize(4)*0.8,screensize(4)*0.4];

plot(kx,intensity)
xlabel('\theta [deg]')
ylabel I



