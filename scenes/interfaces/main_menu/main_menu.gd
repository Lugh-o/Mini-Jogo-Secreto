class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton

@onready var main_scene: PackedScene = preload("res://scenes/main_scene/main_scene.tscn")

func _ready() -> void:
	handle_connecting_signals()

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)

func on_exit_pressed() -> void:
	get_tree().quit()

func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
