extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 800.0
var velocity = Vector2()
var random_number_generator = RandomNumberGenerator.new()
var signs = [-1, 1]
export var carryover = 0.75
var last_collision_time = 0
export var wait_factor = 6
export var max_speed = 2000.0
export var min_speed = 300.0
var last_collider = null
const AI_DIRECTION = -1
const PLAYER_DIRECTION = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	random_number_generator.randomize()
	toggle_puck_visibility(self)
	yield(get_tree().create_timer(1.5), "timeout")
	toggle_puck_visibility(self)
	spawn_puck(AI_DIRECTION)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var ai_mallet = get_parent().get_node("AIMallet")
	var collision = move_and_collide(velocity*delta)
	
	if last_collision_time >= wait_factor*delta and last_collider != null:
		last_collider.disabled = false
	
	if collision and (last_collision_time >= wait_factor*delta) and velocity != Vector2.ZERO:
		velocity = velocity.bounce(collision.normal)
		velocity += carryover*collision.collider_velocity #add mallet speed to puck\
		particles_track()
		emitt_particles()
		$hit_sound.play()
		last_collider = collision.get_collider().get_child(1)
		if collision.get_collider().name != "TileMap":
			last_collider.disabled = true
		last_collision_time = 0
		
	if player_scored():
		ai_mallet.position.x = 167
		ai_mallet.position.y = 301
		$goal_sound.play()
		increase_player_score()
		reposition_puck()
		stop_puck()
		toggle_puck_visibility(self)
		yield(get_tree().create_timer(2.0), "timeout")
		toggle_puck_visibility(self)
		spawn_puck(AI_DIRECTION)
		clear_particles()
			
	if ai_scored():
		ai_mallet.position.x = 167
		ai_mallet.position.y = 301
		$goal_sound.play()
		increase_ai_score()
		reposition_puck()
		stop_puck()
		toggle_puck_visibility(self)
		yield(get_tree().create_timer(2.0), "timeout")
		toggle_puck_visibility(self)
		spawn_puck(PLAYER_DIRECTION)
		clear_particles()
	
	last_collision_time += delta
	degrade_velocity() #puck velocity degredation
	velocity.x = min(velocity.x,max_speed) #maximum puck velocity
	velocity.y = min(velocity.y,max_speed) #maximum puck velocity
	if abs(velocity.x) < min_speed and velocity != Vector2.ZERO:
		if velocity.x < 0:
			velocity.x = -min_speed
		else:
			velocity.x = min_speed
#	print(velocity.x)
	

func spawn_puck(direction):
	var y_random_direction = signs[random_number_generator.randi() % signs.size()]*speed
	velocity = Vector2(direction,y_random_direction)

func reposition_puck():
	self.position.x = 512
#	self.position.x = 700
	self.position.y = 300
#	self.position.y = random_number_generator.randi_range(0, 600)

func increase_player_score():
	Score.player_score += 1
	
func increase_ai_score():
	Score.ai_score += 1
	
func ai_scored():
	return self.position.x >= 1024

func player_scored():
	return self.position.x <= 0

func stop_puck():
	velocity = Vector2.ZERO
	
func toggle_puck_visibility(puck):
	puck.visible = !puck.visible
#
func degrade_velocity():
	velocity = velocity.linear_interpolate(Vector2.ZERO,.0005)

#emitts the particles and restarts so it can play multiple times
func emitt_particles():
	$Particles.set_emitting(true)
	$Particles.restart()

#tracks the direction of the punk to emitt particles behind it
func particles_track():
	$Particles.set_rotation(velocity.angle() + PI)
	$Particles.initial_velocity = velocity.length()

#clears all the puck particles on screen
func clear_particles():
	$Particles.set_amount(0)
