extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 1000.0
var velocity = Vector2()
var random_number_generator = RandomNumberGenerator.new()
var signs = [-1, 1]
var x_spawn_direction = -1

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
		velocity = velocity.bounce(collision.normal)
		move_and_collide(velocity*delta)

	if player_scored():
		$pong_score.play()
		increase_player_score()
		toggle_ball_visibility()
		reposition_ball()
		stop_ball()
		yield(get_tree().create_timer(2.0), "timeout")
		toggle_ball_visibility()
		set_spawn_direction_to_player()
		spawn_ball()
			
	if ai_scored():
		$pong_score.play()
		increase_ai_score()
		toggle_ball_visibility()
		reposition_ball()
		stop_ball()
		yield(get_tree().create_timer(2.0), "timeout")
		toggle_ball_visibility()
		set_spawn_direction_to_ai()
		spawn_ball()

func spawn_ball():
	var x_direction = x_spawn_direction
	var y_random_direction = signs[random_number_generator.randi() % signs.size()]
	velocity = Vector2(x_direction, y_random_direction)*speed

func reposition_ball():
	self.position.x = 512
	self.position.y = 300
#	self.position.y = random_number_generator.randi_range(0, 600)

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
