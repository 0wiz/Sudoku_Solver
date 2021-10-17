function Nrs = SolveSudoku(Nrs)
    if (size(Nrs,3) == 1)
        Nrs(:,:,2:10) = permute(repmat(1:9,9,1,9),[1 3 2]);
    end
    
    while (nnz(Nrs(:,:,2:10).*Nrs(:,:,1)))
        % Apply direct elimination
        Nrs(:,:,2:10) = Nrs(:,:,2:10).*~Nrs(:,:,1);
        [r,c,d] = find(Nrs(:,:,1)); d = d+1;
        for i = 1:numel(r)
            Nrs(r(i),:,d(i)) = 0; Nrs(:,c(i),d(i)) = 0;
            Nrs((1:3)+3*floor((r(i)-1)/3),(1:3)+3*floor((c(i)-1)/3),d(i)) = 0;
        end
        
        % Apply indirect linear elimination (Needs to be repeated)
        for i = 2:10
            for j = 0:3:6
                for k = 0:3:6
                    if (~nnz(Nrs((1:3)+j,[1 2]+k,i)) && any(Nrs((1:3)+j,3+k,i)))
                        Nrs([1:j j+4:9],3+k,i) = 0;
                        continue
                    end
                    if (~nnz(Nrs((1:3)+j,[1 3]+k,i)) && any(Nrs((1:3)+j,2+k,i)))
                        Nrs([1:j j+4:9],2+k,i) = 0;
                        continue
                    end
                    if (~nnz(Nrs((1:3)+j,[2 3]+k,i)) && any(Nrs((1:3)+j,1+k,i)))
                        Nrs([1:j j+4:9],1+k,i) = 0;
                        continue
                    end
                    if (~nnz(Nrs([1 2]+k,(1:3)+j,i)) && any(Nrs(3+k,(1:3)+j,i)))
                        Nrs(3+k,[1:j j+4:9],i) = 0;
                        continue
                    end
                    if (~nnz(Nrs([1 3]+k,(1:3)+j,i)) && any(Nrs(2+k,(1:3)+j,i)))
                        Nrs(2+k,[1:j j+4:9],i) = 0;
                        continue
                    end
                    if (~nnz(Nrs([2 3]+k,(1:3)+j,i)) && any(Nrs(1+k,(1:3)+j,i)))
                        Nrs(1+k,[1:j j+4:9],i) = 0;
                        continue
                    end
                    if ~(any(Nrs(3+k,[1:j j+4:9],i)) || nnz(Nrs([1 2]+k,[1:j j+4:9],1) == i-1))
                        Nrs(3+k,(1:3)+j,i) = 0;
                        continue
                    end
                    if ~(any(Nrs(2+k,[1:j j+4:9],i)) || nnz(Nrs([1 3]+k,[1:j j+4:9],1) == i-1))
                        Nrs(2+k,(1:3)+j,i) = 0;
                        continue
                    end
                    if ~(any(Nrs(1+k,[1:j j+4:9],i)) || nnz(Nrs([2 3]+k,[1:j j+4:9],1) == i-1))
                        Nrs(1+k,(1:3)+j,i) = 0;
                        continue
                    end
                    if ~(any(Nrs([1:j j+4:9],3+k,i)) || nnz(Nrs([1:j j+4:9],[1 2]+k,1) == i-1))
                        Nrs((1:3)+j,3+k,i) = 0;
                        continue
                    end
                    if ~(any(Nrs([1:j j+4:9],2+k,i)) || nnz(Nrs([1:j j+4:9],[1 3]+k,1) == i-1))
                        Nrs((1:3)+j,2+k,i) = 0;
                        continue
                    end
                    if ~(any(Nrs([1:j j+4:9],1+k,i)) || nnz(Nrs([1:j j+4:9],[2 3]+k,1) == i-1))
                        Nrs((1:3)+j,1+k,i) = 0;
                        continue
                    end
                end
            end
        end
        
        % Apply indirect subspacial elimination
        A = mat2cell(Nrs(:,:,2:10),ones(1,9),9,9);
        B = mat2cell(Nrs(:,:,2:10),9,ones(1,9),9);
        C = mat2cell(Nrs(:,:,2:10),[3 3 3],[3 3 3],9);
        
        
        % Get single-place values from the linear subspaces
        A = sum(Nrs(:,:,2:10).*(sum(~~Nrs(:,:,2:10),1) == 1),3);
        B = sum(Nrs(:,:,2:10).*(sum(~~Nrs(:,:,2:10),2) == 1),3);
        
        % Get single-place values from the square subspaces
        x = [3 3 3]; C = mat2cell(~~Nrs(:,:,2:10),x,x,9); x = ones(1,9,9);
        for i = 1:9, x(:,i,:) = (sum(reshape(C{i},1,9,9)) == 1); end
        C = sum(Nrs(:,:,2:10).*repelem(reshape(x,3,3,9),3,3,1),3);
        
        % Set single-place values onto board
        Nrs(:,:,1) = Nrs(:,:,1)+A+B+C;
        
        % Set single-value places onto board
        Nrs(:,:,1) = sum(Nrs,3).*(sum(Nrs,3) == max(Nrs,[],3));
    end
end