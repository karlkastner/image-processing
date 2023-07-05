% Mi 6. Jan 13:32:37 CET 2016
% Karl Kastner, Berlin
% reference: Aly 1996, (see also pettitt for 1-change point)
% limitations:
% 1) if implemented with ranks there must not be ties and the steps must be up
%	      (this is not mentioned in the paper)
% 2) steps must be in one direction (both up or both down), even with implemented as sum of signs
%	      (this is not obvious from the paper)
% 3) does not default to 1-step solution, if only one step is present
%             (also not mentioned)
% 4) the value of the third part must not be equal to the value of the first part
%		(this is mentioned) 

function lambda_n = ranksum2(X,l,k)

% Wilcoxon-Mann-Whitney
% J(u) = u
% J'(u) = 1
% mu = int_0^1 u du = 1/2x^2|_0^1 = 1/2
% s2 = 2 int_0^1 int_0^1 x(1-y)dxdy = 2 (1/2 x^2 * (y - 1/2y^2))|_0^1|_0^1 = 1/2

[k l] = sort2(k,l);
mu = 0.5;
s2 = 0.5;
%s2 = 1;
%mu = 0;
n  = length(X);

%figure()
%plot(rank)
%pause

if (0)
% ranks and normalised rank sums
[X_ rank] = sort(X);
Rk   = 1/n*sum(rank(1:k));
Rl   = 1/n*sum(rank(1:l));
Rn   = 1/n*sum(rank(1:n));
else
	% TODO, somehow the end points were swapped, dunno why
	Rk = 1/n*rs(X,k);
	Rl = 1/n*rs(X,l);
	Rn = 1/n*rs(X,n);
end


% statistic
lambda_kln = 1/s2*(Rk^2/k + (Rl-Rk)^2/(l-k) + (Rn-Rl)^2/(n-l) - n*mu^2);
%lambda_kln = 1/s2*(Rk^2/k^2 + (Rl-Rk)^2/(l-k)^2 + (Rn-Rl)^2/(n-l)^2 - n*mu^2);
lambda_n = 1/n^3*k*(l-k)*(n-l)*lambda_kln;
%lambda_n = lambda_kln;

if (0)
	% relative
	lambda_n = k/n*(Rk/(k*(k+1)))^2 + (l-k)/n*((Rl-Rk)/(l*(l+1) - k*(k+1)))^2 + ...
			(n-l)/n*((Rn-Rl)/(n*(n+1)-l*(l+1)));
	% absolute
	%lambda_n = (Rk/(k*(k+1)))^2 + ((Rl-Rk)/(l*(l+1) - k*(k+1)))^2;
end

if (0)
K = k*(n+1);
L = l*(n+1);
N = n*(n+1);
%lambda_n = ((Rk - K)/K)^2 + ((Rl-Rk-(L-K))/(L-K))^2 + 0*((Rn-Rl-(N-L))/(N-L))^2;
%lambda_n = ((Rk - K))^2 + ((Rl-Rk-(L-K)))^2 + 0*((Rn-Rl-(N-L)))^2;
%lambda_n = ((Rk )/K)^2 + ((Rl-Rk)/(L-K))^2 + 0*((Rn-Rl)/(N-L))^2;

%Rk = n*Rk;
%Rl = n*Rl;
%Rn = n*Rn;
end

if (0)
Rk_ = 1/n*sum(1:k);
Rl_ = 1/n*sum(1:l);
Rn_ = 1/n*sum(1:n);
lambda_kln = 1/s2*(Rk^2/Rk_^2 + (Rl-Rk)^2/(Rl_-Rk_)^2 + (Rn-Rl)^2/(Rn_-Rl_)^2 - n*mu^2);
lambda_n = lambda_kln;
end


if (0)
lambda_kln_ = 1/s2*(Rk_^2/k + (Rl_-Rk_)^2/(l-k) + (Rn_-Rl_)^2/(n-l) - n*mu^2);
%lambda_n = lambda_kln/lambda_kln_;
%lambda_n = lambda_kln - lambda_kln_;
end

% lombard
if (0)
Rk = Rk - k*mu;
Rl = Rl - l*mu;
Rn = Rn - n*mu;
lambda_n = 1/n*1/s2*(Rk^2 + (Rl - Rk)^2 + (Rn-Rl)^2);
end

end

% from pettit (1-point test)
function u = rs(Y,t)
	Y  = cvec(Y);
	dY = bsxfun(@minus,Y,Y');
	T = length(Y);
	D = sign(dY);
	u = 0;
	% determine test statistic
	for idx=1:t
		jdx=t+1:T;
		%u = u + sum(D(idx,jdx));
		u = u + sum(D(idx,jdx));
	end
end



