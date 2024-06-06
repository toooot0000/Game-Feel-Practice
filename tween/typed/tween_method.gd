extends TweenyGeneric
class_name TweenyMethod


@export var method_name: String


func _execute_action(node: Node, __property_path: NodePath, value):
	var _target = node.get_indexed(__property_path)
	if !_target:
		printerr("[Tweeny] %s doesn't have property named \'%s\'" %[node, __property_path])
		return
	if !_target.has_method(method_name):
		printerr("[Tweeny] %s doesn't have method named \'%s\'" %[_target, method_name])
		return
	_target.callv(method_name, [value])