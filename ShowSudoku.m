function Nrs = ShowSudoku(Nrs)
    % Create Board
    small = [1 1 2 2 4 4 5 5 7 7 8 8 9 9;0 repmat([9 9 0 0],1,3) 1];
    small = [small small([2 1],1:12)];
    big = [0 9 9 0 0 3 3 6 6 9 9 0 0 9 ; 0 0 9 9 0 0 9 9 0 0 3 3 6 6];
    
    % Draw Board
    figure('Color','white'), hold on, plot(small(1,:),small(2,:),'k')
    plot(big(1,:),big(2,:),'k','LineWidth',2)
    
    % Draw Numbers
    for i = 1:81, c = mod((i-1),9)+1; r = floor((i-1)/9)+1;
        if (Nrs(r,c,1))
            text(c-.7,9.55-r,int2str(Nrs(r,c,1)),'FontSize',20)
        elseif (size(Nrs,3) == 10)
            for d = 2:10
                if (Nrs(r,c,d))
                    x = mod((d-2),3); y = floor((d-2)/3);
                    text(c-0.88+0.3*x,9.84-r-0.3*y,int2str(d-1),'FontSize',10)
                end
            end
        end
    end
    
    hold off, axis image, set(gca,'visible','off'), Nrs = Nrs(:,:,1);
end