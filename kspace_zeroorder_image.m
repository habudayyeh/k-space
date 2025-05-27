%%% This code simulates the image of the kspace unresolved by wavelength
%%% due to a linear grating of period L. 

%% Parameters
cent_wl=500; %[nm]
delta_wl=5; % [nm]
NA_obj=0.65; 
L=1000; % [nm]

%% Calculate ti vs. tr 
ti=linspace(0,asin(NA_obj),1000);
tr=asin(cent_wl/L-sin(ti));
tr_pdelta=asin((cent_wl+delta_wl)/L-sin(ti));
tr_mdelta=asin((cent_wl-delta_wl)/L-sin(ti));

figure;
rectangle('Position',[0,0,asind(NA_obj),asind(NA_obj)],'FaceColor','y');
hold on
plot(rad2deg(ti),rad2deg(tr),'-b',...
    rad2deg(ti),rad2deg(tr_pdelta),'--b',...
    rad2deg(ti),rad2deg(tr_mdelta),'--b');
xlabel('Incident')
ylabel('Reflected')
title('Angles')
hold off

figure;
rectangle('Position',[0,0,NA_obj,NA_obj],'FaceColor','y');
hold on
plot(sin(ti),sin(tr),'-b',...
    sin(ti),sin(tr_pdelta),'--b',...
    sin(ti),sin(tr_mdelta),'--b');
xlabel('Incident')
ylabel('Reflected')
title('Par. k')
hold off



%% Calculate shape of k-space
figure;
ax=axes('Color','k');
rectangle('Position',[-NA_obj+cent_wl/L,-NA_obj,2*NA_obj,2*NA_obj],...
    'Curvature',[1 1],'FaceColor','w')
rectangle('Position',[-NA_obj-cent_wl/L,-NA_obj,2*NA_obj,2*NA_obj],...
    'Curvature',[1 1],'FaceColor','w')
ax.XLim=[-NA_obj,NA_obj];
ax.YLim=[-NA_obj,NA_obj];