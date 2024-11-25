class_name PearlHarvesting
extends Node2D

const main_scene = preload("res://scenes/main_scene/main_scene.tscn")

const oyster_1_closed: PackedScene = preload("res://scenes/pearl_harvesting/oysters/oyster_1_closed.tscn")
const oyster_1_open: PackedScene = preload("res://scenes/pearl_harvesting/oysters/oyster_1_open.tscn")
const oyster_2_closed: PackedScene = preload("res://scenes/pearl_harvesting/oysters/oyster_2_closed.tscn")
const oyster_2_open: PackedScene = preload("res://scenes/pearl_harvesting/oysters/oyster_2_open.tscn")

const oyster_array: Array = [[oyster_1_closed, oyster_1_open], [oyster_2_closed, oyster_2_open]]
var oyster_chosen: Array = []

var target_position_pliers: Vector2
var target_position_spoon: Vector2

const pearl: PackedScene = preload("res://scenes/pearl_harvesting/pearl.tscn")
var pearl_instance
@onready var congratulations: Node2D = $Congratulations

@onready var pliers: Sprite2D = $PearlMinigameMain/Pliers
@onready var pliers_collision_2d: CollisionShape2D = $PearlMinigameMain/Spoon/Area2D/CollisionShape2D

@onready var spoon: Sprite2D = $PearlMinigameMain/Spoon
var is_pliers: bool = false
var is_spoon: bool = false
var is_colliding: bool = false
var is_pliers_locked: bool = false
var is_pearl_picked: bool = false

@onready var camera_2d: Camera2D = $Camera2D
@onready var pearl_minigame_main: Node2D = $PearlMinigameMain

func _ready() -> void:
	oyster_chosen = oyster_array[randi_range(0,1)]
	var oyster_chosen_closed = oyster_chosen[0].instantiate()
	oyster_chosen_closed.position = Vector2(576, 220)
	oyster_chosen_closed.z_index = -1
	pearl_minigame_main.add_child(oyster_chosen_closed)	
	Globals.pearl_price = 100

func _physics_process(delta: float) -> void:
	handle_tools(delta)

	if is_pearl_picked:
		handle_pearl_picked()	

func handle_pearl_picked() -> void:
	pearl_instance.position = pliers_collision_2d.global_position

func handle_tools(delta: float) -> void:
	if not is_pliers_locked:
		if is_pliers:
			pliers.position = pliers.position.move_toward(get_global_mouse_position(), 3000 * delta)
			pliers.rotation = -PI*3/2
			target_position_pliers = Vector2(276, 633)
		else:
			pliers.position = pliers.position.move_toward(target_position_pliers, 3000 * delta)
			pliers.rotation = PI*10/11
			target_position_pliers = Vector2(456, 563)

	if is_spoon:
		spoon.position = spoon.position.move_toward(get_global_mouse_position(), 3000 * delta)
		spoon.rotation = -PI/3
		target_position_spoon = Vector2(576, 633)
	else:
		spoon.position = spoon.position.move_toward(target_position_spoon, 3000 * delta)
		spoon.rotation = PI*2/5
		target_position_spoon = Vector2(576, 633)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("clickDir") and not is_pearl_picked:
		is_pliers = false
		is_spoon = false
		
func _on_pliers_button_pressed() -> void:
	is_pliers = true
	is_spoon = false

func _on_spoon_button_pressed() -> void:
	is_pliers = false
	is_spoon = true

func _on_pliers_area_entered(area: Area2D) -> void:
	if area.is_in_group("oyster_closed") and not is_pliers_locked:
		is_pliers_locked = true
		camera_2d.call("ApplyShake", 20)		
		pliers.position = Vector2(850, 300)
		pliers.rotation = PI/3

		var closed_oyster = pearl_minigame_main.get_child(3)
		closed_oyster.visible = false

		var oyster_chosen_open = oyster_chosen[1].instantiate()
		oyster_chosen_open.position = Vector2(576, 220)
		oyster_chosen_open.z_index = -1
		pearl_minigame_main.add_child(oyster_chosen_open)	

		pearl_instance = pearl.instantiate()
		pearl_instance.position = Vector2(576, 260)
		pearl_instance.scale.x = 0.07
		pearl_instance.scale.y = 0.07
		pearl_minigame_main.add_child(pearl_instance)

func _on_spoon_area_entered(area: Area2D) -> void:
	if area.is_in_group("pearl"):
		is_pearl_picked = true

	elif area.is_in_group("oyster_open"):
		if is_pearl_picked:
			Input.warp_mouse(Vector2(756, 220))
			camera_2d.call("ApplyShake", 20)
			Globals.crack_amount += 1

func _on_oyster_area_exited(area: Area2D) -> void:
	if is_pearl_picked and area.is_in_group("pearl"):
		congratulations.visible = true
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_packed(main_scene)
		Globals.gamestate = 2
