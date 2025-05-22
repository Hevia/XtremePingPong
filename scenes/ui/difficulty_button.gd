class_name DifficultyButton extends Button

@export var difficulty: Difficulty

func _ready() -> void:
	text = difficulty.name
	self.pressed.connect(on_button_pressed)

func on_button_pressed() -> void:
	if difficulty:
		print(difficulty.name)
		GameState.current_difficulty = difficulty
		GameState.settings_changed.emit()
	else:
		print("Uh oh difficulty is null!")
