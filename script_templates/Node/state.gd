#mata-description: Predefined state script
extends State
class_name _CLASS_

## The complete type of this state, default IDLE, meaning it 
enum COMPLETE_TYPE { IDLE }

## Step from the previous state
func step_in(from: State):
	pass

## Called when step out to another step, called before `to`'s step_in function
func step_out(to: State):
	pass

## Update method. Called every frame
func update(delta: float):
	pass