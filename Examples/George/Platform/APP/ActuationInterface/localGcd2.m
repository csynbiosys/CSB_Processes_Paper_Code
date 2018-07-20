function n = localGcd2( n )
c=length(n);
while (c>1)
    if (c>2*floor(c/2))
        n=gcd(n(1:(c+1)/2),n((c+1)/2:end));
        c=(c+1)/2;
    else
        n=gcd(n(1:c/2),n((c/2+1):end));
        c=c/2;
    end
end
end