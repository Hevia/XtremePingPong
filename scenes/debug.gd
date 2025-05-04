extends PanelContainer

@onready var property_container: VBoxContainer = %PropertyContainer

var property
var frames_per_second: String

func _ready():
	visible = false
	add_debug_property("FPS", frames_per_second)
	
func _input(event):
	if event.is_action_pressed("debug"):
		visible = !visible

func _process(delta):
	frames_per_second = "%.2f" % (1.0/delta)
	property.text = property.name + ": " + frames_per_second

func add_debug_property(title: String, value):
	property = Label.new()
	property_container.add_child(property)
	property.name = title
	property.text = value
	
	
