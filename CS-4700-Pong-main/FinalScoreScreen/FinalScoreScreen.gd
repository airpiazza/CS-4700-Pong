extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var score_label = get_node("Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	$game_over_sound.play()
	score_label.text = score_label.text % ["You" if Score.player_score > Score.ai_score else "AI", Score.player_score, Score.ai_score]
	Score.player_score = 0
	Score.ai_score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
