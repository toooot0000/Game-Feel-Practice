extends Object
class_name PropertyModQueue

class ValueStruct:
	var path: NodePath
	var init_value
	var start_value
	var current_value

var target: Node
var values = {}

func _init(_target: Node, property_paths: Array[NodePath]):
	self.target = _target
	for path in property_paths:
		values[path] = ValueStruct.new()
		values[path].init_value = target.get_indexed(path)
		values[path].path = path

func _on_play():
	for val in values.values():
		val.start_value = target.get_indexed(val.path)

func submit_value(property_path: NodePath, value):
	values[property_path].current_value = value

func apply_value():
	for val in values.values():
		target.set_indexed(val.path, val.current_value)

func get_init_value(property_path: NodePath):
	return values[property_path].init_value

func get_start_value(property_path: NodePath):
	return values[property_path].start_value