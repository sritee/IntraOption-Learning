function [nextstate,qvalues,qvaluesopt,count]=executeoption(curstate,qvalues,qvaluesopt,alpha,gamma,epsilon,termstate,allstates,count)
%here the termination set is a single state which is the goal state of the
%option.
 while(1)
 csi=sub2ind(size(allstates),curstate(1),curstate(2));
  if(rand<1-epsilon) % greedy action
        temp=find(max(qvaluesopt(csi,:))==qvaluesopt(csi,:));  count=count+1;

        action=temp(randi(size(temp,2)));
  else
      action=randi(4);
  end
        [rew,nextstate,~]=transition(curstate,action); % Environment simulator
        nsi=sub2ind(size(allstates),nextstate(1),nextstate(2)); %Index of the next state
        
        if(isequal(nextstate,termstate(1,:))||isequal(nextstate,termstate(2,:))) %The option has ended
           qvaluesopt(csi,action)=qvaluesopt(csi,action)+ alpha*(rew+1 - qvaluesopt(csi,action)); %extra reward for completing option
           qvalues(csi,5)=qvalues(csi,5)+ alpha*(rew+ gamma*max(qvalues(nsi,1:4))-qvalues(csi,5));
            break;
        end
        %disp(curstate);
        
        
        qmaxnext=qvalues(nsi,5); % for internal policy of option
        qmaxnexttwo=max(qvaluesopt(nsi,:)); %option value update
        
        qvalues(csi,5)=qvalues(csi,5)+ alpha*(rew+ gamma*qmaxnext - qvalues(csi,5));% Qlearning update
        qvaluesopt(csi,action)=qvaluesopt(csi,action)+ alpha*(rew+ gamma*qmaxnexttwo - qvaluesopt(csi,action));% Qlearning update
        qvalues(csi,action)=qvalues(csi,action) + alpha*(rew+ gamma*max(qvalues(nsi,1:4)) - qvalues(csi,action));
        curstate=nextstate;
 end
end