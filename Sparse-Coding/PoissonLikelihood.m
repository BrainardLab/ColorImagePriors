classdef PoissonLikelihood < handle
    %PoissonLikelihood Compute the likelihood of reconstructed image.    
    
    properties
        Retina;
        ImageSize;
    end
    
    methods        
        % Constructor
        function obj = PoissonLikelihood(retina, imageSize)            
            obj.Retina = retina;
            obj.ImageSize = imageSize;
        end
        
        % Poisson log likelihood
        function llhd = poissonLlhd(obj, coneExcitation, image)            
            [~, ~, allCone] = obj.Retina.compute(image);
            idpdLlhd = -allCone + coneExcitation .* log(allCone);

            llhd = sum(idpdLlhd);
        end
        
        function loss = poissonLoss(obj, coneExcitation, image)
            image = (image - min(image)) ./ (max(image) - min(image));          
            loss  = -obj.poissonLlhd(coneExcitation, reshape(image, obj.ImageSize));
        end
    end
    
     methods(Static)
         function [reconImage, coff] = pcaRecon(likelihood, input, pcaBasis)
            % Define loss function
            priorLoss = @(x) -sum(log(normpdf(x, 0, 1)));
            loss = @(x) likelihood.poissonLoss(input, pcaBasis * x(1:end-1) + x(end)) ...
                        + priorLoss(x(1:end-1));
            
            [~, nDim] = size(pcaBasis);
            init = rand(nDim + 1, 1);
            
            % Optimization
            options = optimoptions('fmincon');
            options.MaxFunctionEvaluations = 1e5;
            options.Display = 'iter';
            options.UseParallel = true;

            coff = fmincon(loss, init, [],[],[],[],[],[],[], options);

            % Return reconstructed image
            reconImage = pcaBasis * coff(1:end-1) + coff(end);
         end
     end
    
end

