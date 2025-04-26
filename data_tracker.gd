extends Node

var current_level = 1
var level_completed = false
var textbox_done = false
var tutorial_completed = false
var go_to_level_select = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func set_highest_level(level_number: int):
	if level_number > current_level:
		current_level = level_number
