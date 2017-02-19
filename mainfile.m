%Comparing intraoption learning vs no options on grid world task
%Domain is 21x21 grid world, wall is at 16th column, with only 2 openings
%to go into second room, which are [11,16],[10 16], these openings are the
%target of the options.
clc;
close all;
allstates=zeros(21,21);   %Grid world
alpha=0.1; % step size parameter
epsilon=0.1; % exploration parameter
num_episodes=100; % episode per run.
gamma=0.90; % discount parameter
num_tries=3;  %number of runs of the code for smoothing
goalstate=[21,21]; %bottom right corner
steps=zeros(num_episodes,num_tries);
termstate=[11 16;10 16]; %option termination states.
 
withoptionstep=options(allstates,alpha,epsilon,num_episodes,gamma,num_tries,steps,termstate);
noptionsstep=noptions(allstates,alpha,epsilon,num_episodes,gamma,num_tries,steps);

plot(3:num_episodes,withoptionstep(3:end));
hold on;
xlabel('Number of episodes elapsed');
ylabel('Steps to goal');
pause;
plot(3:num_episodes,noptionsstep(3:end));
legend('Intra Option Qlearning','No options');
title('Intra option Q learning vs no options');
hold off;