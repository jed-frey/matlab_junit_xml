classdef TestCase
    %TESTCASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        assertions
        elapsed_sec = 0
        timestamp = datestr(now, 31)
        classname
        status
        category
        file
        line
        log
        url
        stdout = ''
        stderr = ''
        
        type = 0
        message
        output
    end
    
    methods
        
        
        
        %% Function to generate node.
        function node = xml(self, docNode)
            % Create a XML Node element from docNode.
            node = docNode.createElement('testcase');
            % Get all of the fields of self.
            fields = fieldnames(self);
            % For each of the object fields.
            for idx = 1:numel(fields)
                % Pull out the field name from the field cell array based
                % on the loop index.
                field = fields{idx};
                
                % Don't put in empty fields.
                % Continue.
                if isempty(self.(field))
                    continue;
                end
                
                % Skip the message field.
                % It is used for the failed, error and skipped Test Case
                % type and addressed below.
                if strcmp(field, 'message')
                    continue;
                end
                
                % If the node has standard output (stdout) specified.
                % Create a node for it with the name system-out.
                if strcmp(field, 'stdout')
                    stdout_node = docNode.createElement('system-out');
                    stdout_node.appendChild(docNode.createTextNode(self.stdout));
                    % Append it to the node.
                    node.appendChild(stdout_node);
                    % Continue to loop through fields.
                    continue;
                end
                
                % If the node has standard error (stderr) specified.
                % Create a node for it with the name system-err.
                if strcmp(field, 'stderr')
                    stderr_node = docNode.createElement('system-err');
                    stderr_node.appendChild(docNode.createTextNode(self.stderr));
                    % Append it to the node.
                    node.appendChild(stderr_node);
                    % Continue to loop through.
                    continue;
                end
                
                if strcmp(field, 'type')
                    switch self.(field)
                        case 0
                            continue
                        case 1
                            status_node = docNode.createElement('failure');
                            status_node.setAttribute('type', 'failure');
                        case 2
                            status_node = docNode.createElement('error');
                            status_node.setAttribute('type', 'error');
                        case 3
                            status_node = docNode.createElement('skipped');
                            status_node.setAttribute('type', 'skipped');
                        otherwise
                            error('Unknown type: %f', self.(field));
                    end
                    if ~isempty(self.message)
                        status_node.setAttribute('message', self.message);
                    end
                    if ~isempty(self.output)
                        status_node.appendChild(docNode.createTextNode(self.output));
                    end
                    continue
                end
                
                
                % Get the value of the field.
                tmp_value = self.(field);
                % If it is numeric.
                if isnumeric(tmp_value)
                    % Convert it to a string.
                    value = num2str(tmp_value);
                else
                    % If it is not, pass it through.
                    value = tmp_value;
                end
                % Set the test attribute field with given value.
                node.setAttribute(field, value)
            end
        end
        
        %% Methods to set non-success messages and outputs.
        function failure(self, message, output)
               self.type = 1;
            if isempty(message) || nargin<2
                self.message='';
            end
            if isempty(output) || nargin<3
                self.output='';
            end
        end
        function error(self, message, output)
            self.type = 2;
            if isempty(message) || nargin<2
                self.message='';
            end
            if isempty(output) || nargin<3
                self.output='';
            end
        end
        function skipped(self, message, output)
            self.type = 3;
            if isempty(message) || nargin<2
                self.message='';
            end
            if isempty(output) || nargin<3
                self.output='';
            end
        end
        
        %% Methods to determine test case state.
        function success = is_success(self)
            success = self.type == 0;
        end
        function failure = is_failure(self)
            failure = self.type == 1;
        end
        function error = is_error(self)
            error = self.type == 2;
        end
        function skipped = is_skipped(self)
            skipped = self.type == 3;
        end
    end
end

