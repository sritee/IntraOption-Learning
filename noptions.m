function steps= noptions(allstates,alpha,epsilon,num_episodes,gamma,num_tries,steps)
%Comparing options vs no options on gridworld domain with door.

for k=1:num_tries %Multiple runs of the code, hence we collect num_tries runs.
    fprintf('This is run number %d \n',k);
    qvalues=zeros(21*21,4);
    
    for i=1:num_episodes
    count=0;
    
    curstate=[randi(10),randi(10)]; %random start state in the left part of left hall
        
        while(1)
            %disp(curstate);
        count=count+1;
        csi=sub2ind(size(allstates),curstate(1),curstate(2)); % convert state to index
        
        if(rand<1-epsilon) % greedy action
            
        temp=find(max(qvalues(csi,:))==qvalues(csi,:));
        temp1=randi(size(temp,2));
        action=temp(temp1);
        else
            temp=randperm(4); % exploring action
            action=temp(1);
        end
        
        [rew,nextstate,signal]=transition(curstate,action); % Environment simulator
        nsi=sub2ind(size(allstates),nextstate(1),nextstate(2)); %Index of the next state
        
        if(signal==1) %The trial has ended
            qvalues(csi,action)=qvalues(csi,action)+ alpha*(rew- qvalues(csi,action));
            fprintf('Agent has won\n');
            break; %actionvalues for terminal state is all zero.
        end
        
        qmaxnext=max(qvalues(nsi,:));
        
        qvalues(csi,action)=qvalues(csi,action)+ alpha*(rew+ gamma*qmaxnext - qvalues(csi,action));% Qlearning update
        
        curstate=nextstate;
        end
        steps(i,k)=count;
     end 
end
steps=sum(steps,2)/num_tries;
end




  
  