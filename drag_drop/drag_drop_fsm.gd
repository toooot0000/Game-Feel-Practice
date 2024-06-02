extends FSM

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
				return "dragging"
			_:
				return "idle"
		pass,
	"dragging": func(_fsm: FSM, _curState: State):
		return "hovering"
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