extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 1000.0
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2.ZERO
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = Vector2.ZERO
	
	var ball = get_parent().get_node("Puck")
	
	if ball.velocity != Vector2.ZERO:
		if ball.position.y < self.position.y:
			velocity += Vector2.UP * (speed/3)
		elif ball.position.y > self.position.y:
			velocity += Vector2.DOWN * (speed/3)
		if ball.position.x < 300:
			velocity += Vector2.LEFT * (speed/2)
		elif ball.position.x > 750:
			velocity += Vector2.RIGHT * (speed/5)
		if self.position.x > 475:
			self.position.x = 475
		if self.position.x < 50:
			self.position.x = 50
	
	move_and_collide(velocity * delta)

		

