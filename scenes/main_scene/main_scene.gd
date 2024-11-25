extends Node2D

@onready var one_to_two_button: Button = $"Control/1to2Button"
@onready var two_to_one_button: Button = $"Control/2to1Button"
@onready var one_to_three_button: Button = $"Control/1to3Button"
@onready var three_to_one_button: Button = $"Control/3to1Button"
@onready var camera_2d: Camera2D = $Camera2D

@export var pearl_amount = 0
@export var tape_amount = 0 
@export var reputation = 0

func one_to_two_button_pressed() -> void:
	camera_2d.position.x = 1728

func two_to_one_button_pressed() -> void:
	camera_2d.position.x = 576

func one_to_three_button_pressed() -> void:
	camera_2d.position.x = -576

func three_to_one_button_pressed() -> void:
	camera_2d.position.x = 576
