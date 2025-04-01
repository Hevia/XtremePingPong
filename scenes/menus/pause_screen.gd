extends CanvasLayer

@onready var resume_button: Button = %ResumeButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resume_button.pressed.connect(on_resume_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()

func on_resume_pressed():
	close()
	
func on_quit_pressed():
	get_tree().quit()


func on_options_pressed():
	pass
