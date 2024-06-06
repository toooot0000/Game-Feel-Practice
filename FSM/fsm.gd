extends Node
class_name FSM


class Layer:
	extends Object
	var state_getter: Callable
	var transitions_getter: Callable

#SECTION - Life Cycle

func _ready():
	
	if complete_state == null:
		complete_state = State.new()
		complete_state.name = "CompleteState"
		complete_state.state_name = FSM.FSM_COMPLETE_STATE_NAME
		$"/root".add_child.call_deferred(complete_state)
	pass

	var state = get_state_by_name(initial_state_name)
	if !state:
		printerr("[FSM] Can't initialize FSM with a unknown initial state (%s)" % initial_state_name)
		return
	_current_state = state
	

func _process(delta):
	if !is_active: return 
	if !_is_in_transition:
		if !_current_state:
			return
		_current_state.update(delta)
		return
	var next = states.filter(func(s: State): return s.state_name == _current_transition.target_name)[0]
	var transition_finished = _current_transition.in_transition.callv([delta, self, _current_state, next])
	if transition_finished:
		var prev = _current_state
		_current_state = next
		_is_in_transition = false
		_current_transition = null
		_current_transition.did_transition.callv([self, prev, next])
	pass

#!SECTION

#SECTION - Private

var _current_state: State:
	set(val):
		val.fsm = self

		var old = _current_state
		_current_state = val
		if old:
			old.step_out(val)
		if val: 
			val.step_in(old)
		state_did_changed.emit(self, old, val)

var _is_in_transition := false
var _current_transition :Transition 

static func _load_all_states(node: Node) -> Array[State]:
	var ret :Array[State] = []
	ret.assign(node.get_children().filter(func(ch): return (ch is State)))
	for state in ret:
		if node.has_method("_on_state_complete"):
			state.complete.connect(node._on_state_complete)
	print("[FSM] %s loaded %d states: %s" %[node, len(ret), ret])
	return ret

func _on_state_complete(state: State, complete_type):
	if !is_active: 
		printerr("[FSM] Try to complete a state(%s) when fsm is not active!" % state.state_name)
		return

	if state != _current_state:
		printerr("[FSM] Try to complete a state(%s) that is not current state!" % state.state_name)
		return

	if _is_in_transition:
		printerr("[FSM] Trying to complete a state(%s) when FSM is in transition!" % state.state_name)
		return

	var transitions := get_transitions()

	var decision := transitions[state.state_name] as Callable
	if !decision:
		printerr("[FSN] Can't find a decition function for the current statd(%s)!\nCheck your transition declaration!" % state.state_name)
		return

	var result = decision.callv([self, _current_state])

	if !result:
		printerr("[FSN] Decision function didn't return a trnansition object for the current statd(%s)!\nCheck your transition declaration!" % state.state_name)
		return
	
	print("[FSM] %s is complete state(%s) with complete_type as %d" %[self, state, complete_type])

	if result is Transition:
		_handle_transition(result, state)
	elif result is String:
		_handle_string_transition(result, state)


func _handle_transition(transition: Transition, state: State):
	if !transition:
		printerr("[FSN] Decision function didn't return a trnansition object for the current statd(%s)!\nCheck your transition declaration!" % state.state_name)
		return

	var next :State
	if transition.target_name == FSM_COMPLETE_STATE_NAME :
		next = complete_state
	else:
		if !states.any(func(s: State): return s.state_name == transition.target_name):
			printerr("[FSN] Can't find a target state with name of %s from the transition object from state %s\nCheck your transition declaration!" % [transition.target_name, state.state_name])
			return
		next = states.filter(func(s: State): return s.state_name == transition.target_name)[0] 

	var callback_params = [self, state, next]

	if transition.will_transition:
		transition.will_transition.callv(callback_params)

	if transition.in_transition:
		_is_in_transition = true
		_current_transition = transition
	else:
		_current_state = next
		if transition.did_transition:
			transition.did_transition.callv(callback_params)

func _handle_string_transition(target_name: String, state: State):
	var transition = Transition.transition_with_name(target_name)
	_handle_transition(transition, state)

func _create_init_layer() -> Layer:
	var ret = Layer.new()
	ret.transitions_getter = get_transitions
	ret.state_getter = func(): return FSM._load_all_states(self)
	return ret

#!SECTION

#SECTION - Public

## The complete state. Placeholder for complete state
static var complete_state: State

## The name for complete state
const FSM_COMPLETE_STATE_NAME = StringName("_fsm_complete")

## The initial state name. 
@export var initial_state_name :StringName = ""

## Set if this fsm is active
@export var is_active := true 

## The all state node
@onready var states :Array[State] = FSM._load_all_states(self)

## Layer Info in the FSM
@onready var layers :Array[Layer] = [_create_init_layer()]


var current_layer: Layer :
	get:
		return layers[-1]

## Setter has no effects!
var is_in_transition: bool:
	get:
		return _is_in_transition

## emit whenever state is changed. 
## params: 1) FSM; 2) the old state; 3) the new state;
## the new state is guarenteed to be the same with get_current_state()
signal state_did_changed(fsm:FSM, old: State, new: State)

## emit when the FSM is complete and become inactive
## gaurentee: 
## 	get_current_state() == nil
## 	is_active = false
signal did_complete(fsm: FSM)


## return the current state
func get_current_state() -> State:
	return _current_state

## get the state by a state_name
func get_state_by_name(target_name: StringName) -> State:
	var same_name := func (s: State): return s.state_name == target_name
	if !states.any(same_name):
		printerr("[FSN] Can't find a state with name of %s!" % [target_name])
		return null
	return states.filter(same_name)[0]
		

#!SECTION

#SECTION - Abstract Methods

## Get the config of the state transition
## 
## the key is the state name, the value is the decision method
## The decision method accept:
## 		1. the fsm
## 		2. the start state object
## and return a transition object || string
## 
func get_transitions() -> Dictionary:
	return {}

#!SECTION