clear all
%close all
%
clc

prop=@(d) [1,d;0,1]; %free space ray propagation with distance "d"
lens=@(f)[1,0;-1/f,1]; %lens with focal "f" ray propagation


% % syms d x0 t0 f1 f2 d1 d2
f1=0.192;
f2=1.6;
d=175;

syms R t 
%distance to go between lenses
d=[f1 d f2];
x=[0 cumsum(d)];

scr=get(0,'ScreenSize');
figure('position',[scr(3)*.25, scr(4)*.25, scr(3)*.5 scr(4)*.5])
hold on;

x0=(-1:0.5:1)*2e-4;
t0=(-0.9:0.1:0.9);
% x0=0.1;
% t0=0;
cmap=jet;
for i1=1:length(x0)
    for j1=1:length(t0)
        a=[0; 0];
        org=[x0(i1); t0(j1)];
        a(:,1)=org;
        a(:,2)=prop(d(1))*a(:,end);
        a(:,3)=prop(d(2))*lens(f1)*a(:,end);
        a(:,4)=prop(d(3))*lens(f2)*a(:,end);

        
%         A=prop(d(4))*lens(f3)*prop(d(3))*lens(f2)*prop(d(2))*lens(f1)*prop(d(1));
%         fin=A*[R; t];
        plot(x,a(1,:),'Color',cmap(floor(64/length(x0))*i1,:),'LineWidth',2)
%         plot(x,a(1,:),'Color',cmap(floor(64/length(t0))*j1,:),'LineWidth',2)
    end
    
end
plot([x(1) x(end)], [0 0],'-.')
set(gca,'FontSize',16)
box on
xlabel('x (cm)')
ylabel('y (cm)')
y=get(gca,'YLim');
plot(repmat(x,2,1),repmat(y',1,length(x)),'k--')
title (['f_1=',num2str(f1),'; f_2=',num2str(f2)])
%set(gca,'XTick',x(1):10:x(end))
axis tight
