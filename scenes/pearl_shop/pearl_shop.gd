class_name PearlShop
extends Node2D

var current_dialogue_line = 0
var cypher_dialogues = []
var cypher_dialogues_filtered = []
var is_trustworthy = false
var current_custumer
var day = 1

@onready var pearl_shop: PearlShop = $"."
@onready var dialogue_box: ColorRect = $DialogueBox
@onready var dialogue_text: RichTextLabel = $DialogueBox/RichTextLabel

@onready var question_1_text: RichTextLabel = $Questions/QuestionButton1/RichTextLabel
@onready var question_2_text: RichTextLabel = $Questions/QuestionButton2/RichTextLabel
@onready var question_3_text: RichTextLabel = $Questions/QuestionButton3/RichTextLabel
@onready var questions: Control = $Questions
@onready var trust: Control = $Trust
@onready var title_label: RichTextLabel = $Title/TitleLabel
@onready var template_custumer = preload("res://scenes/pearl_shop/custumers/template_custumer.tscn")

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
	dialogue_text.bbcode_text = cypher_dialogues_filtered[current_dialogue_line]["answer"]["trustworthy" if is_trustworthy else "untrustworthy"]

func _on_button_2_down() -> void:
	current_dialogue_line = 1
	dialogue_box.visible = true
	questions.visible = false
	trust.visible = true
	dialogue_text.bbcode_text = cypher_dialogues_filtered[current_dialogue_line]["answer"]["trustworthy" if is_trustworthy else "untrustworthy"]

func _on_button_3_down() -> void:
	current_dialogue_line = 2
	dialogue_box.visible = true
	questions.visible = false
	trust.visible = true
	dialogue_text.bbcode_text = cypher_dialogues_filtered[current_dialogue_line]["answer"]["trustworthy" if is_trustworthy else "untrustworthy"]

func _on_yes_button_down() -> void:
	if not is_trustworthy: handle_game_over()

	dialogue_text.bbcode_text = cypher_dialogues_filtered[current_dialogue_line]["reply"]["trustworthy" if is_trustworthy else "untrustworthy"]
	trust.visible = false
	dismiss_customer()

func _on_no_button_down() -> void:
	if is_trustworthy: handle_game_over()

	dialogue_text.bbcode_text = cypher_dialogues_filtered[current_dialogue_line]["reply"]["trustworthy" if is_trustworthy else "untrustworthy"]
	trust.visible = false
	dismiss_customer()
	
func send_next_custumer() -> void:
	pearl_shop.add_child(template_custumer.instantiate())
	current_custumer = pearl_shop.get_child(5)
	current_custumer.position = Vector2(-200, 250)

	var tween = create_tween()
	tween.tween_property(current_custumer, "position", Vector2(544, 250), 1)
	await tween.finished
	dialogue_box.visible = false
	trust.visible = false 
	questions.visible = true

func dismiss_customer() -> void:
	var tween = create_tween()
	tween.tween_property(current_custumer, "position", Vector2(1352, 250), 1)
	await tween.finished
	pearl_shop.remove_child(current_custumer)
	send_next_custumer()

func handle_game_over() -> void:
	print("game over")
	get_tree().quit()
