extends CharacterBody2D

signal hit

const FLAP_VELOCITY = -350.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var trail = $TrailParticles
@onready var collision_shape = $CollisionShape2D

func _ready():
	set_physics_process(false)
	trail.emitting = false

func _physics_process(delta):
	velocity.y += gravity * delta
	
	sprite.rotation = lerp_angle(sprite.rotation, deg_to_rad(velocity.y / 20.0), delta * 5)

	var collision = move_and_collide(velocity * delta)
	if collision:
		die()
	
	# Fallback for falling out of the world
	if position.y > get_viewport_rect().size.y + 50:
		die()

func _unhandled_input(event):
	if event.is_action_pressed("flap"):
		velocity.y = FLAP_VELOCITY
		animation_player.play("flap")
		trail.restart()

func start():
	set_physics_process(true)
	collision_shape.disabled = false
	trail.emitting = true
	position = Vector2(100, 350)
	velocity = Vector2.ZERO
	sprite.rotation = 0
	show()

func die():
	if not is_physics_processing(): return # Prevent dying multiple times
	set_physics_process(false)
	collision_shape.disabled = true
	trail.emitting = false
	emit_signal("hit")
	
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.1)
	await tween.finished
	hide()