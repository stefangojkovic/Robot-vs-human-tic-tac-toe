function portclose()
    % zatvaranje porta sa kontrolerom
    global t;
    fwrite(t,'1;1;SRVOFF');
    pause(0.2);
    fclose(t);
    t=-1;