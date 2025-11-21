extends CharacterBody2D

signal hit

const FLAP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var active = false

func _physics_process(delta):
	if not active:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle flap.
	if Input.is_action_just_pressed("flap"):
		flap()

	move_and_slide()
	
	if get_slide_collision_count() > 0:
		die()

func start():
	set_physics_process(true)
	position = Vector2(100, 350)
	velocity = Vector2.ZERO
	active = false
	show()

func flap():
	velocity.y = FLAP_VELOCITY

func set_active(is_active):
	active = is_active
	if active:
		# Give the first flap when activated
		flap()

func die():
	hit.emit()
	hide()
	set_physics_process(false)