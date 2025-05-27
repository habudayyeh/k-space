
%% Read File and load data structure
% % Read background
% [FileName,PathName] = uigetfile('*.tif','Select the background data');
% bkg_image=imread([PathName,'\',FileName]);
bkg_image=imread('C:\Users\User\Google Drive\Single Photon  Project\Experiments_\Template stripping\NBATSG06\20200126_NBATSG06\after_convering\Lowerlaserpower\IIII_5D_empty\kspace_10sec.tif');
% Read Data
[FileName,PathName] = uigetfile('*.tif','Select the data file');
data=imread([PathName,'\',FileName]);

% Background reduction
data=data-bkg_image;
%% Parameters
px_size= 6.5e-6; % pixel size  [m]
kspace_mag=0.341; 
f_obj=1.9e-3; % objective focal length
NA_obj=0.9; 
cent_wl=650e-9; %emitter central wl; 
smoothing_fact=1; %interpolation smooting factor
theta=10:10:10*floor(rad2deg(asin(NA_obj))/10);
cent=[1098,711]; % center of kspace 
bkg_cent=[1103,713];
pxspan=[190,190]; % full width of kspace 
%% Crop
data=data(cent(1)-pxspan(1)/2:cent(1)+pxspan(1)/2,...
    cent(2)-pxspan(2)/2:cent(2)+pxspan(2)/2);
bkg_image=bkg_image(bkg_cent(1)-pxspan(1)/2:bkg_cent(1)+pxspan(1)/2,...
    bkg_cent(2)-pxspan(2)/2:bkg_cent(2)+pxspan(2)/2);
%% Calculate the calibration
kx_cal=px_size/(kspace_mag*f_obj); % rads per px in kx direction
ky_cal=px_size/(kspace_mag*f_obj); % rads per px in ky direction 



kx=asind((-pxspan(1)/2:pxspan(1)/2)*kx_cal);
ky=asind((-pxspan(2)/2:pxspan(2)/2)*ky_cal);

%% Intialize figure;
screensize = get( groot, 'Screensize' );
f=figure;
f.Position=[screensize(3)*0.3,screensize(4)*0.3,screensize(4)*0.5,screensize(4)*0.5];
h = axes('position',[0  0  1  1]);

%% Plot measurement
imagesc(h,kx,ky,data');
set(h,'YDir','normal')
%% Plot polar axis

for i3=1:1:length(theta)
    rectangle(h,'Position',[-1,-1,2,2]*theta(i3),'Curvature',[1,1],...
        'EdgeColor','w','LineWidth',1.5);
    text(h,(theta(i3)+2)/sqrt(2),(theta(i3)+2)/sqrt(2),...
        sprintf('%d^o',theta(i3)),'Color','w','FontSize',12)
end
% rectangle(h,'Position',[-1,-1,2,2]*asind(NA_obj),'Curvature',[1,1],...
%         'EdgeColor','r','LineWidth',1.5);
%% Save figure and data
FileName=FileName(1:strfind(FileName,'.tif')-1);
saveas(gcf,[PathName,'\',FileName,'_normlized.fig']);
save([PathName,'\',FileName,'_normlized.mat'],'kx','ky','data');