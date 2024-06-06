extends Control

signal mouse_just_pressed(control: Control)

var is_dragging :bool:
	get:
		return $DragNDropFSM.get_current_state() is DragDrop_Dragging

func _process(_delta):

	if is_dragging:
		$"..".propose_position(self)

	if Input.is_action_just_pressed("mouse_button_left") && $DragNDropFSM.get_current_state() is DragDrop_Hovering:
		mouse_just_pressed.emit()
	elif Input.is_action_just_released("mouse_button_left") && $DragNDropFSM.get_current_state() is DragDrop_Dragging:
		($ClickingTween as TweenyDriver).play(true, false)

	if Input.is_key_pressed(KEY_A):
		var driver = $ClickingTween as TweenyDriver
		var red = driver.tweenies.filter(func(t): return t.name == "turn_red")[0]
		red.is_active = !red.is_active


func _on_drag_n_drop_fsm_end_dragging():
	var target = $"..".propose_position(self)
	$EaseMove.target_position = target
	$EaseMove.is_active = true


func receive_position(pos):
	$EaseMove.target_position = pos
	$EaseMove.is_active = true

func _on_drag_n_drop_fsm_start_dragging():
	$EaseMove.is_active = false
