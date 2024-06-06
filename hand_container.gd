extends Path2D

@export var max_normalized_distance := 0.2

var count: int :
	get:
		return get_child_count()

var points: Array[float]:
	get:
		if count == 0:
			return []
		if count == 1:
			return [0.5]
		var dist :float = min(1.0 / (count - 1), max_normalized_distance)
		var offset :float = (1 - (count - 1) * dist) / 2.0
		var ret : Array[float] = [offset]
		for i in range(count - 1):
			ret.append(offset + (i + 1) * dist)
		return ret

var positions: Array[Vector2]

#SECTION - Public

func get_closest_index(proposed: Vector2) -> int:
	var min_dist := NumberLimits.FLOAT_MAX
	var ret := -1
	for i in range(len(positions)):
		var p = positions[i]
		var cur_dist = (proposed - p).length()
		if cur_dist < min_dist:
			min_dist = cur_dist
			ret = i
	return ret


func propose_position(node: Node) -> Vector2:
	var requested_ind = get_closest_index(node.position)
	move_child(node, requested_ind)
	for i in range(count):
		var ch = get_child(i)
		if ch == node: continue
		ch.receive_position(positions[i])
	return positions[requested_ind]
		

#!SECTION

#SECTION - Private

func update_positions():
	positions = []
	for i in points:
		var offset = curve.get_baked_length() * i
		positions.append(curve.sample_baked(offset))

#!SECTION

#SECTION - LifeCycle

func _ready():
	update_positions()
	for i in range(count):
		var ch = get_child(i)
		ch.receive_position(positions[i])

#!SECTION
