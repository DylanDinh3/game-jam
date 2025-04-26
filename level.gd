extends Node2D

@onready var pause_menu = $PauseMenu
@onready var textbox = $Textbox
@export var level_number = 0
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataTracker.set_highest_level(level_number)
	
	if level_number == 1 and !DataTracker.tutorial_completed:
		DataTracker.tutorial_completed = false
		var text_array = ["When autumn arrives, Bird migrates to warmer climate for the winter.                                       (Press Enter or Space to continue.)",
						  "As Bird makes its nest upon the tree of the Tortoise, it guides its friend using its favorite food: fruit.",
						  "Guide Tortoise to the goal, marked with a Green Exclamation Point (!), by pushing fruit onto spaces adjacent to it.",
						  "Move Bird with the Arrow Keys or WASD. Press P to Pause the game and R to Restart the stage."]
		textbox.showing_tutorial_text = true
		show_textbox(text_array)
	else:
		DataTracker.tutorial_completed = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_pause_menu()
		
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		
	if DataTracker.level_completed:
		get_tree().change_scene_to_file("res://menu.tscn")

func _pause_menu() -> void:
	if paused:
		pause_menu.hide()
		get_tree().paused = false
	else:
		pause_menu.show()
		pause_menu.set_process(true)
		get_tree().paused = true
		
	paused = !paused


func _on_pause_menu_resume_button_pressed() -> void:
	pause_menu.hide()
	get_tree().paused = false
	paused = false

func _on_pause_menu_restart_button_pressed() -> void:
	pause_menu.hide()
	get_tree().paused = false
	DataTracker.level_completed = false
	DataTracker.textbox_done = false
	get_tree().reload_current_scene()

func _on_pause_menu_exit_button_pressed() -> void:
	get_tree().paused = false
	DataTracker.go_to_level_select = true
	get_tree().change_scene_to_file("res://menu.tscn")
	

func show_level_completed_textbox():
	textbox.visible = true
	textbox.show_textbox()
	textbox.queue_level_complete_text()

func show_textbox(text_array: Array):
	textbox.visible = true
	textbox.show_textbox()
	for n in text_array.size():
		textbox.queue_text(text_array[n])
