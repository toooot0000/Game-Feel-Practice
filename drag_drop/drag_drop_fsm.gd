extends FSM

signal start_dragging
signal end_dragging

func _ready():
	super._ready()
	var parent = get_parent()
	if parent is Control:
		var con = parent as Control
		con.mouse_entered.connect($Idle._on_mouse_entered)
		con.mouse_exited.connect($Hovering._on_mouse_exited)

var _config = {
	"idle": func (_fsm: FSM, _curState: State):
		return "hovering",
	"hovering": func(_fsm: FSM, curState: State):
		match curState.complete_type:
			DragDrop_Hovering.COMPLETE_TYPE.MOUSE_BUTTON_DOWN:
				return Transition.transition_with_name("dragging").with_did_transition(func(_1, _2, _3): start_dragging.emit())
			_:
				return "idle"
		pass,
	"dragging": func(_fsm: FSM, _curState: State):
		return Transition.transition_with_name("hovering").with_did_transition(
			func(_1, _2, _3): 
				end_dragging.emit())
}

## Get the config of the state transition
## 
## the key is the state name, the value is the decision method
## The decision method accept:
## 		1. the fsm
## 		2. the start state object
## and return a transition object. 
## 
func get_transitions() -> Dictionary:
	return _config