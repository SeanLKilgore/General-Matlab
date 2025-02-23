% TrackedObject maintains a list of created objects for a given class
%
% This class implementation relies on a metaclass listener that triggers when any instance of this
% class or its subclasses is created.  An alternate implementation would begin management of the 
% list of created objects in the constructor function.  I think the main reason I went with this is
% because the class doesn't instantiate an instance of itself when the definition is loaded unless
% the constant forces it and it gets really circular in the other approaches I tried.
%
% See also: HandledList

classdef TrackedObject < handle & dynamicprops
    properties (Constant,SetAccess=protected,GetAccess=protected)
        %TrackedObjectList is a constant pointer with a property for each 
        TrackedObjectList (1,1) HandledStruct = HandledStruct
        CreationListeners (1,1) HandledStruct = TrackedObject.GenerateCreationListener
    end
    properties (SetAccess=protected)
        ObjectID
    end
    methods
        function delete(obj)
            %delete Cleans up the object and any object specific data accumulated for the purposes of this class
            
            % List of all the objects created by this class
            HL = TrackedObject.TrackedObjectList;
            
            % Specifically the list of objects that are the same as the input object
            %
            % At this point, we're no longer working with the list as a pointer
            SubclassList = HL.(class(obj));
            
            % Locate the specific object in the list by its ID
            idx = find( SubclassList.ObjectIDs == obj.ObjectID );
            
            if numel(idx)~=1
                % Locate the specific object in the list by direct comparison
                idx = find( SubclassList.Objects == obj );
            end
            
            % Remove the object and its ID from the Subclass list
            %
            % Make sure to interact with the list where it is actually part of a pointer
            HL.(class(obj)).Objects(idx)   = [];
            HL.(class(obj)).ObjectIDs(idx) = [];
        end
    end
    methods (Static,Access=protected)
        function varargout = TriggerOnCreation( ~ , evt )
            %TriggerOnCreation Assigns the object an ID and adds that object to a list so that it can be referred to even if "lost"
            %
            % Have not determined how this interacts with loaded objects.
            %
            % See also: TrackedObject/GenerateCreationListener
            
            % Get the metaclass of the (possibly) subclassed object
            mc = metaclass( evt.Instance );
            
            TrackedObjectList = TrackedObject.TrackedObjectList;
            
            if ~isprop( TrackedObjectList , mc.Name)
                % Create a new property
                TrackedObjectList.(mc.Name).Objects   = evt.Instance;
                evt.Instance.ObjectID = 0;
                TrackedObjectList.(mc.Name).ObjectIDs = 0;
            else
                % Add to an existing property
                TrackedObjectList.(mc.Name).Objects   = [ TrackedObjectList.(mc.Name).Objects evt.Instance ];
                evt.Instance.ObjectID = 1+max(TrackedObjectList.(mc.Name).ObjectIDs);
                TrackedObjectList.(mc.Name).ObjectIDs = [ TrackedObjectList.(mc.Name).ObjectIDs evt.Instance.ObjectID ];
            end
        end
        function CL = GenerateCreationListener( ~ )
            %GenerateCreationListener creates a listener for when instances of this class or its subclasses are created
            %
            % This Static method should run when the TrackedObject class is loaded. Whenever an instance of this
            % class or its subclasses is created, it should trigger the listener created by this method.  This
            % hierarchy is intended to ensure that the creation listener exists *before* the object instance is
            % created, because Constant properties of the master class are expected to be given their property
            % defintion values before instances and before subclasses are loaded.  
            %
            % See also: TrackedObject/TriggerOnCreation
            
            mcBase = meta.class.fromName('TrackedObject');
            OverallCreationListener = addlistener(mcBase,'InstanceCreated',@TrackedObject.TriggerOnCreation);
            CL = HandledStruct;
            CL.TrackedObject =  OverallCreationListener;
        end
    end
end