%A=imread('input.bmp');
%imshow(A);
%A1=A(:,1:150);
%A2=A(:,50:205);
A1=rgb2gray(imread('input.bmp'));
A2=rgb2gray(imread('input2.bmp'));
imshow(A1);
P1=ginput;
figure,
imshow(A2);
P2=ginput;
[m n]=size(P1);
b=[];
a=[];
[m1 n1]=size(A1);
[m2 n2]=size(A2);
for i=1:m
    x1=P1(i,1);
    y1=P1(i,2);
    x2=P2(i,1);
    y2=P2(i,2);
    b=[b;x2;y2];
    a=[a;x1,y1,1,0,0,0,-x2*x1,-x2*y1;0,0,0,x1,y1,1,-y2*x1,-y2*y1];
end
    T=inv(a'*a)*a'*b;
    %T=a\b;
  h11=T(1); h12=T(2); h13=T(3); h21=T(4); h22=T(5); h23=T(6); h31=T(7); h32=T(8);
  
xx1=round((T(1)*1+T(2)*1+T(3))/(T(7)*1+T(8)*1+1));
  yy1=round((T(4)*1+T(5)*1+T(6))/(T(7)*1+T(8)*1+1));
  xx2=round((T(1)*m1+T(2)*n1+T(3))/(T(7)*m1+T(8)*n1+1));
  yy2=round((T(4)*m1+T(5)*n1+T(6))/(T(7)*m1+T(8)*n1+1));
    I=[];
 
    %for i=1:m2
   %  for  j=1:n2
  %  x12=round((T(1)*i+T(2)*j+T(3))/(T(7)*i+T(8)*j+1));
   % y12=round((T(4)*i+T(5)*j+T(6))/(T(7)*i+T(8)*j+1));
%T2x=round(((h13*h32-h12)*j+(h22-h32*h23)*i+h12*h23-h13*h22)/((h12*h31-h11*h32)*j+(h21*h32-h31*h22)*i+h11*h22-h12h21));
%T2y=round(((-h31*h13+h11)*j+(-h21+h31*h23)*i+h21*h13-h11*h23)/((h12*h31-h11*h32)*j+(h21*h32-h31*h22)*i+h11*h22-h12h21)); 

%X(i,j)=min(x12,y12);
    %I(i,j)=A1(i,j);
     % end
   % end
    for i=1:(xx2-xx1+1)
      for  j=1:(yy2-yy1+1)
    %T2x=round((T(1)*i+T(2)*j+T(3))/(T(7)*i+T(8)*j+1));
   % T2y=round((T(4)*i+T(5)*j+T(6))/(T(7)*i+T(8)*j+1));
   %I(T2x-min(min(X))+1,T2y-min(min(X))+1)=A1(i,j);
    %T2x=round(((h13*h32-h12)*j+(h22-h32*h23)*i+h12*h23-h13*h22)/((h12*h31-h11*h32)*j+(h21*h32-h31*h22)*i+h11*h22-h12*h21));
   %T2y=round(((-h31*h13+h11)*j+(-h21+h31*h23)*i+h21*h13-h11*h23)/((h12*h31-h11*h32)*j+(h21*h32-h31*h22)*i+h11*h22-h12*h21));
   T2x=round(((h13*h32-h12)*(j-1+yy1)+(h22-h32*h23)*(i-1+xx1)+h12*h23-h13*h22)/((h12*h31-h11*h32)*(j-1+yy1)+(h21*h32-h31*h22)*(i-1+xx1)+h11*h22-h12*h21));
   T2y=round(((-h31*h13+h11)*(j-1+yy1)+(-h21+h31*h23)*(i-1+xx1)+h21*h13-h11*h23)/((h12*h31-h11*h32)*(j-1+yy1)+(h21*h32-h31*h22)*(i-1+xx1)+h11*h22-h12*h21)); 
   if T2x<=m1&&T2y<=n1
   I(i,j)=A1(T2x,T2y);
   else I(i,j)=0;
   end
      end
    end
   
    for i=1:m2
        for j=1:n2
             I(i+1-xx1,j+1-yy1)=A2(i,j);
        end
    end
    imshow(I,[0,255]);