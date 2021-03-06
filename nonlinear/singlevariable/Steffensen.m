function [x, flag, iter, xs] = Steffensen(phi, x0, tol, maxIter)
% Steffensen    Accelerate convergence of fixed-point iteration.
%   X = Steffensen(PHI, X0) returns the fixed-point of the single-variable
%   function PHI using Steffensen method with X0 as initial value. PHI
%   should be a function handle taking a scalar as input and X0 should be a
%   scalar.
%
%   X = Steffensen(PHI, X0, TOL) specifies the tolerance of the method. If 
%   TOL is [] then Steffensen uses the default, 1e-6. 
%   
%   X = Steffensen(PHI, X0, TOL, MAXITER) specifies the maximum number of
%   iterations. If MAXITER is [] then Steffensen uses the default, 10.
%
%   [X, FLAG] = Steffensen(PHI, X0, ...) also returns a convergence FLAG:
%    0 Steffensen converged to the desird tolerance TOL within MAXITER
%      iterations.
%    1 Steffensen iterated MAXITER times but did not converge.
%
%   [X, FLAG, ITER] = Steffensen(PHI, X0, ...) also returns the iteration
%   number at which X was computed: 0 <= ITER <= MAXITER.
%
%   [X, FLAG, ITER, XS] = Steffensen also returns a vector of iteration
%   result at each step, length(XS) = ITER, XS(end) = X;
%
%   See also

%   Copyright 2017 Junshen Xu   

if(~isa(phi, 'function_handle'))
    error('phi should be a function handle.')
end

if(~isscalar(x0))
    error('x0 should be a scalar.')
end

if(~exist('maxIter','var') || isempty(maxIter))
    maxIter = 10;
end

if(~exist('tolerance','var') || isempty(tol))
    tol = 1e-6;
end

x = x0;
flag = 1;
if nargout > 3
    xs = zeros(maxIter, 1);
end
for iter = 1 : maxIter
    y = phi(x);
    z = phi(y);
    x_new = x - (y-x)^2/(z-2*y+x);
    if(nargout > 3)
        xs(iter) = x_new;
    end
    if(abs(x_new - x)<tol)
        x = x_new;
        flag = 0;
        break;
    end
    x = x_new;
end

if(nargout > 3)
    xs = xs(1:iter);
end

if(iter == maxIter)
    warning(['failed to converge in ', num2str(maxIter), ' iterations.']);
end


