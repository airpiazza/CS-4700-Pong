tool
extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(String, FILE) var target_scene = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NextSceneButton_button_up():
	get_tree().change_scene(target_scene)

func _get_configuration_warning():
	return "you must set a target scene path" if target_scene == "" else ""
