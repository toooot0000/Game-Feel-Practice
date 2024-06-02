#mata-description: Predefined state script
extends State
class_name DragDrop_Dragging

## The complete type of this state, default IDLE, meaning it 
enum COMPLETE_TYPE { IDLE, MOUSE_RELEASED }

var start_pos: Vector2
var start_mouse_pos: Vector2

## Step from the previous state
func step_in(from: State):
	var parent = fsm.get_parent()
	if parent is Control || parent is Node2D:
		start_pos = parent.position
		start_mouse_pos = get_viewport().get_mouse_position()
	else:
		complete_with_type(COMPLETE_TYPE.IDLE)
	pass

## Called when step out to another step, called before `to`'s step_in function
func step_out(to: State):
	pass

## Update method. Called every frame
func update(delta):
	if Input.is_action_just_released("mouse_button_left"):
		complete_with_type(COMPLETE_TYPE.MOUSE_RELEASED)
		return
	var parent = fsm.get_parent()
	if parent is Control || parent is Node2D:
		var position = start_pos + (get_viewport().get_mouse_position() - start_mouse_pos)
		parent.position = position

	
	
