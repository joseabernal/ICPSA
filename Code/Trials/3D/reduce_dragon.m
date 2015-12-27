clear y y0

% Read basic data cloud
A = zeros([3 437645]);
file = fopen('../../Database/Dragon/dragon.txt', 'r');
A = fscanf(file, '%f %f %f', size(A));
%I = 1:150:437645;
%I = 2:150:437645;
I = 3:150:437645;
y0 = A(:,I)' * 100;
fclose(file);


k = 1;
for i=1:size(y0,1)
    %if( y0(i,1) < 333 ) % original
    %if( y0(i,1) > 5.78 ) % tail
    if( y0(i,2) >= 16.75 ) %head
       y(k,1) = y0(i,1);
       y(k,2) = y0(i,2);
       y(k,3) = y0(i,3);
       k = k + 1;
    end
end


size(y,1)/size(y0,1)

size(y,1)
y0=y;
plot3(y(:,3),y(:,1),y(:,2),'.k')