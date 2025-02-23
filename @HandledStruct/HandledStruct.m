% HandledStruct Provides a handle that can be, mostly treated like a structure to automate the
% dynamicprops supercless with somewhat minimal effort
%
% Overloads the subsasgn method for fields to act basically like a structure.
%
% See also: N/A
%
% Sean Kilgore 02/21/2025

classdef HandledStruct < handle & dynamicprops & matlab.mixin.SetGet
    methods
        function obj = subsasgn( obj , sbs , value )
            % All properties get indexed initially as if they were arrays, so if you need to assign a cell,
            % you'll need to assign it as a cell object first
            if sbs(1).type ~= "()"
                % Always ensure that the first subscript step indexes into the array dimension
                sbs = [ substruct('()',{[1]} ) sbs ] ;
            end
            
            if numel(sbs) < 2 && isstruct(value)
                % TODO: Something special here for assigning a structure to the indexed location...
                assert(true);
            elseif sbs(2).type ~= "."
                % Ensure that the second subscript indexes into the field dimension
                error('HANDLELIST:SUBSASGN','HandledList objects use dot-indexind');
            end
            
            % Find the first instance of a dot index amongst the index ordering
            idx = find(string({sbs.type}) == ".",1,'first');
            
            objProps = properties(obj);
            
            if ~ismember( sbs(idx).subs , objProps )
                % Create a new property
                newProp = addprop(obj,sbs(idx).subs);
                % Determine attributes of the created property
                newProp.SetObservable = true;
                newProp.GetObservable = true;
            end
            
            % Access the property first
            tempVar = subsref(obj,sbs(1:2));
            
            if numel(sbs) > 2
                % Modify the in-place value according to the indexing scheme and the new value
                tempVar = subsasgn(tempVar,sbs(3:end),value);
            else
                % Treat the existing value directly
                tempVar = value;
            end
            
            tempObj = subsref(obj,sbs(1));       % Isolate the specified object(s)
            setProp = char(string(sbs(2).subs)); % Convert cell to string to char
            set(tempObj,setProp,tempVar);        % This was the most accessible approach to managing the new property
            
        end
    end
end
    