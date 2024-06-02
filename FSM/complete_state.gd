#mata-description: Predefined state script
extends State
class_name CompleteState

## The complete type of this state, default IDLE, meaning it 
enum COMPLETE_TYPE { IDLE }

## Step from the previous state
func step_in(_from: State):
	if len(fsm.layers) <= 1:
		return
	fsm.layers.pop_back()
	fsm.did_complete.emit(fsm)