extends KinematicBody2D

var velocity = Vector2.ZERO
var fast_fell = false
	
func _physics_process(delta: float) -> void:
	
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input.x==0:
		apply_friction()
	else:
		apply_acceleration(input.x)

	#player jump
	if is_on_floor(): 
		fast_fell = false
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -130
			
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < -70: 
			velocity.y = -70
		
		if velocity.y > 0 and not fast_fell:
			velocity.y += 48
			fast_fell = true
	
	#apply movement to the player
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_gravity():
	# gravity
	velocity.y += 4

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, 20)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, 50 * amount, 20)
