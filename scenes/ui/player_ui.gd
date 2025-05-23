class_name PlayerUI extends CanvasLayer

@onready var health_label: Label = %HealthLabel
@onready var charge_percent_label: Label = %ChargePercentLabel
@export var player: Player
@onready var vignette: UIVignette = %Vignette
@onready var enemies_count_label: Label = %EnemiesCountLabel
@onready var diff_label: Label = %DiffLabel

func _ready() -> void:
	diff_label.text = "Difficulty: " + str(GameState.current_difficulty.name)

func play_damage_vignette() -> void:
	vignette.play_damage_vignette()

func set_health_label(new_health_value: float, max_health_value: float) -> void:
	health_label.text = "Health: " + str(new_health_value) + "/" + str(max_health_value)

func set_enemies_count_label(new_enemies_value: int, max_enemies_value: int) -> void:
	enemies_count_label.text = "Enemies: " + str(new_enemies_value) + "/" + str(max_enemies_value)

func set_change_label(charge_percent: float) -> void:
	charge_percent_label.text = "Charge: " + str(charge_percent) + "%"
