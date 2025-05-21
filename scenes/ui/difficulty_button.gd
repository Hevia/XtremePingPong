class_name DifficultyButton extends Button

@export var difficulty: Difficulty

func _ready() -> void:
	self.pressed.connect(on_button_pressed)

func on_button_pressed() -> void:
	if difficulty:
		GameState.current_difficulty = difficulty
	else:
		print("Uh oh difficulty is null!")
