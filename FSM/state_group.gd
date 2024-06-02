extends State
class_name StateGroup

## The initial state name. 
@export var initial_state_name :StringName = ""

func step_in(_from: State):
	var layer = FSM.Layer.new()
	layer.state_getter = func(): return FSM._load_all_states(self)
	layer.transitions_getter = get_transitions
	fsm.layers.append(layer)
	fsm._current_state = FSM._load_all_states(self).filter(func(s:State): return s.state_name == initial_state_name)[0]

#SECTION - Abstract Methods

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

#!SECTION