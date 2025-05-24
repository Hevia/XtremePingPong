extends CanvasLayer

@onready var resume_button: Button = %ResumeButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton
@onready var demo_button: Button = %DemoButton
@onready var restart_button: Button = %RestartButton
@onready var main_menu_button: Button = %MainMenuButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resume_button.pressed.connect(on_resume_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	demo_button.pressed.connect(on_demo_pressed)
	restart_button.pressed.connect(on_restart_pressed)
	main_menu_button.pressed.connect(on_main_menu_pressed)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()

func on_resume_pressed():
	close()
	
func on_quit_pressed():
	get_tree().quit()

func on_restart_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().reload_current_scene()

func on_demo_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://scenes/levels/w_1_1.tscn")
	
func on_main_menu_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/options_menu.tscn")
