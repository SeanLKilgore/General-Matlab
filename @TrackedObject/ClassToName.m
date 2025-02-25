% ClassToName Converts the class (and package) name into a field

% Sean Kilgore 2/23/2024

function Name = ClassToName(obj)
if isstring(obj) || ischar(obj)
else
    obj = class(obj);
end
Name = regexprep( obj , '[^a-zA-Z0-9]*','_');
end