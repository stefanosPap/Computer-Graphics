function dp = systemtrans(cp , b1 , b2 , b3 , c0)
   b1 = b1(:);
   b2 = b2(:);
   b3 = b3(:);
   c0 = c0(:);
   sizes = size(cp);
   if sizes(1) ~= 3
        cp = cp';
   end
   L = [b1 b2 b3];
   dp = L \ (cp - c0);
end