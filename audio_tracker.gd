extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_music_to_level_waltz_theme():
	if AudioTracker.stream.resource_path != "res://Level Waltz Theme.wav":
		AudioTracker.playing = false
		AudioTracker.volume_db = 0
		AudioTracker.stream = load("res://Level Waltz Theme.wav")
		AudioTracker.play()

func change_music_to_menu_theme():
	if AudioTracker.stream.resource_path != "res://Menu Theme.wav":
		AudioTracker.playing = false
		AudioTracker.volume_db = 0
		AudioTracker.stream = load("res://Menu Theme.wav")
		AudioTracker.play()

func change_music_to_level_bossa_theme():
	if AudioTracker.stream.resource_path != "res://Level Bossa Theme.wav":
		AudioTracker.playing = false
		AudioTracker.volume_db = -10
		AudioTracker.stream = load("res://Level Bossa Theme.wav")
		AudioTracker.play()
