class_name PearlCleaning
extends Node2D

@onready var main_scene: PackedScene = preload("res://scenes/main_scene/main_scene.tscn")

@onready var brush: Sprite2D = $Brush
@onready var tape: Sprite2D = $Tape
@onready var polish: Sprite2D = $Polish
@onready var pearl: Sprite2D = $Pearl
@onready var shine: Sprite2D = $Shine

var target_pos_brush: Vector2
var target_pos_tape: Vector2
var target_pos_polish: Vector2

const crack_1: PackedScene = preload("res://scenes/pearl_cleaning/crack/crack_1.tscn")
const crack_2: PackedScene = preload("res://scenes/pearl_cleaning/crack/crack_2.tscn")
const crack_3: PackedScene = preload("res://scenes/pearl_cleaning/crack/crack_3.tscn")
var crack_array = [crack_1, crack_2, crack_3]
var cracks

@onready var text: RichTextLabel = $Tape/RichTextLabel
@onready var congratulations: Node2D = $Congratulations

var is_brush = false
var is_tape = false
var is_polish = false

var dirt_cleaned: int = 0
var is_polished: bool = false
var cracks_taped: int = 0

func _ready() -> void:
	create_crack()
	position_tools()

func _process(delta: float) -> void:
	handle_tools(delta)
	check_if_clean()
	handle_text()

func handle_text() -> void:
	text.text = "[font_size=100][right]x" + str(Globals.tape_ammount) + "[/right][/font_size]"

func handle_tools(delta: float) -> void:
	if is_brush:
		brush.position = get_global_mouse_position()
		target_pos_brush = Vector2(276, 633)
	else:
		brush.position = brush.position.move_toward(target_pos_brush, 1000 * delta)
		target_pos_brush = Vector2(276, 533)

	if is_tape:
		tape.position = get_global_mouse_position()
		target_pos_tape = Vector2(576, 633)
	else:
		tape.position = tape.position.move_toward(target_pos_tape, 1000 * delta)
		target_pos_tape = Vector2(576, 533)

	if is_polish:
		polish.position = get_global_mouse_position()
		target_pos_polish = Vector2(876, 633)
	else:
		polish.position = polish.position.move_toward(target_pos_polish, 1000 * delta)
		target_pos_polish = Vector2(876, 533)

func position_tools() -> void:
	target_pos_brush = Vector2(brush.position.x, 633)
	target_pos_tape = Vector2(tape.position.x, 633)
	target_pos_polish = Vector2(polish.position.x, 633)

func create_crack() -> void:
	cracks = Globals.crack_amount
	if cracks > 3: cracks = 3

	for i in range(cracks):
		var crackInstance: Node2D = crack_array[i].instantiate()
		pearl.add_child(crackInstance)

func _on_polish_button_down() -> void:	
	is_polish = true
	is_brush = false
	is_tape = false

func _on_tape_button_down() -> void:
	is_tape = true
	is_brush = false
	is_polish = false

func _on_brush_button_down() -> void:
	is_brush = true
	is_tape = false
	is_polish = false

func _on_brush_area_entered(area: Area2D) -> void:
	if area.is_in_group("dirt") and area.get_parent().visible == true:
		area.get_parent().visible = false
		dirt_cleaned += 1

func _on_tape_area_entered(area: Area2D) -> void:
	if area.is_in_group("crack") and area.get_parent().get_parent().get_child(1).visible == false and Globals.tape_ammount > 0:
		area.get_parent().get_parent().get_child(1).visible = true
		cracks_taped += 1
		Globals.tape_ammount -= 1

func _on_polish_area_entered(area: Area2D) -> void:
	if area.is_in_group("matte") and area.get_parent().visible == true:
		area.get_parent().visible = false
		is_polished = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("clickDir"):
		is_polish = false
		is_brush = false
		is_tape = false

func check_if_clean() -> void:
	var is_cleaned: bool = is_polished and dirt_cleaned == 3
	if is_cleaned:
		shine.visible = true
		Globals.pearl_amount += 1
		Globals.pearl_price -= Globals.crack_amount * 20
		Globals.crack_amount = 0
		congratulations.visible = true
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_packed(main_scene)
