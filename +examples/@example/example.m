classdef example < handle & matlab.mixin.CustomDisplay & matlab.mixin.CustomCompactDisplay
  properties
    value (:,:) {mustBeNumeric}
  end
  methods % Constructor
    function obj = example( value )
      arguments
        value (:,:) {mustBeNumeric}
      end
    end
  end
  methods % Destructor
    function delete(obj)
    end
  end
  methods
    [ bin ] = dec2bin(obj)
    [ hex ] = dec2hex(obj)
  end
  methods
    [ value ] = double(obj)
    [ value ] = single(obj)
    
    [ value ] = int8(obj)
    [ value ] = int16(obj)
    [ value ] = int32(obj)
    [ value ] = int64(obj)
    
    [ value ] = uint8(obj)
    [ value ] = uint16(obj)
    [ value ] = uint32(obj)
    [ value ] = uint64(obj)

    [ value ] = logical(obj)    
  end
end
