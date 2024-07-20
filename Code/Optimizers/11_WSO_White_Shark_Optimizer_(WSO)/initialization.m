%% White Shark Optimizer (WSO)

% Initialization of the first population of search agents
function pos=initialization(whiteSharks,dim,ub_,lb_)

% number of boundaries
BoundNo= size(ub_,1); 

% If the boundaries of all variables are equal and user enters one  number for both ub_ and lb_

if BoundNo==1
    pos=rand(whiteSharks,dim).*(ub_-lb_)+lb_;
end

% If each variable has different ub_ and lb_

if BoundNo>1
    for i=1:dim
        ubi=ub_(i);
        lbi=lb_(i);
        pos(:,i)=rand(whiteSharks,1).*(ubi-lbi)+lbi;
    end
end