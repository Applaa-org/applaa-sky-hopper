extends CharacterBody2D

signal hit

const FLAP_VELOCITY = -350.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var trail = $TrailParticles

func _ready():
	set_physics_process(false)
	trail.emitting = false

func _physics_process(delta):
	velocity.y += gravity * delta
	
	# Rotate player based on velocity
	sprite.rotation = lerp_angle(sprite.rotation, deg_to_rad(velocity.y / 20.0), delta * 5)

	var collision = move_and_collide(velocity * delta)
	if collision:
		die()
	
	if position.y > get_viewport_rect().size.y:
		die()

func _unhandled_input(event):
	if event.is_action_pressed("flap"):
		velocity.y = FLAP_VELOCITY
		animation_player.play("flap")
		trail.restart()

func start():
	set_physics_process(true)
	trail.emitting = true
	position = Vector2(100, 350)
	velocity = Vector2.ZERO
	sprite.rotation = 0

func die():
	set_physics_process(false)
	trail.emitting = false
	emit_signal("hit")
	# Simple death animation placeholder
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 0.5, 0.5, 0.5), 0.1)
	tween.tween_property(sprite, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(sprite, "scale", Vector2(0, 0), 0.2).set_delay(0.1)