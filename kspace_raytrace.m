%%% This code simulates the k-space resulting from a 3 lens configuration
%%% using ray-tracing analysis. 
% This technique is inaccurate for angles above ~ 30 deg but is still used
% in practice as an approximation
% All lengths are in mm and angles are in rad. 
%% Parameters 
fo=3.6 ; % Objective f
NAo=0.65; % NA objective
fk=1000; % k-space lens
Dk=25.4; % lens diameter
fc=400; % camera lens
Dc=25.4; % lens diameter
h_kc=500;% distance between k-space and camera lenses
n_rays=3; % number of rays from each point;
d_pt=0.03; % seperation btw points in sample plane; 
ray_width=1; %linewidth for ray 

% Calculate heights
im_len=2*fo*tan(asin(NAo)); % obj_pupil=max image size
max_diam=max([im_len,Dk,Dc]); % maximum diameter in system;
%% Initiate figure
fig=figure;
fig.Units='centimeters';
fig.Position=[5,5,20,8];
ax2=subplot(1,2,2,'Position',[0.75,0.1,0.2,0.8]);
ax2.Visible='off';
ax=subplot(1,2,1);
%ax=axes();
ax.Position=[0.05,0.07,0.65,0.9];
% Plot objects
plot(ax,[0,0],[-im_len/2,im_len/2],':k','LineWidth',3)% image plane
text(0,-im_len/2-1,sprintf('Image\nPlane'),...
    'FontName','TimesNewRoman','FontSize',8,'HorizontalAlignment','center');
hold on

plot(ax,[fo,fo],[-im_len/2,im_len/2],'-k',[2*fo+fk,2*fo+fk],[-Dk/2,Dk/2],'-k',...
    [2*fo+fk+h_kc,2*fo+fk+h_kc],[-Dc/2,Dc/2],'-k',...
    [2*fo+fk+h_kc+fc,2*fo+fk+h_kc+fc],[-Dc/2,Dc/2],':k','LineWidth',3)
hold on
%% Image to objective; 

% Array of possible rays (columns rep each ray)
pt1_ray=[d_pt/2*ones(1,n_rays); linspace(-1*atan(im_len/(2*fo)),...
    atan(im_len/(2*fo)),n_rays)];%up
pt2_ray=[zeros(1,n_rays); linspace(-1*atan(im_len/(2*fo)),...
    atan(im_len/(2*fo)),n_rays)]; % center
pt3_ray=[-d_pt/2*ones(1,n_rays); linspace(-1*atan(im_len/(2*fo)),...
    atan(im_len/(2*fo)),n_rays)];%down

plot(ax,[0,0,0],[pt1_ray(1,1),pt2_ray(1,1),pt3_ray(1,1)],...
    'xk','MarkerSize',10); %pts
hold on 
% transfer to objective
T0o=[1 fo;0 1];
pt1_ray_t=T0o*pt1_ray;
pt2_ray_t=T0o*pt2_ray;
pt3_ray_t=T0o*pt3_ray;

% plot first rays
plot(ax,[zeros(1,n_rays);fo*ones(1,n_rays)],...
    [pt1_ray(1,:);pt1_ray_t(1,:)],...
    'LineStyle','--','LineWidth',ray_width);
hold on 
ax.ColorOrderIndex=1;

plot(ax,[zeros(1,n_rays);fo*ones(1,n_rays)],...
    [pt2_ray(1,:);pt2_ray_t(1,:)],...
    'LineStyle','-','LineWidth',ray_width);
hold on 
ax.ColorOrderIndex=1;

plot(ax,[zeros(1,n_rays);fo*ones(1,n_rays)],...
    [pt3_ray(1,:);pt3_ray_t(1,:)],...
    'LineStyle',':','LineWidth',ray_width);
hold on 
ax.ColorOrderIndex=1;


%% Objective -> k-space 
Mo=[1 0; -1/fo,1];
pt1_ray=Mo*pt1_ray_t;
pt2_ray=Mo*pt2_ray_t;
pt3_ray=Mo*pt3_ray_t;

% transfer to k-space lens
Tok=[1 fo+fk;0 1];
pt1_ray_t=Tok*pt1_ray;
pt2_ray_t=Tok*pt2_ray;
pt3_ray_t=Tok*pt3_ray;

plot(ax,[fo*ones(1,n_rays);(2*fo+fk)*ones(1,n_rays)],...
    [pt1_ray(1,:);pt1_ray_t(1,:)],...
    'LineStyle','--','LineWidth',ray_width);
hold on 
ax.ColorOrderIndex=1;

plot(ax,[fo*ones(1,n_rays);(2*fo+fk)*ones(1,n_rays)],...
    [pt2_ray(1,:);pt2_ray_t(1,:)],...
    'LineStyle','-','LineWidth',ray_width);
hold on 
ax.ColorOrderIndex=1;

plot(ax,[fo*ones(1,n_rays);(2*fo+fk)*ones(1,n_rays)],...
    [pt3_ray(1,:);pt3_ray_t(1,:)],...
    'LineStyle',':','LineWidth',ray_width);
hold on 
ax.ColorOrderIndex=1;


%% k-space -> Camera 
Mk=[1 0; -1/fk,1];
pt1_ray=Mk*pt1_ray_t;
pt2_ray=Mk*pt2_ray_t;
pt3_ray=Mk*pt3_ray_t;

% transfer to camera lens 
Tkc=[1 h_kc;0 1];
pt1_ray_t=Tkc*pt1_ray;
pt2_ray_t=Tkc*pt2_ray;
pt3_ray_t=Tkc*pt3_ray;

plot(ax,[(2*fo+fk)*ones(1,n_rays);(2*fo+fk+h_kc)*ones(1,n_rays)],...
    [pt1_ray(1,:);pt1_ray_t(1,:)],...
    'LineStyle','--','LineWidth',ray_width);
hold on 
ax.ColorOrderIndex=1;

plot(ax,[(2*fo+fk)*ones(1,n_rays);(2*fo+fk+h_kc)*ones(1,n_rays)],...
    [pt2_ray(1,:);pt2_ray_t(1,:)],...
    'LineStyle','-','LineWidth',ray_width);
hold on 
ax.ColorOrderIndex=1;

plot(ax,[(2*fo+fk)*ones(1,n_rays);(2*fo+fk+h_kc)*ones(1,n_rays)],...
    [pt3_ray(1,:);pt3_ray_t(1,:)],...
    'LineStyle',':','LineWidth',ray_width);
hold on 
ax.ColorOrderIndex=1;


%% k-space -> Camera 
Mc=[1 0; -1/fc,1];
pt1_ray=Mc*pt1_ray_t;
pt2_ray=Mc*pt2_ray_t;
pt3_ray=Mc*pt3_ray_t;

%transfer to image plane 
Tci=[1 fc;0 1];
pt1_ray_t=Tci*pt1_ray;
pt2_ray_t=Tci*pt2_ray;
pt3_ray_t=Tci*pt3_ray;

plot(ax,[(2*fo+fk+h_kc)*ones(1,n_rays);(2*fo+fk+h_kc+fc)*ones(1,n_rays)],...
    [pt1_ray(1,:);pt1_ray_t(1,:)],...
    'LineStyle','--','LineWidth',ray_width);
hold on 
ax.ColorOrderIndex=1;

plot(ax,[(2*fo+fk+h_kc)*ones(1,n_rays);(2*fo+fk+h_kc+fc)*ones(1,n_rays)],...
    [pt2_ray(1,:);pt2_ray_t(1,:)],...
    'LineStyle','-','LineWidth',ray_width);
hold on 
ax.ColorOrderIndex=1;

plot(ax,[(2*fo+fk+h_kc)*ones(1,n_rays);(2*fo+fk+h_kc+fc)*ones(1,n_rays)],...
    [pt3_ray(1,:);pt3_ray_t(1,:)],...
    'LineStyle',':','LineWidth',ray_width);
hold on 
ax.ColorOrderIndex=1;

set(ax,'XLim',[-(fo+fk+h_kc+fc)/20,fo+fk+h_kc+fc+(fo+fk+h_kc+fc)/20],...
    'YLim',[-max_diam/2-1,max_diam/2+1],'Visible', 'on');
hold off 

%% Calculate magnification and scaling
TotM=Tci*Mc*Tkc*Mk*Tok*Mo*T0o;
Scaling=TotM(1,2);
OrgK_Mat=[1 fo;0 1]*Mo*T0o;

Mag=Scaling/OrgK_Mat(1,2);

text(ax2,0,1,sprintf('Mag= %.2f\nCal= %.2f rad/mm\n      = %.2f deg/mm',...
    Mag,Scaling,Scaling*180/pi),'FontName','TimesNewRoman')