extends Node
class_name State

## The unique name for this state that should not be changed
@export var state_name :StringName = ""

## The complete type. Can be used to track how the state exits
var complete_type = null

## Current FSM
var fsm: FSM

## The signal that notify fsm to make state transition
signal complete(state: State, complete_type)

## Use this method to complete this state
func complete_with_type(type):
	if fsm.get_current_state() != self: return
	complete_type = type
	complete.emit(self, type)

func is_current_state() -> bool:
	return fsm.get_current_state() == self

#SECTION - State Interfaces

## Step from the previous state
func step_in(from: State):
	pass

## Called when step out to another step, called before `to`'s step_in function
func step_out(to: State):
	pass

## Update method. Called every frame
func update(delta: float):
	pass

#!SECTION
