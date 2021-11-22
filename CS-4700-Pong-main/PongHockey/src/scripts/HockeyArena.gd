extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var end_screen = "res://FinalScoreScreen/FinalScoreScreen.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Score.player_score >= 11 or Score.ai_score >= 11:
		get_tree().change_scene(end_screen)
