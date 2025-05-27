%%% This code simulates the image of the kspace at 1st order of
%%% spectrometer due to a linear grating of period L. 
clear;
clc;
%% Parameters
lambda_start=525; %[nm]
lambda_stop=850; %[nm]
lambda_res=1; %[nm]
L=700;
NA_obj=0.65; 
k_res=0.001;
%% 
lambda=lambda_start:lambda_res:lambda_stop;
k=-NA_obj:k_res:NA_obj;
[Lambda,K]=meshgrid(lambda,k);
img=zeros(length(lambda),length(k));
for i1=1:1:length(lambda)
    for i2=1:1:length(k)
        if k(i2)<NA_obj-lambda(i1)/L || k(i2)>-NA_obj+lambda(i1)/L
            img(i1,i2)=1;
        end
    end
end
imagesc(lambda,k,img');
colormap('gray')
