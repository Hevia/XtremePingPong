class_name EnemyAttackSpark extends GPUParticles3D

@onready var timer: Timer = Timer.new()
@onready var circle_indicator_spark: GPUParticles3D = %CircleIndicatorSpark

func _ready() -> void:
	timer.wait_time = self.lifetime
	add_child(timer)
	emitting = true
	circle_indicator_spark.emitting = true
	timer.timeout.connect(on_timer_timeout)

func on_timer_timeout() -> void:
	queue_free()
