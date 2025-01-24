function [x,y] = diff2dEV_cells(x,y,Nt,dtBrow,EV,Dfin,Lx,Ly)


% Parameters
  dt = dtBrow;  % Time step (supposedly time is in the same units as the cell model)
  Df = Dfin;    % The units are L^2/t, the time is given by the cell model. 
                % Length is the same as Lx and Ly. Df is going to be a
                % small value. 
                % in general dtBrown < Df/2 for stability of the Euler-Maruyama method 

                % a ball park estimate of diffusion coefficient for cells is 600 µm^2/min
                % for 1440 minutes in a day, if the cell model has time
                % step of 1 day, this code should run for 1440 dtBrown for
                % each of those steps. (Df = 600, dtBrown = 1 min
                % No movement Df = 0
  C1 = EV;    % Excluded volumen coefficient
  Np = length(x);


% Evolve in time
  for k=1:Nt

      xold = x; yold = y;

    % Excluded volume
      if EV == 0
          m1 = 0; m2 = 0;
      else
          r1    = repmat(xold,1,Np)'-repmat(xold,1,Np);
          r2    = repmat(yold,1,Np)'-repmat(yold,1,Np);
          r22   = -(3/2)*(r1.^2+r2.^2);
          e1    = exp(r22');
          cm1   = r1*e1;           cm2 = r2*e1;
          m1    = diag(cm1);       m2  = diag(cm2);
      end

      xnew = xold + C1*dt*m1 + sqrt(2*Df*dt).*randn(size(xold));
      ynew = yold + C1*dt*m2 + sqrt(2*Df*dt).*randn(size(xold));

    % Boundary conditions
      % out of the left side
        xnew(xnew<0) = -xnew(xnew<0);
      % out of the right side
        xnew(xnew>Lx) = 2*Lx - xnew(xnew>Lx);
      % out of the bottom side
        ynew(ynew<0) = -ynew(ynew<0);
      % out of the top side
        ynew(ynew>Ly) = 2*Ly - ynew(ynew>Ly);  

      x = xnew;  y = ynew;

  end

