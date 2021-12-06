extends Node2D


# Declare member variables here. Examples:
var rng = RandomNumberGenerator.new()
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var t = rng.randi_range(1,3)
	if(t == 1):
		$Song1.play()
	if(t == 2):
		$Song2.play()
	if(t == 3):
		$Song3.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
		
func _on_Song1_finished():
	$Song2.play()
	
func _on_Song2_finished():
	$Song3.play()

func _on_Song3_finished():
	$Song1.play()

