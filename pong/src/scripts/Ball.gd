extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 500.0
export var time_before_respawn = 3.0
onready var player_paddle = "res://pong/src/scenes/PlayerPaddle.tscn/PongPaddle"
var velocity = Vector2()
var random_number_generator = RandomNumberGenerator.new()
var signs = [-1, 1]
var x_spawn_direction = -1
const TOP_OF_ARENA = 8.1
const BOTTOM_OF_ARENA = 600-8.1

# Called when the node enters the scene tree for the first time.
func _ready():
	random_number_generator.randomize()
	toggle_ball_visibility()
	yield(get_tree().create_timer(1.5), "timeout")
	toggle_ball_visibility()
	spawn_ball()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(velocity*delta)
	
	if collision:
		$pong_hit_sound.play()
		if self.position.y <= TOP_OF_ARENA or self.position.y >= BOTTOM_OF_ARENA:
			velocity = velocity.bounce(collision.normal)
		else:
			bounce_off_paddle(collision)
		move_and_collide(velocity*delta)

	if player_scored():
		$pong_score.play()
		increase_player_score()
		toggle_ball_visibility()
		reposition_ball()
		stop_ball()
		yield(get_tree().create_timer(time_before_respawn), "timeout")
		toggle_ball_visibility()
		set_spawn_direction_to_player()
		spawn_ball()
			
	if ai_scored():
		$pong_score.play()
		increase_ai_score()
		toggle_ball_visibility()
		reposition_ball()
		stop_ball()
		yield(get_tree().create_timer(time_before_respawn), "timeout")
		toggle_ball_visibility()
		set_spawn_direction_to_ai()
		spawn_ball()

func spawn_ball():
	var x_direction = x_spawn_direction
	var y_random_direction = signs[random_number_generator.randi() % signs.size()]
	velocity = Vector2(x_direction, y_random_direction)*speed

func reposition_ball():
	self.position.x = 512
#	self.position.y = 300
	self.position.y = random_number_generator.randi_range(0, 600)

func increase_player_score():
	Score.player_score += 1
	
func increase_ai_score():
	Score.ai_score += 1
	
func ai_scored():
	return self.position.x >= 916

func player_scored():
	return self.position.x <= 116
	
func set_spawn_direction_to_player():
	x_spawn_direction = -1

func set_spawn_direction_to_ai():
	x_spawn_direction = 1

func stop_ball():
	velocity = Vector2.ZERO

func toggle_ball_visibility():
	self.get_child(0).visible = not self.get_child(0).visible

func set_bounce_angle(x_bounce, y_bounce, y_factor, y_direction, amount):
	velocity = Vector2(x_bounce, y_direction*abs(y_bounce - (y_factor*(abs(y_bounce)-amount))))

func bounce_off_paddle(collision):
	var paddle_position = collision.get_collider().get("position")
	var collision_position = collision.position
	var ball_paddle_distance = abs(collision_position.y - paddle_position.y)
	var x_bounce = velocity.bounce(collision.normal).x
	var y_bounce = velocity.bounce(collision.normal).y
	var y_factor = -1 if y_bounce < 0 else 1
	var y_direction =  -1 if collision_position.y - paddle_position.y < 0 else 1
	if(ball_paddle_distance <= 5):
		set_bounce_angle(x_bounce, y_bounce, y_factor, y_direction, 0)
	elif(ball_paddle_distance <= 10):
		set_bounce_angle(x_bounce, y_bounce, y_factor, y_direction, 100)
	elif(ball_paddle_distance <= 15):
		set_bounce_angle(x_bounce, y_bounce, y_factor, y_direction, 300)
	elif(ball_paddle_distance <= 20):
		set_bounce_angle(x_bounce, y_bounce, y_factor, y_direction, 500)
	elif(ball_paddle_distance <= 25):
		set_bounce_angle(x_bounce, y_bounce, y_factor, y_direction, 600)
	elif(ball_paddle_distance <= 30):
		set_bounce_angle(x_bounce, y_bounce, y_factor, y_direction, 750)
	else:
		set_bounce_angle(x_bounce, y_bounce, y_factor, y_direction, 900)
