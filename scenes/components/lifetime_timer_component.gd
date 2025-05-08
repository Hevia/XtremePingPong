class_name LifetimeTimerComponent extends Timer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.timeout.connect(on_self_timeout)

func on_self_timeout() -> void:
	# TODO: Call defer this I think
	owner.queue_free()
