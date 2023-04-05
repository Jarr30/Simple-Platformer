extends KinematicBody2D

export(int) var JUMP_FORCE = -130
export(int) var JUMP_RELEASE_FORCE = -70
export(int) var MAX_SPEED =  50
export(int) var ACCELERATION = 10
export(int) var FRICTION = 10
export(int) var GRAVITY = 4
export(int) var ADDITIONAL_FALL_GRAVITY = 4

var velocity = Vector2.ZERO
	
func _physics_process(delta: float) -> void:
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input.x==0:
		apply_friction()
		$AnimatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x)
		$AnimatedSprite.animation = "Run"
		if input.x > 0:
			$AnimatedSprite.flip_h = true
		elif input.x < 0:
			$AnimatedSprite.flip_h = false
	#player jump
	if is_on_floor(): 
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_FORCE
	else:
		$AnimatedSprite.animation = "Jump"
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE: 
			velocity.y = JUMP_RELEASE_FORCE
		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
			
	var was_in_air = not is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		$AnimatedSprite.animation = "Run"
		$AnimatedSprite.frame = 0
		

func apply_gravity():
	# gravity
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 300)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)
