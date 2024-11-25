extends RichTextLabel

var distance: Vector2
@onready var camera_2d: Camera2D = $"../Camera2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	distance = camera_2d.global_position - global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = camera_2d.global_position - distance
	text = "$$$: " + str(Globals.money)
