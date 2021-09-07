function hl = calc_control(stpt,tl, hr, fl, fr)
	persistent init;
    if isempty(init)
        init = 0;
    end
	persistent K MP D N Nu k;
	
	if init == 0
		k = 1;
		
		load("step_response2.mat","STEP");
		step_r = STEP(2,:)-STEP(2,1);
		init = 1;
		D = 400;
		N = 19;
		Nu = 1;
		lambda = 0;
		psi = 1;
		
		% Prep M matrix
		M = zeros(N,Nu);
		for i=1:N
		   for j=1:Nu
			  if (i>=j)
				 M(i,j)=step_r(i-j+1);
			  end
		   end
		end
		
		% Prep K matrix (Nu x N)
		K = (M'*eye(N)*psi*M+eye(Nu)*lambda)^(-1)*M'*eye(N)*psi;
		
		% Prep MP matrix
		MP=zeros(N,D-1);
		for i=1:N
		   for j=1:D-1
			  if i+j<=D
				 MP(i,j)=step_r(i+j)-step_r(j);
			  else
				 MP(i,j)=step_r(D)-step_r(j);
			  end
		   end
		end
	end

	% Przeszłe zmienne do sterowania
	persistent TLV FLV FRV HLV HRV;
	TLV = [TLV, tl];
	FLV = [FLV, fl];
	FRV = [FRV, fr];
	HRV = [HRV, hr];
	
	DY = stpt-tl;
	if k < 3
		DU = zeros(D-1,1);
	elseif k < D+1
		DU = [(fliplr(HLV(2:k-1)-HLV(1:k-2)))';zeros(D-k+1,1)];
	else
		DU = (fliplr(HLV(k-D+1:k-1)-HLV(k-D:k-2)))';
	end
	
	Dhl = K(1,:)*(DY-MP*DU);
	
	hl = 0;
	if k > 2
		hl = HLV(k-1) + Dhl;
	end
	
	if hl > 100
		hl = 100;
	end
	if hl < 0
		hl = 0;
	end
	
	HLV = [HLV, hl];
	k = k + 1;
end