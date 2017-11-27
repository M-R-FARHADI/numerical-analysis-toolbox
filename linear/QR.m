function [Q, R] = QR(A, method)
% QR decomposition
% input
% A
% method: 'GramSchmidt', 'Givens' or 'Householder', default: Householder
% output
% Q
% R

if(~exist('method','var'))
    method = 'Householder';
end

if(strcmp(method, 'GramSchmidt'))
    r = size(A, 1);
    Q = zeros(r);
    for ii = 1:r
        u = A(:, ii);
        for jj = 1 : ii - 1
            u = u - (u' * Q(:,jj)) * Q(:, jj);
        end
        Q(:, ii) = u / Norm(u);
    end
    R = Q' * A;
    
elseif(strcmp(method, 'Givens'))
    r = size(A, 1);
    Q = eye(r);
    R = A;
    for ii = 1 : r-1
        for k = ii+1 : r
           t = sqrt(R(ii, ii)^2 + R(k, ii)^2);
           if(t == 0)
               continue
           end
           c = R(ii,ii) / t;
           s = R(k, ii) / t;
           R([ii, k], :) = [c, s; -s, c] * R([ii, k], :);
           Q(:, [ii, k]) = Q(:, [ii, k]) * [c, -s; s, c]; 
        end
    end
    
elseif(strcmp(method,'Householder'))
    r = size(A, 1);
    Q = eye(r);
    R = A;
    for ii = 1 : r-1
        x = R(ii:end, ii);
        e = zeros(size(x));
        if(x(1) > 0)
            e(1) = -Norm(x);
        else
            e(1) = Norm(x);
        end
        u = x - e;
        v = u / Norm(u);
        R(ii:end, ii:end) = R(ii:end, ii:end) - 2*v*(v'*R(ii:end, ii:end));
        Q(:,ii:end) = Q(:,ii:end) - 2*(Q(:,ii:end)*v)*v';     
    end
else
    error('method error');
end

