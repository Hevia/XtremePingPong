extends CanvasLayer

@export var music_player: DemoMusicPlayer

@onready var death_tip: Label = %DeathTip
@onready var restart_button: Button = %RestartButton
@onready var quit_button: Button = %QuitButton
@onready var options_button: Button = %OptionsButton
@onready var main_menu_button: Button = %MainMenuButton


func _ready() -> void:
	set_death_tip()
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	restart_button.pressed.connect(on_restart_pressed)
	main_menu_button.pressed.connect(on_main_menu_pressed)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func ensure_music_stays_consistent() -> void:
	GameState.music_progress = music_player.get_playback_position()
	
	
func set_death_tip():
	var death_msg = GameState.death_tip_msg
	
	if death_msg == "" or not death_msg or death_msg == " ":
		death_msg = Constants.GeneralDeathTips.pick_random()
		
	death_tip.text = death_msg
	

func close():
	get_tree().paused = false
	ensure_music_stays_consistent()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()
	
func on_quit_pressed():
	get_tree().quit()
	
func on_main_menu_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func on_restart_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ensure_music_stays_consistent()
	get_tree().reload_current_scene()
	queue_free()

func on_options_pressed():
	pass
