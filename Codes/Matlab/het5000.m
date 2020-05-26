clc
clear
close all
eta=.7;
z=ones(24,1);
agent=1000;
sub_agent=5000;
iteration=5;
% price=ones(24,1);
% x0=abs(.2+.1*randn(agent,1));
load('param.mat');
% x0=.2+0.02*randn(sub_agent,1);
% % x0=.2+(.4-.2)*rand(sub_agent,1);
% s=.02+(.1-.02)*rand(sub_agent,1);
q=5.8E-1;
h=.060+.009;
c=12;
demand = 1/sub_agent*[ %0~24
    87596.9000
    90705.2000
    92071.1000
    93436.5000
    94606.4000
    95196.2000
    94041.8000
    91336.1000
    88049.5000
    87088.50000
    83801.50000
    77608.80000
    71414.300000
    65605.200000
    61344.700000
    57680.300000
    57493.500000
    59443
    61775.200000
    66241.500000
    75944.700000
    80216.200000
    84487.700000
    87791.100000   
    ];
%     price=q/c*(demand)+h;
    price=.15*(demand/c).^1.5;
   tic
for iteration=1:iteration
    for qq=1:sub_agent
        var.name='price';
        var.type='parameter';
        var.form='full';
        var.val=price(:,iteration);
        var.dim=1;
        s2.name='s'; %%%%%%%%satisfiction factor
        s2.type='parameter';
        s2.val=[s(qq)];
        s2.dim=1;
        s3.name='x0';%%%%%%% initial soc
        s3.type='parameter';
        s3.val=[x0(qq)];
        s3.dim=1;
        wgdx('data2',var,s2,s3)
        gams('het5000.gms');
        ss.name='UTOTAL';
        ss.form='full';
        u=rgdx('matsol',ss);
        ss1.name='xtotal';
        ss1.form='full';
        x=rgdx('matsol',ss1);
        sigma_u(:,qq)=u.val;
        sigma_x(:,qq)=x.val;
        
    end
%     u_bar(:,iteration) = 1/sub_agent*sum(sigma_u,2);
    u_bar(iteration,:) = 1/sub_agent*sum(sigma_u,2);
   
    %     z(:,q+1) = (1-eta)* z(:,q) + eta*u_bar(q,:)';
    %     price(:,q+1) = (a1*(demand+z(:,q))+b1);
%      price(:,iteration+1) =(1-eta)*price(:,iteration)+eta*(q/c*(demand+u_bar(iteration,:)')+h);
         price(:,iteration+1) = (1-eta)*price(:,iteration)+eta*0.15*(  (demand+  u_bar(iteration,:)')/c).^1.5;

    %     price(:,iteration+1) =(1-eta)*price(:,iteration)+eta*(a1*(demand+u_bar(:,iteration))+b1);
%     norm(price(:,iteration+1)-price(:,iteration));
%     u_bar(24,:)=0;
     error_p(iteration)=norm(price(:,iteration+1)-price(:,iteration))
end
time=toc
% sigma_u(24,:)=0;
% price(24,:)=price(23,2);
% plot(demand)
% for qqq=1:iteration
%     hold on
%     plot(u_bar(:,qqq)+demand,'r')
% end