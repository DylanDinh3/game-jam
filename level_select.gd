extends Control

signal exit_level_select

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$MarginContainer/GridContainer/Level1Button.grab_focus()
	for n in DataTracker.current_level:
		var button_name = "MarginContainer/GridContainer/Level" + str(n + 1) + "Button"
		var level_button = get_node(button_name)
		if level_button == null:
			continue
		
		level_button.disabled = false
		level_button.grab_focus()
	DataTracker.level_completed = false
	DataTracker.textbox_done = false
	DataTracker.go_to_level_select = false
	set_process(false)


func _on_back_button_pressed() -> void:
	exit_level_select.emit()
	AudioTrackerScript.change_music_to_menu_theme()


func _on_level_button_pressed(level_number: int) -> void:
	if level_number < 6:
		AudioTrackerScript.change_music_to_level_waltz_theme()
	elif level_number >= 6:
		AudioTrackerScript.change_music_to_level_bossa_theme()
	var level_name = "res://level" + str(level_number) + ".tscn"
	get_tree().change_scene_to_file(level_name)
