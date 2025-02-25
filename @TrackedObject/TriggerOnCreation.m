%TriggerOnCreation Assigns the object an ID and adds that object to a list so that it can be referred to even if "lost"
%
% Have not determined how this interacts with loaded objects.
%
% See also: TrackedObject/GenerateCreationListener

% Sean Kilgore 2/22/2024

function varargout = TriggerOnCreation( ~ , evt )
%TriggerOnCreation Assigns the object an ID and adds that object to a list so that it can be referred to even if "lost"
%
% Have not determined how this interacts with loaded objects.
%
% See also: TrackedObject/GenerateCreationListener

% Get the metaclass of the (possibly) subclassed object
mc = metaclass( evt.Instance );

% Name = regexprep( mc.Name , '[^a-zA-z0-9]+','_');
Name = TrackedObject.ClassToName(mc.Name);

TrackedObjectList = TrackedObject.TrackedObjectList;

if ~isprop( TrackedObjectList , Name)
    TrackedObjectList.(Name) = HandledStruct;
    % Create a new property
    TrackedObjectList.(Name).Objects   = evt.Instance;
    evt.Instance.ObjectID = 0;
    TrackedObjectList.(Name).ObjectIDs = 0;
else
    % Add to an existing property
    TrackedObjectList.(Name).Objects   = [ TrackedObjectList.(Name).Objects evt.Instance ];
    evt.Instance.ObjectID = 1+max(TrackedObjectList.(Name).ObjectIDs);
    TrackedObjectList.(Name).ObjectIDs = [ TrackedObjectList.(Name).ObjectIDs evt.Instance.ObjectID ];
end

end