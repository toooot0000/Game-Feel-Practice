#mata-description: Predefined state script
extends State
class_name DragDrop_Hovering

## The complete type of this state, default IDLE, meaning it 
enum COMPLETE_TYPE { IDLE, MOUSE_EXITED, MOUSE_BUTTON_DOWN }

## Step from the previous state
func step_in(from: State):
	pass

## Called when step out to another step, called before `to`'s step_in function
func step_out(to: State):
	pass

## Update method. Called every frame
func update(delta):
	if Input.is_action_just_pressed("mouse_button_left"):
		complete_with_type(COMPLETE_TYPE.MOUSE_BUTTON_DOWN)
	pass

func _on_mouse_exited():
	if fsm.is_active &&is_current_state():
		complete_with_type(COMPLETE_TYPE.MOUSE_EXITED)
