extends CharacterBody3D

const SPEED  = 5.0
const ACCELERATION = 2.0
const ROTATION_SPEED = 2.0
const JUMP_VELOCITY = 5.0

#GRAvity

@export var gravity = -10.0

func _physics_process(delta):
	

	
		#if nothihng happens reset to 0
		# var input_movement_vector = Vector3.ZERO
		
		if Input.is_action_just_pressed('jump') and is_on_floor():
				velocity.y = JUMP_VELOCITY
			
	
		#player input

		# input_movement_vector.x = Input.get_action_strength("right") - Input.get_action_strength('left')
			

		# input_movement_vector.z = Input.get_action_strength("back") - Input.get_action_strength('forward')
		
		var input_dir = Input.get_vector("left", "right", "forward", "back")
		var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		print(move_dir)
			

		# input_movement_vector.z = Input.get_action_strength("back") - Input.get_action_strength('forward')


		#print(input_movement_vector)
		if move_dir:
			velocity.x = move_dir.x * SPEED
			velocity.z = move_dir.z * SPEED
			

			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
			
		velocity.y += gravity * delta

		# face direcrtion
		var target_rotation = atan2(-move_dir.x, -move_dir.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, ROTATION_SPEED * delta)

		
		move_and_slide()
	# input_movement_vector = input_movement_vector.normalized()




	# move action
	#velocity.y += gravity * delta
	#velocity.x = input_movement_vector.x + SPEED
	#velocity.z = input_movement_vector.z + SPEED
	
	
	
	
	# face direcrtion
	#if input_movement_vector != Vector3.ZERO:
	#	var target_rotation = atan2(-input_movement_vector.x, -input_movement_vector.z)
	#	rotation.y = lerp_angle(rotation.y, target_rotation, ROTATION_SPEED * delta)
	
		
	# move_and_slide()	
	
	
