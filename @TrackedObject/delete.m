%delete Cleans up the object and any object specific data accumulated for the purposes of this class

% Sean Kilgore 02/22/2025

function delete(obj)

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