class_name MenuBase extends CanvasLayer


var options_scene: PackedScene = preload("res://scenes/ui/options_menu.tscn")

# Where the bulk of the content is stored
@export var main_margin_container: MarginContainer

func hide_main_content() -> void:
	main_margin_container.visible = false
	main_margin_container.process_mode = Node.PROCESS_MODE_DISABLED

func reveal_main_content() -> void:
	main_margin_container.visible = true
	main_margin_container.process_mode = Node.PROCESS_MODE_INHERIT
	
func on_options_pressed() -> void:
	var options_instance: OptionsMenu = options_scene.instantiate()
	add_child(options_instance)
	hide_main_content()
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))
	
func on_options_closed(options_instance: Node):
	reveal_main_content()
	options_instance.queue_free()
