extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var textbox_container = $TextboxContainer
@onready var text = $TextboxContainer/MarginContainer/HBoxContainer/Text
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End

@onready var tween : Tween = get_tree().create_tween()

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []
var showing_tutorial_text = false
var showing_level_completed_text = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_textbox()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("confirm"):
				tween.stop()
				text.visible_characters = -1
				on_tween_finished()
		State.FINISHED:
			if Input.is_action_just_pressed("confirm"):
				change_state(State.READY)
				if text_queue.is_empty():
					if showing_tutorial_text:
						showing_tutorial_text = false
						DataTracker.tutorial_completed = true
					
					if showing_level_completed_text:
						showing_level_completed_text = false
						DataTracker.set_highest_level($"..".level_number + 1)
						DataTracker.go_to_level_select = true
						DataTracker.level_completed = true
				hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)
	
func queue_level_complete_text():
	text_queue.push_back("Level " + str($"..".level_number) + " Complete!")
	showing_level_completed_text = true

func hide_textbox():
	text.text = ""
	end_symbol.text = ""
	if text_queue.is_empty():
		textbox_container.hide()

func show_textbox():
	DataTracker.textbox_done = false
	textbox_container.show()
	
func display_text():
	var next_text = text_queue.pop_front()
	text.visible_characters = 0
	text.text = next_text
	change_state(State.READING)
	show_textbox()
	tween = get_tree().create_tween()
	tween.tween_property(text, "visible_ratio", 1, CHAR_READ_RATE * len(next_text)).from(0).finished
	tween.connect("finished", on_tween_finished)
	
func on_tween_finished():
	end_symbol.text = "<-"
	change_state(State.FINISHED)

func change_state(next_state):
	current_state = next_state
	
