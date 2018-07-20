function n = localGcd( n )
while (length(n)>1)
    n=gcd(n(1:ceil(end/2)),n(floor(end/2+1):end));
end
end