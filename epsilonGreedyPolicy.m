function [actionIndex,positionOfAction] = epsilonGreedyPolicy( Q, actionMatrix, epsilon )
% Use the epsilon greedy policy to choose action for the given state.
% This is done to ensure sufficient exploration and exploitation

    % true actions for the given state
    trueActions = find(actionMatrix ~= 0);
    numActions = length(trueActions);
    
    if numActions > 1
        % Index of the most greedy action
        Q_max = -inf;   
        for i=1:numActions
            if Q_max < Q(trueActions(i))
                Q_max = Q(trueActions(i));
                bestActionLocation = trueActions(i);
                % reset the tieCounter and tieIndex
                tieCounter = 1; % tieCounter = 1 means no tie, tieCounter = 2 means 2 nums with a tie and so on
                tieIndex = bestActionLocation; % indexes of the location of action that have a tie in Q
            elseif Q_max == Q(trueActions(i))
                tieCounter = tieCounter + 1;
                tieIndex(tieCounter,1) = trueActions(i);
            end
        end
        
        % tie breaker - crucial for random selection when choosing between more than one optima
        if tieCounter > 1
            bestActionLocation = randsample(tieIndex, 1);
        end
        
        % true action index of best action
        bestActionIndex = actionMatrix(bestActionLocation);
        
        % all the possible actionIndices are being placed in the randSample
        myActions = actionMatrix(trueActions);
        
        % the probability distribution for the possible actions
        probDistribution = (epsilon/numActions) * ones(1,numActions);
        probDistribution(myActions == bestActionIndex) = 1 - epsilon + (epsilon/numActions);
        
        % action Index for this distribution
        actionIndex = randsample(myActions, 1, true, probDistribution);
        positionOfAction = find(actionMatrix == actionIndex);
    elseif numActions == 1
        actionIndex = actionMatrix(trueActions);
        positionOfAction = find(actionMatrix == actionIndex);
    end
end