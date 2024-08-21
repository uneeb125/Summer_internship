function [ EnergyConsumption ] = minEnergyNetwork( nodes )
    EnergyConsumption = 0;
    for target = 1:(length(nodes)/2)
        EnergyConsumption = EnergyConsumption +  minEnergyRouting(target,nodes);
end
