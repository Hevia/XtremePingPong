class_name OptionsMenu extends CanvasLayer

signal back_pressed

@onready var mouse_sen_slider: HSlider = %MouseSenSlider
@onready var mouse_sen_label: Label = %MouseSenLabel
@onready var back_button: Button = %BackButton

func _ready() -> void:
	mouse_sen_slider.value_changed.connect(on_mouse_sen_changed)
	back_button.pressed.connect(on_back_pressed)
	mouse_sen_slider.value = GameState.mouse_sensitivity * 100
	mouse_sen_label.text = str(mouse_sen_slider.value) # TODO: This sucks
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func on_mouse_sen_changed(value: float) -> void:
	mouse_sen_label.text = str(value)
	GameState.mouse_sen_changed(value)

func on_back_pressed() -> void:
	back_pressed.emit()
