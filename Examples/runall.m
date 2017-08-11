%% Run All Tests
% Change to the directory of this .m-script.
cwd = fileparts(mfilename('fullpath'));

[~, junit_xml_path] = fileattrib(fullfile(cwd, '..'));

addpath(junit_xml_path.Name);

% Get all files in this directory.
files = dir(cwd);
% For all of the files in this directory.
for idx = 1:numel(files)
    % Get the current file.
    file = files(idx);
    % If the filename starts with Example and ends with .m.
    if strncmp(file.name, 'Example', 7) && strcmpi(file.name(end-1:end), '.m')
        % Run it.
        fprintf('Running: %s\n', file.name);
        run(file.name);
        fprintf('Publishing: %s\n', file.name);
        publish(file.name);
    end
end
