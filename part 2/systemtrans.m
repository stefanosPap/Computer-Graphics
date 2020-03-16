function dp = systemtrans(cp , b1 , b2 , b3 , c0)
   b1 = b1(:);
   b2 = b2(:);
   b3 = b3(:);
   c0 = c0(:);
   sizes = size(cp);
   if sizes(1) ~= 3
        cp = cp';
        sizes = size(cp);
   end
   L = [b1 b2 b3];
   dp = zeros(sizes(1),sizes(2));
   for i = 1:sizes(2)
        dp(:,i) = inv(L) * cp(:,i) - inv(L) * c0;
   end
end