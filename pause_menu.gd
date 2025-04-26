extends CanvasLayer

signal resume_button_pressed
signal restart_button_pressed
signal exit_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$MarginContainer/VBoxContainer/ResumeButton.grab_focus()
	set_process(false)


func _on_resume_button_pressed() -> void:
	resume_button_pressed.emit()

func _on_restart_button_pressed() -> void:
	restart_button_pressed.emit()

func _on_quit_button_pressed() -> void:
	exit_button_pressed.emit()
