class_name PearlShop
extends Node2D

var current_dialogue_line = 0
var cypher_dialogues = []
var cypher_dialogues_filtered = []
var current_custumer_index = 0
var current_custumer_instance
var trustworthy_custumers = [true, false, true, true, false]
var day = 1

@onready var main_scene: PackedScene = preload("res://scenes/main_scene/main_scene.tscn")

@onready var pearl_shop: PearlShop = $"."
@onready var dialogue_box: ColorRect = $DialogueBox
@onready var dialogue_text: RichTextLabel = $DialogueBox/RichTextLabel
@onready var custumers: Node2D = $Custumers

@onready var question_1_text: RichTextLabel = $Questions/QuestionButton1/RichTextLabel
@onready var question_2_text: RichTextLabel = $Questions/QuestionButton2/RichTextLabel
@onready var question_3_text: RichTextLabel = $Questions/QuestionButton3/RichTextLabel
@onready var questions: Control = $Questions
@onready var trust: Control = $Trust
@onready var title_label: RichTextLabel = $Title/TitleLabel

func _ready() -> void:
	var dialogueJson = FileAccess.open("res://scenes/pearl_shop/dialog/cypher_dialog.json", FileAccess.READ)
	
	if dialogueJson:
		cypher_dialogues = JSON.parse_string(dialogueJson.get_as_text())
		dialogueJson.close()

	start_dialogue_by_day(day)
	send_next_custumer() 

func start_dialogue_by_day(day_number: int) -> void:
	cypher_dialogues_filtered = []
	var theme

	match day_number:
		1: 
			theme = "oceanCurrents"
			title_label.bbcode_text = "Day 1: Trustworthy clients will show familiarity with navigation and marine flows"
		2: 
			theme = "rareResources"
			title_label.bbcode_text = "Day 2: Trustworthy clients will demonstrate knowledge about valuable and hard-to-obtain items."
		3: 
			theme = "rumorsAndPlaces"
			title_label.bbcode_text = "Day 3: Trustworthy clients will remain calm and informed about mysterious events and locations."

	for item in cypher_dialogues:
		if item["theme"] == theme:
			cypher_dialogues_filtered.push_back(item)

	question_1_text.bbcode_text = cypher_dialogues_filtered[0]["question"]
	question_2_text.bbcode_text = cypher_dialogues_filtered[1]["question"]
	question_3_text.bbcode_text = cypher_dialogues_filtered[2]["question"]

func _on_button_1_down() -> void:
	current_dialogue_line = 0
	dialogue_box.visible = true
	questions.visible = false
	trust.visible = true
	dialogue_text.bbcode_text = cypher_dialogues_filtered[current_dialogue_line]["answer"]["trustworthy" if trustworthy_custumers[current_custumer_index] else "untrustworthy"]

func _on_button_2_down() -> void:
	current_dialogue_line = 1
	dialogue_box.visible = true
	questions.visible = false
	trust.visible = true
	dialogue_text.bbcode_text = cypher_dialogues_filtered[current_dialogue_line]["answer"]["trustworthy" if trustworthy_custumers[current_custumer_index] else "untrustworthy"]

func _on_button_3_down() -> void:
	current_dialogue_line = 2
	dialogue_box.visible = true
	questions.visible = false
	trust.visible = true
	dialogue_text.bbcode_text = cypher_dialogues_filtered[current_dialogue_line]["answer"]["trustworthy" if trustworthy_custumers[current_custumer_index] else "untrustworthy"]

func _on_yes_button_down() -> void:
	if not trustworthy_custumers[current_custumer_index]: 
		handle_game_over()

	dialogue_text.bbcode_text = cypher_dialogues_filtered[current_dialogue_line]["reply"]["trustworthy" if trustworthy_custumers[current_custumer_index] else "untrustworthy"]
	trust.visible = false
	dismiss_customer()

func _on_no_button_down() -> void:
	if trustworthy_custumers[current_custumer_index]: 
		handle_game_over()

	dialogue_text.bbcode_text = cypher_dialogues_filtered[current_dialogue_line]["reply"]["trustworthy" if trustworthy_custumers[current_custumer_index] else "untrustworthy"]
	trust.visible = false
	dismiss_customer()
	
func send_next_custumer() -> void:
	current_custumer_instance = custumers.get_child(current_custumer_index)
	if current_custumer_index == 5:
		current_custumer_index = 0
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_packed(main_scene)
	else:
		current_custumer_instance.position = Vector2(-200, 350)

		var tween = create_tween()
		tween.tween_property(current_custumer_instance, "position", Vector2(544, 350), 1)
		await tween.finished

		dialogue_box.visible = false
		trust.visible = false 
		questions.visible = true

func dismiss_customer() -> void:
	var tween = create_tween()
	tween.tween_property(current_custumer_instance, "position", Vector2(1552, 350), 1)
	await tween.finished
	current_custumer_index += 1
	send_next_custumer()

func handle_game_over() -> void:
	print("game over")
	get_tree().quit()
