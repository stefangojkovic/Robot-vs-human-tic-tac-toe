function robotcontrol(p, speed)
global t;
   % cm -string, cosirop command EXECJCOSIROP
   str = '';
   for i = 1 : 6
       str = [str num2str(p(i), '%10.3f')];
       if i < 6
           str = [str ', '];
       end
   end
%    cm = ['1;1;EXECJP = (' str ')' ];  joint space
   cm = ['1;1;EXECPCOSIROP = (' str ')(6, 0)'];  % x y z space
   % fwrite(t,['1;1;EXECJOVRD 35.0']);
   fwrite(t,cm);
   pause(0.05);

   fwrite(t,['1;1;EXECOVRD ' num2str(speed,'%.1f')]);
   fwrite(t,['1;1;EXECJOVRD ' num2str(speed,'%.1f')]);

   pause(0.5);
%    fwrite(t,'1;1;EXECMOV JP'); joint space
fwrite(t,'1;1;EXECMOV PCOSIROP');  % x y z space
   pause(0.5);
