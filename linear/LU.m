function [L, U, P] = LU(A, pType)
% LU    lu decomposition.
%   [L,U] = LU(A) stores an upper triangular matrix in U and a
%   "psychologically lower triangular matrix" (i.e. a product of lower
%   triangular and permutation matrices) in L, so that A = L*U. A can be
%   rectangular.
%
%   [L, U, P] = LU(A) returns unit lower triangular matrix L, upper
%   triangular matrix U, and permutation matrix P so that P*A = L*U.
%
%   [L, U, p] = LU(A, 'vector') returns the permutation information as a
%   vector instead of a matrix.  That is, p is a row vector such that
%   A(p,:) = L*U.  Similarly, [L, U, P] = LU(A, 'matrix') returns a
%   permutation matrix P.  This is the default behavior.
%
%   See also Cholesky

%   Copyright 2017 Junshen Xu

if(~ismatrix(A) || ~isnumeric(A))
    error('A should be a numeric matrix')
end

if(~exist('pType', 'var'))
    pType = 'matrix';
end

[m, n]= size(A);
K = min(m, n);

L = eye(m, n);
U = A;
p = 1:m;

for c = 1 : K
    % find pivot
    [~, idx] = max(abs(U(c:end, c)));
    idx = idx + c - 1;
    U([idx ,c], c:end) = U([c, idx], c:end);
    % update p
    p([idx, c]) = p([c, idx]);
    % update L
    if(abs(U(c,c)) < eps)
        continue;
    end
    l = U(c+1:end,c)/ U(c,c);
    L(c+1:end, c) = l;
    L([idx, c], 1:c-1) = L([c, idx], 1:c-1);
    % update U
    U(c+1:end, c:end) = U(c+1:end, c:end) - bsxfun(@times, l, U(c, c:end)) ;
end

if(m > n)
    U = U(1:n, :);
else
    L = L(:, 1:m);
end

if(nargout > 2)
    if(strncmpi(pType, 'v', 1))
        P = p;
    else
        P = eye(m);
        P = P(p, :);
    end
else
    L(p, :) = L;
end
