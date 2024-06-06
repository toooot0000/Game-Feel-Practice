extends Node
class_name Swing

var is_active := false:
	set(val):
		is_active = val
		if is_active:
			_origin_pivot = get_parent().pivot_offset
		else:
			_diff = null
		

var _origin_pivot :Vector2
var _prev_mouse :Vector2
var _cur_mouse :Vector2
var _diff

func _input(event):
	if event is InputEventMouse:
		var m = event as InputEventMouse
		_prev_mouse = _cur_mouse
		_cur_mouse = m.position
		_diff = _cur_mouse - _prev_mouse
	pass


func _process(delta):
	pass