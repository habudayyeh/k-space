%% Parameters
px_size= 6.5; % pixel size  [um]
f_obj=1.9e-3; % objective focal length
f_img=30e-2;
center_px=[1065,716];
pxspan=[480,480];
mag=f_img/f_obj;
%% Read
% Read white
[FileName,PathName] = uigetfile('*.tif','Select the white light image');
white=double(imread([PathName,'\',FileName]));

% Read flourscence
[FileName,PathName] = uigetfile('*.tif','Select the flourscence image');
flour=double(imread([PathName,'\',FileName]));

% Create x, y arrays
x=1:size(white,1);
y=1:size(white,2);

%% Crop
x=x-center_px(1);
y=y-center_px(2);
x=x(center_px(1)-pxspan(1)/2:center_px(1)+pxspan(1)/2);
y=y(center_px(2)-pxspan(2)/2:center_px(2)+pxspan(2)/2);
white=white(center_px(1)-pxspan(1)/2:center_px(1)+pxspan(1)/2,...
    center_px(2)-pxspan(2)/2:center_px(2)+pxspan(2)/2);
flour=flour(center_px(1)-pxspan(1)/2:center_px(1)+pxspan(1)/2,...
    center_px(2)-pxspan(2)/2:center_px(2)+pxspan(2)/2);
%% Convert to distance
x=x*px_size/mag;
y=y*px_size/mag;

%% Inititate figure and plot
f=figure('Units','pixels','Position',[385 341.8000 1084 420.0000]);
subplot(1,2,1)
imagesc(x,y,(white.^2)');
xlabel('x [\mum]');
ylabel('y [\mum]');
colormap('gray')

subplot(1,2,2)
imagesc(x,y,flour');
xlabel('x [\mum]');
ylabel('y [\mum]');

% colormap('jet')
saveas(gcf,[PathName,'\','realspace_normlized.fig']);