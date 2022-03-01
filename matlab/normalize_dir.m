function normalize_dir(DIR_INOUT )
if nargin == 0 
    DIR_INOUT = '.\toy_dataset\predicted';
end
%Imin = 0;Imax = 255;
if isempty(DIR_INOUT), return ; end
if ~isfolder(DIR_INOUT)
    warning('Directory "%s" not found', DIR_INOUT);
end
flist = dir(fullfile(DIR_INOUT, '*.png'));
n_files = length(flist);
% normalize file names
for i = 1:n_files
    fn = flist(i).name;
    fn_clean = strrep(fn, '-predicted', '');
    if ~strcmp(fn_clean, fn)
        movefile(fullfile(DIR_INOUT, fn), fullfile(DIR_INOUT, fn_clean));
    end
end
flist = dir(fullfile(DIR_INOUT, '*.png'));
n_files = length(flist);
for i =1:n_files % make matlab maps
    fn = flist(i).name;
    [~,fn_base,~] = fileparts(fn);
    fn_mat_path = fullfile(DIR_INOUT, [fn_base '.mat']);
    if isfile(fn_mat_path), continue; end
    im = imread(fullfile(DIR_INOUT, fn));
    predmap = single(im) * 0.999/255; 
    save(fn_mat_path, 'predmap')
end

