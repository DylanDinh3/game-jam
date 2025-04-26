extends Control

signal exit_credits_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$BackButton.grab_focus()
	set_process(false)


func _on_button_pressed() -> void:
	exit_credits_menu.emit()
