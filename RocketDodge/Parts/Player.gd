extends RigidBody3D


@export_range(750,3000) var thrust: float = 1000.0
@export_range(50,500) var torque_thrust: float = 100.0

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var right_booster_particles: GPUParticles3D = $RightBoosterParticles
@onready var left_booster_particles: GPUParticles3D = $LeftBoosterParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles
@onready var timer: Label3D = $"../Camera3D/Timer"

var is_transitioning: bool = false

func _process(delta: float) -> void:
	if get_tree().current_scene.name != "MainMenu":
		GameManager.time_taken += delta
		timer.text = "%.1f" % snappedf(GameManager.time_taken, 0.1)

	print(GameManager.time_taken)
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		booster_particles.emitting = true

		if rocket_audio.playing == false:
			rocket_audio.play()
	else:
		booster_particles.emitting = false
		rocket_audio.stop()
		
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0,0,torque_thrust * delta))
		right_booster_particles.emitting = true
	else:
		right_booster_particles.emitting = false


	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0,0,-torque_thrust * delta))
		left_booster_particles.emitting = true
	else:
		left_booster_particles.emitting = false		

func _on_body_entered(body: Node) -> void:
	if is_transitioning == false:
		if "Goal" in body.get_groups():
			complete_level(body.file_path)

		if "Hazard" in body.get_groups():
			crash_sequence()
		
func crash_sequence() -> void:
	explosion_particles.emitting = true
	explosion_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)

		
func complete_level(next_level_file: String) -> void:
	success_particles.emitting = true
	success_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))
