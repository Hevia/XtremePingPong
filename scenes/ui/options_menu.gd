extends CanvasLayer


@onready var mouse_sen_slider: HSlider = %MouseSenSlider
@onready var mouse_sen_label: Label = %MouseSenLabel
@onready var sandbox_button: Button = %SandboxButton
@onready var demo_button: Button = %DemoButton

func _ready() -> void:
	sandbox_button.pressed.connect(on_sandbox_pressed)
	demo_button.pressed.connect(on_demo_pressed)
	mouse_sen_slider.value_changed.connect(on_mouse_sen_changed)
	mouse_sen_slider.value = GameState.mouse_sensitivity * 100
	mouse_sen_label.text = str(mouse_sen_slider.value) # TODO: This sucks
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func on_mouse_sen_changed(value: float) -> void:
	mouse_sen_label.text = str(value)
	GameState.mouse_sen_changed(value)

func on_demo_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://scenes/levels/w_1_1.tscn")

func on_sandbox_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://scenes/world.tscn")
