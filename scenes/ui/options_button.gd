class_name OptionsButton extends Button

var options_scene: PackedScene = preload("res://scenes/ui/options_menu.tscn")

func _ready() -> void:
	self.pressed.connect(on_options_button_pressed)

func on_options_button_pressed() -> void:
	var options_instance: OptionsMenu = options_scene.instantiate()
	get_tree().root.add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))
