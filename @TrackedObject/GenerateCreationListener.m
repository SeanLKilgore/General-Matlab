%GenerateCreationListener creates a listener for when instances of this class or its subclasses are created
%
% This Static method should run when the TrackedObject class is loaded. Whenever an instance of this
% class or its subclasses is created, it should trigger the listener created by this method.  This
% hierarchy is intended to ensure that the creation listener exists *before* the object instance is
% created, because Constant properties of the master class are expected to be given their property
% defintion values before instances and before subclasses are loaded.
%
% See also: TrackedObject/TriggerOnCreation

% Sean Kilgore 02/22/2025

function CL = GenerateCreationListener( ~ )


mcBase = meta.class.fromName('TrackedObject');
OverallCreationListener = addlistener(mcBase,'InstanceCreated',@TrackedObject.TriggerOnCreation);
CL = HandledStruct;
CL.TrackedObject =  OverallCreationListener;

end