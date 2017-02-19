function steps=options(allstates,alpha,epsilon,num_episodes,gamma,num_tries,steps,termstate)
%Comparing options vs no options on gridworld domain with door.
for k=1:num_tries %Multiple runs of the code, hence we collect num_tries runs.
    fprintf('This is run number %d \n',k);
    qvalues=zeros(21*21,5); %5th action corresponds to the option of going to one of the bottleneck states
    qvaluesopt=zeros(21*21,4);
    
    for i=1:num_episodes
    count=0;
   
    curstate=[randi(10),randi(10)]; % start state in the left portion of left hall
        
    while(1)
        count=count+1;
        csi=sub2ind(size(allstates),curstate(1),curstate(2)); % convert state to index
        
        if(rand<1-epsilon) % greedy action
            if curstate(2)<16    %initiation set of option is only the left hall
                temp=find(max(qvalues(csi,:))==qvalues(csi,:));
                action=temp(randi(size(temp,2))); %Choosing an action from the maximum
            else
                temp=find(max(qvalues(csi,1:4))==qvalues(csi,1:4));
                action=temp(randi(size(temp,2)));
            end
             
        else
            if curstate(2)<16
                action=randi(5);
            else
                action=randi(4);
            end
        end
            
        if action==5
            [nextstate,qvalues,qvaluesopt,count]=executeoption(curstate,qvalues,qvaluesopt,alpha,gamma,epsilon,termstate,allstates,count);
            curstate=nextstate;
            continue;
        end
        
        [rew,nextstate,signal]=transition(curstate,action); % Environment simulator
        nsi=sub2ind(size(allstates),nextstate(1),nextstate(2)); %Index of the next state
        
        if(signal==1) %The trial has ended
            qvalues(csi,action)=qvalues(csi,action)+ alpha*(rew- qvalues(csi,action));
            fprintf('Agent has won  trial\n');
            break; 
        end
        
        
        
        if(nextstate(2)<16 ) %Can option be initiated in the next state? Only in the first hall.
            qvalues(csi,action)=qvalues(csi,action)+ alpha*(rew+ gamma*max(qvalues(nsi,:)) - qvalues(csi,action));% Qlearning update
        else
            qvalues(csi,action)=qvalues(csi,action)+ alpha*(rew+ gamma*max(qvalues(nsi,1:4)) - qvalues(csi,action));% Qlearning update
        end
        
        curstate=nextstate;
    end
        steps(i,k)=count;
        
     end 
end
steps=sum(steps,2)/num_tries;
end


        



  
  