function portopen(speed)
% otvaranje porta sa kontrolerom
global t;
time = 1;
t=tcpip('10.1.1.120',10001); % IP address of the controller
fopen(t);
   fwrite(t,['1;1;EXECOVRD 5.0']);
   fwrite(t,['1;1;EXECJOVRD 5.0']);
   fwrite(t,['1;1;EXECSPD ' num2str(speed,'%10.3f')]);
   pause(time);
   fwrite(t,'1;1;RSTALRM');
   pause(time);
   fwrite(t,'1;1;STATE');
   pause(time);
   fwrite(t,'1;1;CNTLON');
   pause(time);
%    fwrite(t,'1;1;ACCEL 10000.0, 10000.0');
   fwrite(t,'1;1;SRVON');
   pause(time);
  