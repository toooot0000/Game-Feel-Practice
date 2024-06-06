extends Tweeny
class_name TweenyColor


@export var start_value: Color:
	set(val):
		start_value = val
		_start = val

@export var end_value: Color:
	set(val):
		end_value = val
		_end = val

