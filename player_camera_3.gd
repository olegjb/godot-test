extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 6.0

@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0
@export var rotation_speed := 12.0

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Camera3D = %Camera3D
@onready var _skin: MeshInstance3D = %mesh_skin

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event:InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		# note had to update to event.relative
		_camera_input_direction = event.relative * mouse_sensitivity


func _physics_process(delta: float) -> void:
	_camera_pivot.rotation.x += _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta

	_camera_input_direction = Vector2.ZERO

	#var forward_dir := -_camera.basis.z
	#var right := -_camera.basis.x
	
	
	#var raw_input := Input.get_vector("left", "right", "forward", "back")
	
	var input_vector := Vector2 (
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("forward") - Input.get_action_strength("back")
	)
	
	
	input_vector = input_vector.normalized()
		
	var camera_basis = _camera.global_transform.basis
		
	
	var forward = -camera_basis.z
	var right = camera_basis.x
	forward.y = 0
	forward = forward.normalized()
		
	
	right.y = 0
	right = right.normalized()
		
	# relative to camera
	var move_direction = (input_vector.x * right + input_vector.y * forward.normalized())
	
	move_direction = move_direction.normalized()
	
	if input_vector != Vector2.ZERO:

		velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	
	else:
		velocity.x = 0
		velocity.z = 0
	
	# var move_direction := forward_dir * raw_input.y + right * raw_input.x
	
	# hm
	#var move_direction = forward_dir * raw_input.y + right * raw_input.x
	#move_direction.y = 0.0
	
	# try relate to camera
	#var move_direction = raw_input.x * right.normalized() + raw_input.y * forward_dir.normalized()
	
		# counteract camera angle
	#move_direction.y = 0.0
	
	
	move_and_slide()
	
	#char stays at last dir if no input
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
		
	# signed is + - val
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y,target_angle, rotation_speed * delta ) 



