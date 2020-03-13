function dp = systemtrans(cp , b1 , b2 , b3 , c0 )
   
   cp = cp(:);
   b1 = b1(:);
   b2 = b2(:);
   b3 = b3(:);
   c0 = c0(:);
   
   L = [b1';b2';b3'];
   dp = L \ (cp - c0);

end