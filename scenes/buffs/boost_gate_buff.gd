class_name BoostGateBuff extends BuffDef


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func apply_buff() -> void:
	character_owner.BASE_SPEED_BOOST += 10

func remove_buff() -> void:
	character_owner.BASE_SPEED_BOOST -= 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
