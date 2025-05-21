class_name PlayerUI extends CanvasLayer

@onready var health_label: Label = %HealthLabel
@onready var paddle_count_label: Label = %PaddleCountLabel
@onready var dash_count_label: Label = %DashCountLabel
@onready var charge_percent_label: Label = %ChargePercentLabel
@export var player: Player
@onready var vignette: UIVignette = %Vignette


func play_damage_vignette() -> void:
	vignette.play_damage_vignette()

func set_health_label(new_health_value: float, max_health_value: float) -> void:
	health_label.text = "Health: " + str(new_health_value) + "/" + str(max_health_value)

func set_dash_label(new_dash_value: float, max_dash_value: float) -> void:
	dash_count_label.text = "Dashes: " + str(new_dash_value) + "/" + str(max_dash_value)

func set_paddles_label(new_paddles_value: float, max_paddles_value: float) -> void:
	paddle_count_label.text = "Paddles: " + str(new_paddles_value) + "/" + str(max_paddles_value)

func set_change_label(charge_percent: float) -> void:
	charge_percent_label.text = "Charge: " + str(charge_percent) + "%"
