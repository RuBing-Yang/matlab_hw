function board = solveSudoku(map)
%solveSudoku 求解数独程序
%   输入map为一个9x9的矩阵，空白处以0填充
%   输出为填充完整的矩阵
board = map;
line = zeros(9,9);
column = zeros(9,9);
block = zeros(3,3);
spaces = [];
valid = 0;
solve(board);
if valid == 0
    board(1,1)=0;
end

    function dfs(pos)
        [~,n] = size(spaces);
        if pos == n+1
            valid = 1;
            return
        end
        i = spaces(1,pos);
        j = spaces(2,pos);
        ii = ceil(i/3);
        jj = ceil(j/3);
        for k = 1:1:9
            if line(i,k)==0 && column(j,k)==0 && block(ii,jj,k)==0
                line(i,k)=1;
                column(j,k)=1;
                block(ii,jj,k)=1;
                board(i,j) = k;
                dfs(pos+1);
                if valid==0
                    board(i,j) = 0;
                    line(i,k)=0;
                    column(j,k)=0;
                    block(ii,jj,k)=0; 
                else
                    break
                end    
            end
        end
    end

    function solve(board)
        for i = 1:1:9
            for j = 1:1:9
                if board(i,j)<1 || board(i,j)>9
                    index = [i;j];
                    spaces = [spaces index];
                else
                    digit = board(i,j);
                    line(i,digit)=1;
                    column(j,digit)=1;

                    ii = ceil(i/3);
                    jj = ceil(j/3);
                    block(ii,jj,digit)=1;
                end
            end
        end
        dfs(1);
    end
end