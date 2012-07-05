function parcellation(f_roi,c,pattern,cluster_num,method)

disp('start clustering...');

switch method
case 'spect'
	index=sc(cluster_num,c);
case 'linkage'
%%linkage 
 y=pdist(pattern,'cosine');
 c=squareform(y);
 index=zeros(size(ind,1),1);
 Z=linkage(y);
 [H,T]=dendrogram(Z,cluster_num);
 for i=1:cluster_num
	index(T==i)=i;
 end
end



info = load_untouch_nii (f_roi);
image_ROI = info.img;
[mx my mz]=size(image_ROI);
ind=find(image_ROI);
image_ROI (:,:,:) = 0;
for i = 1:size(ind,1)
    [x y z]=ind2sub([mx my mz],ind(i));
    image_ROI(x,y,z)=index (i);
end
info.img = image_ROI;
[pathstr, name, ext, versn] = fileparts(file);
f_out=['result_' pathstr '_' method '_' cluster_num '.nii'];
save_untouch_nii(info,f_out);
   