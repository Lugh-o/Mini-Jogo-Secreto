class_name PearlShop
extends Node2D

var dialogues = []
var fitDialogue = []
var is_trustworthy = true

@onready var dialogue_box: ColorRect = $DialogueBox
@onready var dialogue_text: RichTextLabel = $DialogueBox/RichTextLabel

@onready var question_1_text: RichTextLabel = $Questions/QuestionButton1/RichTextLabel
@onready var question_2_text: RichTextLabel = $Questions/QuestionButton2/RichTextLabel
@onready var question_3_text: RichTextLabel = $Questions/QuestionButton3/RichTextLabel
@onready var questions: Control = $Questions
@onready var trust: Control = $Trust

func _ready() -> void:
	dialogue_box.visible = false
	trust.visible = false 

	var dialogueJson = FileAccess.open("res://scenes/pearl_shop/dialog/dialog.json", FileAccess.READ)
	
	if dialogueJson:
		dialogues = JSON.parse_string(dialogueJson.get_as_text())
		dialogueJson.close()
	start_dialogue_by_day(1)

func start_dialogue_by_day(day_number: int) -> void:
	fitDialogue = []
	var theme

	match day_number:
		1: theme = "oceanCurrents"
		2: theme = "rareResources"
		3: theme = "rumorsAndPlaces"
	fitDialogue = []
	for item in dialogues:
		if item["theme"] == theme:
			fitDialogue.push_back(item)

	question_1_text.bbcode_text = fitDialogue[0]["question"]
	question_2_text.bbcode_text = fitDialogue[1]["question"]
	question_3_text.bbcode_text = fitDialogue[2]["question"]

func _on_button_1_down() -> void:
	dialogue_box.visible = true
	questions.visible = false
	trust.visible = true
	dialogue_text.bbcode_text = fitDialogue[0]["answer"]["trustworthy" if is_trustworthy else "questionable"]

func _on_button_2_down() -> void:
	dialogue_box.visible = true
	questions.visible = false
	trust.visible = true
	dialogue_text.bbcode_text = fitDialogue[1]["answer"]["trustworthy" if is_trustworthy else "questionable"]

func _on_button_3_down() -> void:
	dialogue_box.visible = true
	questions.visible = false
	trust.visible = true
	dialogue_text.bbcode_text = fitDialogue[2]["answer"]["trustworthy" if is_trustworthy else "questionable"]

func _on_yes_button_down() -> void:
	print("yes")

func _on_no_button_down() -> void:
	print("no")