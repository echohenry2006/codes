function [subject_num exp_num active_table]=read_exp(filename)
% read_exp read the coordinates and expriments information from txt
% FORMAT [subject_num exp_num active_table]=read_exp(filename)
% active_talbe - m*4 matrix
%              m - total number of experiments,
%			   column 1 - exp id ;
%			   column 2:3 - coordinates in matrix space
% read_exp.m 2012-07-05 Yong Yang


subject_num=[];
%%read meta data

fid=fopen(filename,'r');
s=textscan(fid,'%s %s\r\n',1);
exp_id=0;
active_table=[];
while  ~feof(fid)

    exp_id=exp_id+1;
    while(1)
        d=textscan(fid,'%s',1,'delimiter','//');
        s=regexp(d{1},'Subjects=','split');
        
        if(~isempty(s)&&length(s{1})==2)
            subject_num=[subject_num;str2num(cell2mat(s{1}(2)))];
            break;
        end
    end
    %disp(exp_id);
    d=textscan(fid,'%f %f %f');
       
    d=cell2mat(d);
    d=[ones(size(d,1),1)*exp_id,d];
    active_table=[active_table;d];
end
fclose(fid);
exp_num=exp_id;
