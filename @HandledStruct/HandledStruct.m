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
        obj = subsasgn(obj , sbs , value )
    end
end
    