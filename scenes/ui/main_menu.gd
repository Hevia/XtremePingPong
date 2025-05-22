class_name MainMenu extends CanvasLayer

@onready var demo_button: Button = %DemoButton
@onready var curr_diff_label: Label = %CurrDiffLabel
@onready var sandbox_button: Button = %SandboxButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	demo_button.pressed.connect(on_demo_pressed)
	sandbox_button.pressed.connect(on_sandbox_pressed)
	GameState.settings_changed.connect(on_settings_changed)
	curr_diff_label.text = GameState.current_difficulty.name
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func on_settings_changed() -> void:
	print("settings changed signal called in this place idk")
	curr_diff_label.text = GameState.current_difficulty.name
	
func on_quit_pressed():
	get_tree().quit()

func on_demo_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/w_1_1.tscn")

func on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/options_menu.tscn")
	
func on_sandbox_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
