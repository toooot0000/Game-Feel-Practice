extends Node
class_name TweenyDriver

#SECTION - Exports

@export var tweenies: Array[Tweeny] = []

#!SECTION

#SECTION - Public

signal complete

## Playback direction
enum PlayDirection { 
	TOP_TO_BOTTOM = 1, 
	BOTTOM_TO_TOP = 2
}

## Playback direction
var direction: PlayDirection = PlayDirection.TOP_TO_BOTTOM

## Is this tweeny is playing?
var is_playing: bool = false

## The duration of 
var duration: float = 1.0:
	set(val):
		_duration = val
		_current_time = _current_ratio * val
	get:
		return _duration

## Normalized time against duration
var current_ratio: float = 0:
	set(val):
		_current_ratio = clamp(val, 0, 1)
		_current_time = _current_ratio * duration
	get:
		return _current_ratio

## Current time
var current_time: float = 0:
	set(val):
		_current_time = clamp(val, 0, duration)
		_current_ratio = current_time/duration
	get:
		return _current_time

func initialize():
	# var _dur = 0.0
	for t in tweenies:
		t._initialize(self)
		# _dur = max(_dur, t.offset + t.duration)
	# duration = _dur


func play(from_start: bool = false, top_to_bottom: bool = true):
	if is_playing: stop()
	is_playing = true
	direction = PlayDirection.TOP_TO_BOTTOM if top_to_bottom else PlayDirection.BOTTOM_TO_TOP
	_update_duration()
	for t in tweenies:
		t._origin_on_start = null
	if from_start:
		current_ratio = 1 if direction == PlayDirection.BOTTOM_TO_TOP else 0
	pass

func pause():
	is_playing = false
	pass

func stop():
	is_playing = false
	current_ratio = 0
	for t in tweenies:
		t.set_value_on_stop(self)
	pass


#!SECTION Public


#SECTION - Private

var _duration :float
var _current_time: float
var _current_ratio: float

func _update_duration():
	var _dur := 0.0
	for t in tweenies:
		if !t.is_active: continue
		if t.available_direction & direction:
			_dur = max(_dur, t.offset + t.duration)
	duration = _dur

#!SECTION

#SECTION - Lify cycle

func _ready():
	initialize()

func _process(delta):
	if !is_playing: return
	current_time = clamp(current_time + delta * ( 1 if direction == PlayDirection.TOP_TO_BOTTOM else -1), 0, duration)
	for t in tweenies:
		t._update(self, current_ratio)
	if (direction == PlayDirection.TOP_TO_BOTTOM && current_time == duration ) || (direction == PlayDirection.BOTTOM_TO_TOP && current_time == 0):
		is_playing = false
		complete.emit()


#!SECTION

