extends CharacterBody2D

signal hit

const FLAP_VELOCITY = -450.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5 # Increased gravity

@onready var bird_shape = $BirdShape
@onready var animation_player = $AnimationPlayer
@onready var trail = $TrailParticles
@onready var death_particles = $DeathParticles
@onready var collision_shape = $CollisionShape2D

var is_dead = false

func _ready():
	set_physics_process(false)
	trail.emitting = false

func _physics_process(delta):
	velocity.y += gravity * delta
	
	# More responsive rotation
	bird_shape.rotation = lerp_angle(bird_shape.rotation, deg_to_rad(velocity.y / 10.0), delta * 5)

	var collision = move_and_collide(velocity * delta)
	if collision:
		die()
	
	if position.y > get_viewport_rect().size.y + 50:
		die()

func _unhandled_input(event):
	if event.is_action_pressed("flap"):
		velocity.y = FLAP_VELOCITY
		animation_player.play("flap")
		trail.restart()

func start():
	is_dead = false
	set_physics_process(true)
	collision_shape.disabled = false
	trail.emitting = true
	position = Vector2(100, 350)
	velocity = Vector2.ZERO
	bird_shape.rotation = 0
	bird_shape.modulate = Color.WHITE
	animation_player.play("bob")
	show()

func die():
	if is_dead: return
	is_dead = true
	
	death_particles.emitting = true
	set_physics_process(false)
	collision_shape.disabled = true
	trail.emitting = false
	animation_player.stop()
	emit_signal("hit")
	
	hide()