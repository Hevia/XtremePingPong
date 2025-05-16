class_name Dog extends CharacterBase


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var tutorial_detection_area3d: Area3D = null

func _ready() -> void:
	if tutorial_detection_area3d:
		tutorial_detection_area3d.area_entered.connect(on_tut_area_entered)
		tutorial_detection_area3d.area_exited.connect(on_tut_area_exited)
	else:
		print("Tutorial Area3D for dog not configured!")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	
func toggle_visibility() -> void:
	self.visible = !self.visible

func on_tut_area_entered(other_area: Area3D) -> void:
	print("area entered")
	if other_area and other_area.owner is Player:
		toggle_visibility()

func on_tut_area_exited(other_area: Area3D) -> void:
	print("area exited")
	if other_area and other_area.owner is Player:
		toggle_visibility()
