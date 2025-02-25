% TrackedObject maintains a list of created objects for a given class
%
% This class implementation relies on a metaclass listener that triggers when any instance of this
% class or its subclasses is created.  An alternate implementation would begin management of the 
% list of created objects in the constructor function.  I think the main reason I went with this is
% because the class doesn't instantiate an instance of itself when the definition is loaded unless
% the constant forces it and it gets really circular in the other approaches I tried.
%
% See also: HandledList

% Sean Kilgore 2/22/2024

classdef TrackedObject < handle & dynamicprops
    properties (Constant,GetAccess=protected)
        %TrackedObjectList is a constant pointer with a property for each 
        TrackedObjectList (1,1) HandledStruct = HandledStruct
        CreationListeners (1,1) HandledStruct = TrackedObject.GenerateCreationListener
    end
    properties (Dependent)
        List
    end
    properties (Hidden)
        ObjectID
    end
    methods
        delete(obj)
    end
    methods
        function value = get.List(obj)
            field = TrackedObject.ClassToName(obj);
            value = obj.TrackedObjectList.(field);
        end
    end
    methods (Static,Access=protected)
        Name = ClassToName(obj)
        CL = GenerateCreationListener( ~ )
        varargout = TriggerOnCreation( ~ , evt )
    end
end