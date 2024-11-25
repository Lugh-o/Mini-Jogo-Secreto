extends Node2D

var pressed: int

@onready var camera_2d: Camera2D = $".."

var target_pos: Vector2

var item1Price: int = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed = 1
	target_pos = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = position.move_toward(target_pos, 1000 * delta)

func _on_shop_button_pressed() -> void:
	target_pos = Vector2(target_pos.x, target_pos.y + 220 * pressed)
	pressed = pressed * (-1)


func _on_item_button_pressed() -> void:
	if(Globals.money >= item1Price):
		Globals.tape_ammount += 1
		Globals.money -= item1Price
