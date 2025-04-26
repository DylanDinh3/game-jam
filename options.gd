extends Control

@onready var volume_slider = $VolumeSlider

signal exit_options_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$BackButton.grab_focus()
	set_process(false)


func _on_back_button_pressed() -> void:
	exit_options_menu.emit()


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
