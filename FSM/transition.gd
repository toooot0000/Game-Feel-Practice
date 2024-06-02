extends Object

## This class represent the transition method
class_name Transition


#SECTION - Utility

static func transition_with_name(name: StringName) -> Transition:
	var transition = Transition.new()
	transition.target_name = name
	return transition

static func transition_with_name_and_did_transition(name: StringName, did_transition: Callable) -> Transition:
	var transition = Transition.new()
	transition.target_name = name
	transition.did_transition = did_transition
	return transition

#!SECTION

## The name for the target state name
var target_name: StringName

## Callback before the transition starts, _current_state
## param: 1) fsm; 2) start state; 3) target_state
## return: `nothing
var will_transition: Callable

## Callback called after the transition is done 
## param: 1) fsm; 2) start state; 3) target_state
## return: `nothing
var did_transition: Callable

## If present, this transition will force the state machine to be in a transition state
## and this method will be called every frame until it returns false.
## param: 1) delta; 2) fsm; 3) start state; 4) target_state;
## return: `bool to indicate the transition is done or not
var in_transition: Callable
