extends CanvasLayer

@onready var death_tip: Label = %DeathTip
@onready var restart_button: Button = %RestartButton
@onready var quit_button: Button = %QuitButton
@onready var options_button: Button = %OptionsButton


func _ready() -> void:
	set_death_tip()
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	restart_button.pressed.connect(on_restart_pressed)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func set_death_tip():
	var death_msg = GameState.death_tip_msg
	
	if death_msg == "" or not death_msg or death_msg == " ":
		death_msg = Constants.GeneralDeathTips.pick_random()
		
	death_tip.text = death_msg
	

func close():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()
	
func on_quit_pressed():
	get_tree().quit()

func on_restart_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().reload_current_scene()
	queue_free()

func on_options_pressed():
	pass
