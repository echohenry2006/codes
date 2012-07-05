
function index=sc(cluster_num,c_c_matrix)

cluster_number = cluster_num;       

%谱聚类
      W = c_c_matrix;
      D = diag(sum(W));
      L = D - W;
      n = length(L);
      L_sym=zeros(n,n);
     esp =0.0001;
     for i=1:n
         for j=1:n
             L_sym(i,j) = L(i,j)./(sqrt(D(i,i))*sqrt(D(j,j))+esp);
        end
     end
     [vector d] = eig(L_sym);
%将特征值赋给变量sort_d；
    sort_d = zeros(1,1);
    for i = 1:length(d)
        sort_d(i) = d(i,i);
    end
%重排特征值变量.
    sort_d = sort(sort_d);
%计算特征值为0的个数
    count = 0;
    for i = 1:length(sort_d);
        if sort_d(i) <= 0
           count = count + 1;
        end
    end
%求所需要的特征向量.
    wjj_sh = length(sort_d);
    Spe_cluster = zeros(length(vector),cluster_number);
    for i = 1:cluster_number
        for j = 1:length(d)
            if d(j,j) == sort_d(count+i)
               Spe_cluster(:,i) = vector(:,j);
            end
        end
    end
    b = Spe_cluster;
    [m n] = size(b);
    for i = 1:m
        for j = 1:n
            b(i,j) = b(i,j) * b(i,j);
        end
    end
    b = b';
    normalize_vector = sum(b);
    for k = 1:length(normalize_vector)
        if normalize_vector(k) ==0
           normalize_c_c_matrxi(k,:) = Spe_cluster(k,:);
        else
        Spe_cluster(k,:) = Spe_cluster(k,:) / sqrt(normalize_vector(k));
        end
    end
%聚类
%     index = kmeans(Spe_cluster,cluster_number);
    index = kmeans (Spe_cluster,cluster_number,'Replicates',300 );
%对应坐标分配值

   % info = load_untouch_nii (ROIfile);
   % image_ROI = info.img;
   % image_ROI (:,:,:) = 0;
   % for i = 1:size(coordinates,1)
   %     image_ROI(coordinates(i,1),coordinates(i,2),coordinates(i,3))=index (i);
   % end
   % info.img = image_ROI;
   % filename = strcat(target,dataList(subjn).name(1:5));
   % disp(filename);
   % save_untouch_nii(info,filename);
    
 end



