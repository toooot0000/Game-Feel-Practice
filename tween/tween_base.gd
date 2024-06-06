extends Resource

class_name Tweeny


enum ValueRelation { ABSOLUTE, RELATIVE_TO_ORIGIN, RELATIVE_TO_START}
enum EndValueType { ORIGIN, START, END, CURRENT }

@export_group("Common")
@export var name :StringName = "Random"
@export var is_active := true

@export_group("Time")
@export var duration := 1.0
@export var offset := 0.0

@export_group("Parameter")
@export_flags("top_to_bottom:1", "bottom_to_top:2") var available_direction: int = 3
@export var end_value_type := EndValueType.END
@export var target: NodePath
@export var start_value_relation: ValueRelation
@export var end_value_relation: ValueRelation
@export var curve: CurveTexture

@export_group("Debug")
@export var is_debug := false

## Managed by sub classes!
var _start
var _end
var _property_path: NodePath

## Managed by base class 
var _origin
var _origin_on_start

func _get_target_node(driver: TweenyDriver) -> Node:
	return driver.get_node(target)

func _initialize(driver: TweenyDriver):
	var node = driver.get_node(target)
	if !node: return
	_origin = node.get_indexed(_property_path)

func _update(driver: TweenyDriver, current_ratio: float):
	if !is_active: return
	if !(available_direction & driver.direction): return
	
	var normalized_duration := duration / driver.duration
	var normalized_offset := offset / driver.duration
	if is_debug:
		print("[%s] current_ratio = %f, my range = <%f - %f>" %[self, current_ratio, normalized_offset, normalized_offset + normalized_duration])
	if current_ratio < normalized_offset || current_ratio > normalized_duration + normalized_offset: 
		if is_debug: print("[%s] out of range!" % self)
		return 

	var node = driver.get_node(target)
	if !node: return

	if _origin_on_start == null:
		_origin_on_start = node.get_indexed(_property_path)

	var k := (current_ratio - normalized_offset)/normalized_duration
	if curve:
		k = curve.curve.sample_baked(k)
	_execute_action(node, _property_path, _interpolate(driver, k))

func get_related_value(origin_value, relation: ValueRelation):
	match relation:
		ValueRelation.ABSOLUTE:
			return origin_value
		ValueRelation.RELATIVE_TO_ORIGIN:
			return origin_value + _origin
		ValueRelation.RELATIVE_TO_START:
			return origin_value + _origin_on_start
		_:
			return origin_value + _origin

func _interpolate(_driver:TweenyDriver, sampled_value: float):
	var __start = get_related_value(_start, start_value_relation)
	var __end = get_related_value(_end, end_value_relation)
	return _lerp(__start, __end, sampled_value)

func _lerp(start, end, k):
	return lerp(start, end, k)

func _execute_action(node: Node, property_path: NodePath, value):
	node.set_indexed(property_path, value)

func set_value_on_stop(driver: TweenyDriver):
	var node = _get_target_node(driver)
	var k = 1
	if curve:
		k = curve.curve.sample_baked(k)
	var __start = get_related_value(_start, start_value_relation)
	var __end = get_related_value(_end, end_value_relation)
	var value

	match end_value_type:
		EndValueType.CURRENT:
			return
		EndValueType.END:
			value = _lerp(__start, __end, k)
		EndValueType.START:
			value = _origin_on_start
		EndValueType.ORIGIN:
			value = _origin
	
	node.set_indexed(_property_path, value)
