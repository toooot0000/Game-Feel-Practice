extends Node
class_name EaseMove

@export var is_active := true
@export var max_spd := 100.0
@export var dist_range := 100.0
@export var tolerance := 5.0
@export var curveText: CurveTexture
@export var target :Node:
	set(val):
		if !("position" in val) || !(val.get("position") is Vector2):
			printerr("[EaseMove] target does have position property!")
		target = val

@export var target_position :Vector2 

func _process(delta):
	if !is_active: return
	var cur_dir = (target_position - target.position)
	var cur_dist = cur_dir.length()
	cur_dist = clamp(cur_dist, 0, dist_range)
	if cur_dist < tolerance:
		target.position = target_position
		is_active = false
		return
	var i = cur_dist / dist_range
	i = curveText.curve.sample_baked(i)
	var spd = i * max_spd * cur_dir.normalized()
	target.position += spd * delta 
	pass
