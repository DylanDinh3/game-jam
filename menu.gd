extends Control

@onready var margin_container := $MarginContainer
@onready var level_select := $LevelSelect
@onready var options_menu := $Options
@onready var credits_menu := $Credits


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataTracker.current_level = 10
	$MarginContainer/VBoxContainer/HBoxContainer/StartButton.grab_focus()
	
	if DataTracker.go_to_level_select:
		_on_start_button_pressed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	margin_container.visible = false
	level_select.set_process(true)
	level_select.visible = true

func _on_options_button_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func _on_credits_button_pressed() -> void:
	margin_container.visible = false
	credits_menu.set_process(true)
	credits_menu.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_level_select_exit_level_select() -> void:
	margin_container.visible = true
	$MarginContainer/VBoxContainer/HBoxContainer/StartButton.grab_focus()
	level_select.set_process(false)
	level_select.visible = false


func _on_options_exit_options_menu() -> void:
	margin_container.visible = true
	$MarginContainer/VBoxContainer/HBoxContainer/OptionsButton.grab_focus()
	options_menu.set_process(false)
	options_menu.visible = false


func _on_credits_exit_credits_menu() -> void:
	margin_container.visible = true
	$MarginContainer/VBoxContainer/HBoxContainer/CreditsButton.grab_focus()
	credits_menu.set_process(false)
	credits_menu.visible = false
