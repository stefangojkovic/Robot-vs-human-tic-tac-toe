function []=draw(field) 
    % iscrtavanja u toku igre
    fprintf('---------------------------------- \n');
    fprintf('---------------------------------- \n');
    fprintf(' %c | %c | %c \n',gridChar(field(1)),gridChar(field(2)),gridChar(field(3)))
    fprintf('---+---+---\n');
    fprintf(' %c | %c | %c \n',gridChar(field(4)),gridChar(field(5)),gridChar(field(6)));
    fprintf('---+---+--- \n');
    fprintf(' %c | %c | %c \n',gridChar(field(7)),gridChar(field(8)),gridChar(field(9)));
    fprintf('---------------------------------- \n');
    fprintf('---------------------------------- \n');
end