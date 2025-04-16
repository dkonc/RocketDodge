extends RigidBody3D

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		apply_central_force(basis.y * delta * 1000)
		
	if Input.is_action_pressed("ui_left"):
		apply_torque(Vector3(0,0,100 * delta))

	if Input.is_action_pressed("ui_right"):
		apply_torque(Vector3(0,0,-100 * delta))
