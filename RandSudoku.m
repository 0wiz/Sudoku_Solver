function Nrs = RandSudoku()
    Nrs = permute(repmat(0:9,9,1,9),[1 3 2]);
    %if (StartCount < 16), StartCount = 16; end
    
    % Create a solution
    while (nnz(Nrs(:,:,2:10)))
        x = (ones(9).*~any(Nrs(:,:,1))).*~any(Nrs(:,:,1),2); y = [3 3 3];
        z = mat2cell(Nrs(:,:,1),y,y); for i = 1:9, y(i) = any(z{i}(:)); end
        x = x.*repelem(reshape(~y,3,3),3,3); if (~nnz(x)), x = ones(9); end
        
        [r,c] = find(any(Nrs(:,:,2:10).*x,3));
        i = randi(numel(r)); [r,c] = deal(r(i),c(i));
        
        [~,~,d] = find(Nrs(r,c,:)); x = ~ismember(d,Nrs(:,:,1)); 
        if (any(x)), [~,~,d] = find(d.*x); end, d = d(randi(numel(d)));
        
        Nrs(r,c,1) = d; Nrs = SolveSudoku(Nrs);
    end
    
    % Increase difficulty
    %while (nnz(Nrs(:,:,1)) > StartCount)
        
    %end
end