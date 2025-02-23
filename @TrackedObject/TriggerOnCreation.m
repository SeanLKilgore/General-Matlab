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