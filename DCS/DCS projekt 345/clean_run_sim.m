%DV
FLv = zeros(1,simLength);
FRv = zeros(1,simLength);
HRv = zeros(1,simLength);

%MV
HLv = zeros(1,simLength);

%CV
TLv = zeros(1,simLength);
TRv = zeros(1,simLength);

for k = 1:1:simLength
   [tl, tr] = step_simulator(hl, hr, fl, fr);
   TLv(k) = tl;
   TRv(k) = tr;
   FLv(k) = fl;
   FRv(k) = fr;
   HLv(k) = hl;
   HRv(k) = hr;
end
