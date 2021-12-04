extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 1000.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		velocity += Vector2.UP * speed
	if Input.is_action_pressed("ui_down"):
		velocity += Vector2.DOWN * speed
	if Input.is_key_pressed(KEY_W):
		velocity += Vector2.UP * speed
	if Input.is_key_pressed(KEY_S):
		velocity += Vector2.DOWN * speed
		
	move_and_collide(velocity*delta)
