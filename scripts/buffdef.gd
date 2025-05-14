class_name BuffDef extends Node

var timer: Timer = null
var character_owner: CharacterBase = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func apply_buff() -> void:
	pass

func remove_buff() -> void:
	pass

func add_timer(wait_time: float) -> Timer:
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = wait_time
	timer.timeout.connect(on_timer_end)
	self.add_child(timer)
	timer.start()
	return timer
	
func on_timer_end() -> void:
	remove_buff()
	queue_free()
