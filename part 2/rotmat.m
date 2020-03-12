function R = rotmat(theta, u)
 R = [(1 - cos(theta))*u(1)^2 + cos(theta) (1 - cos(theta))*u(1)*u(2) - sin(theta)*u(3) (1 - cos(theta))*u(1)*u(3) + sin(theta)*u(2);
      (1 - cos(theta))*u(1)*u(2) + sin(theta)*u(3) (1 - cos(theta))*u(2)^2 + cos(theta)*u(3) (1 - cos(theta))*u(2)*u(3) - sin(theta)*u(1);
      (1 - cos(theta))*u(1)*u(3) - sin(theta)*u(2) (1 - cos(theta))*u(2)*u(3) + sin(theta)*u(1) (1 - cos(theta))*u(3)^2 + cos(theta)
     ];
end