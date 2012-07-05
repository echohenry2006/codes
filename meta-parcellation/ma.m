function pattern=ma(f_roi,subject_num ,exp_num ,active_table,varargin)
% compute the ma map of file f_roi
% if varargin='max' ,use revised max ma algorithm;else use the old one;
% FORMAT pattern=ma(f_roi,subject_num ,exp_num ,active_table)
%		pattern=ma(f_roi,subject_num ,exp_num ,active_table,'max')
% active_talbe - m*4 matrix
%              m - total number of experiments,
%			   column 1 - exp id ;
%			   column 2:3 - coordinates in matrix space
% pattern - m * exp_num ma map for the roi
%           m :foci id in roi 
% ma.m 2012-07-05 Yong Yang

error(nargchk(4,5,nargin);
vin=length(varargin);
nii=load_nii(f_roi);
roi_img=nii.img;
T=[nii.hdr.hist.srow_x;nii.hdr.hist.srow_y;nii.hdr.hist.srow_z];
T(:,4)=T(:,4)-1;
dim=size(roi_img);

ind=find(roi_img);
m=length(ind);
roi_ind=zeros(m,3);
for i=1:m
    [roi_ind(i,1),roi_ind(i,2),roi_ind(i,3)]=ind2sub(size(roi_img),ind(i));
end


EDsub=11.6;
Sigma_sub=EDsub/2/sqrt(2/pi);
EDtemp=5.7;
Sigma_temp=EDtemp/2/sqrt(2/pi);
FWHMsub=Sigma_sub*2.3548200;
FWHMtemp=Sigma_temp*2.3548200;

dv=nii.hdr.dime.pixdim;
dv=dv(2)*dv(3)*dv(4);




disp('start computing pattern...')

%calculate each voxel's active pattern
pattern=zeros(m,exp_num);
for i=1:m
    %disp(i);
    seed=roi_ind(i,:)*T(1:3,1:3)+T(:,4)';
    target=active_table(:,2:4);
    for j=1:exp_num
        exp_id=j;
        FWHM=sqrt(FWHMtemp^2+(FWHMsub/sqrt(subject_num(exp_id)))^2);%mm
        sigma=FWHM/2.3548200;
        MAmap=zeros(dim);
        active_foci=active_table(active_table(:,1)==exp_id,2:4);
        foci_num=size(active_foci,1);
        MNI_x=seed(1);
        MNI_y=seed(2);
        MNI_z=seed(3);
        p=zeros(1,foci_num);
        for id=1:foci_num
            d=norm([MNI_x MNI_y MNI_z]-active_foci(id,:));
			p(id)=exp(-d^2/2/sigma^2)/(2*pi)^1.5/sigma^3*dv;
        end
		if vin == 1 && varargin{1} == 'max'
			pattern(i,j)=max(p);
		else
			pattern(i,j)=1-prod(1-p);
    end    
end

if vin==1 && varargin{1} == 'max'
	save 'pattern_revised.mat' pattern;
else
	save 'pattern.mat' pattern;
end
	