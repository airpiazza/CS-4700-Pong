extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var ai_score_node = get_node("HockeyAIScore")
onready var player_score_node = get_node("HockeyPlayerScore")

# Called when the node enters the scene tree for the first time.
func _ready():
	ai_score_node.text = str(Score.ai_score)
	player_score_node.text = str(Score.player_score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ai_score_node.text = str(Score.ai_score)
	player_score_node.text = str(Score.player_score)
