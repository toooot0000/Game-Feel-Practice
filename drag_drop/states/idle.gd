#mata-description: Predefined state script
extends State
class_name DragDrop_Idle

## The complete type of this state, default IDLE, meaning it 
enum COMPLETE_TYPE { IDLE, MOUSE_ENTERED }

## Step from the previous state
func step_in(from: State):
	pass

## Called when step out to another step, called before `to`'s step_in function
func step_out(to: State):
	pass

## Update method. Called every frame
func update(delta: float):
	pass

func _on_mouse_entered():
	complete_with_type(COMPLETE_TYPE.MOUSE_ENTERED)

