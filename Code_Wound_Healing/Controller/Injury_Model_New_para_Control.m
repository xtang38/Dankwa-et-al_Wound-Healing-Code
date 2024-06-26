function dx = Injury_Model_New_para_Control(t,x,par)

dx = zeros(7,1);


N = x(1); %%% Neutrohpil

M0 = x(2); %%% Monocyte

M1 = x(3); %%% M1

M2 = x(4); %%% M2
 
Injury = x(5); %%% Injury 

S2 = x(6); 

S6 = x(7); 

Cmax = 1000;
Capacity = 1-(N+M1+M2+M0)/Cmax;

function y = act(Chemical,n,k)
y = Chemical^n/(k^n+Chemical^n);
end

function injury_reg = regulation(Species,Threshold)
    if Species >= Threshold
        injury_reg = 1;
    else
        injury_reg = -1;
    end
end

% function controller= control(Species,Manipulated,Ref,Kp)
%     controller= Manipulated - (Species - Ref)*Kp;
% end

% % function controller= control(nominal,Species,Manipulated,Ref,Kp)
% %     controller= max(nominal,Manipulated - (Species - Ref)*Kp);
% % end

function controller= control(Species,Manipulated,Ref,Kp)
    controller= Manipulated/max(1,(Species - Ref)*Kp);
end

% % function controller= control(Species,Ref,Kp)
% %     controller= max(0,(Species - Ref))*Kp;
% % end


% function controller= control(Chemical,Threshold,k)
% controller= max(1,(((Chemical-Threshold)/abs(Chemical-Threshold))*k));
% end

%%% ODE equations
dx(1) = N*par.alpha1*act(Injury,par.n1,par.K1)*Capacity - par.gamma1*N*S2 - par.mu1*N ; %%%N
%% reduced the deg term of N from [- par.gamma1*N*M1 - par.gamma6*N*S2 - par.mu1*N ] to [- par.gamma1*N*S2 - par.mu1*N ]
dx(2) = par.gamma6*N*S2 - par.gamma2*M0 - M0*par.mu2; %% M0
   
dx(3) = par.gamma2*M0 - par.gamma3*M1*S6 - M1*par.mu3;  %% M1

dx(4) = par.gamma3*M1*S6 - M2*par.mu4;  %% M2

dx(5) = par.alpha3*M1*Injury*regulation(M1,par.threshold) - par.gamma5*N*Injury - par.delta8*Injury; %%% injury %%%no degrdation rate

dx(6) = control(S2,par.beta1,par.S2Ref,par.Kp)*N - par.delta1*S2; % - control(S2,par.S2Ref,par.Kp)*S2;  %%% S2

dx(7) = par.gamma1*M1*N - par.delta2*S6;  %%% S6 


end
