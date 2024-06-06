@tool
extends Tweeny

class_name TweenyGeneric

@export var values := {
	"start": null,
	"end": null
}:
	set(val):
		if (val.has("start") && val.has('end')) || (val.has(0) && val.has(1)):
			values = val
			_value_map = values.keys().reduce(func(accm, key): 
				if (key is String && key == "start") || (key is float && key == 0):
					accm[0.0] = values["start"]
				elif (key is String && key == "end") || (key is float && key == 1):
					accm[1.0] = values["end"]
				elif !(key is float) || key > 1 || key < 0:
					printerr("[Tweeny] Generic value can only have float key and the key should between 0 to 1. Right now the key is %s" % [key])
				else:
					accm[key] = values[key]
				return accm
			, {})
			_sorted_keys.assign(_value_map.keys())
			_sorted_keys.sort()
		else:
			printerr("[Tweeny] Generic values should have \'start\' AND \'end\'")
		pass

@export var property_path: String:
	set(val):
		property_path = val
		var path := NodePath(val)
		if path.is_empty():
			printerr("[Tweeny] Generic property_path(=\'%s\') is not valid!" % val)
			return
		_property_path = path

var _value_map = {}
var _sorted_keys: Array[float] = []

func _lerp(__start, __end, k):
	var ret
	if k <= _sorted_keys[0]:
		ret = lerp(_value_map[_sorted_keys[0]], _value_map[_sorted_keys[1]], k)
	if k >= _sorted_keys[-1]:
		ret = lerp(_value_map[_sorted_keys[-2]], _value_map[_sorted_keys[-1]], k)
	for i in range(len(_sorted_keys) - 1):
		if k < _sorted_keys[i]: continue 
		ret = lerp(_value_map[_sorted_keys[i]], _value_map[_sorted_keys[i+1]], k)
	return ret
	