
@tool
@icon("count_down.svg")
class_name CountDown
extends Label


signal counting_finished


#ANCHOR:counting_steps
@export var counting_steps: Array[String]= ["3", "2", "1", "GO!"]


@export_range(0.01, 2.0, 0.01, "or_greater", "suffix:seconds") var step_duration := 0.5
@export var autostart := false

var _tween : Tween


func _init() -> void:
	
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	theme = preload("count_down_theme.tres")


func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
	
	if get_tree().current_scene == self or autostart:
		start_counting()



func start_counting():
	
	
	stop_counting()
	
	
	show()
	
	_tween = create_tween()\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)
	
	
	for current_text in counting_steps:
		
		_tween.tween_property(self, "scale", Vector2.ONE, step_duration)\
			.from(Vector2.ONE * 0.5)
		
		
		_tween.tween_callback(func():
			text = current_text
			
			pivot_offset = get_combined_minimum_size() / 2.0
		)
	
	
	_tween.tween_property(self, "scale", Vector2.ZERO, 0.2)\
		.set_ease(Tween.EASE_IN)\
		.set_delay(step_duration)
	
	_tween.tween_callback(func():
		stop_counting()
		counting_finished.emit()
	)



func stop_counting() -> void:
	
	if _tween and _tween.is_valid(): 
		_tween.kill()
	
	text = ""
	
	visible = false
