extends FSM

## Get the config of the state transition
## 
## the key is the state name, the value is the decision method
## The decision method accept:
## 		1. the fsm
## 		2. the start state object
## and return a transition object. 
## 
func get_transitions() -> Dictionary:
	return {}
