extends KinematicBody2D


signal call
signal attack
signal attack_finished

const TARGET_DISTANCE := 300.0

export var boid_scene: PackedScene

var move_speed := 400.0
var velocity := Vector2()
var acceleration := 0.3
var camera_pos := Vector2()
var boids := []
var delta_pos := Vector2()
var boid_move_speed: float
var attacking := false
var start := 0

onready var boid_center = $BoidCenter
onready var call_area = $BoidCenter/CallArea
onready var light = $Light2D
onready var call_timer = $CallTimer
onready var call_buffer = $CallBuffer
onready var target = $Target
onready var attack_timer = $AttackTimer
onready var attack_cd_timer = $AttackCooldownTimer
onready var animation_player = $AnimationPlayer
onready var particles = $BoidCenter/CPUParticles2D
onready var particles_one_shot = $BoidCenter/CPUParticles2D2
onready var call_sound = $CallSound
onready var attack_sound = $AttackSound


func _ready():
	var boid = boid_scene.instance()
	boid_move_speed = boid.move_speed
	boid.position = self.position
	get_parent().call_deferred("add_child", boid)
	boid.call_deferred("set_obtained", self, target)


func _input(event):
	if start == 0:
		return
	if Input.is_action_just_pressed("call") and call_timer.time_left == 0:
		call_sound.play()
		call_timer.start()
		call_buffer.start()
		emit_signal("call")
		animation_player.play("call")
		var bodies = call_area.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("boid"):
				body.set_obtained(self, target)
		var areas = call_area.get_overlapping_areas()
		for area in areas:
			if area.is_in_group("flower"):
				area.bloom()
			if area.is_in_group("door"):
				area.activate(boids.size())
	if Input.is_action_just_released("attack") and attack_cd_timer.time_left == 0:
		attack_sound.play()
		attack_cd_timer.start()
		attack_timer.start()
		emit_signal("attack")
		target.position = delta_pos.normalized() * TARGET_DISTANCE
		for boid in boids:
			var temp = target.global_position - boid.global_position
			boid.velocity = temp.normalized() * boid_move_speed * 7.0
			boid.move_speed = boid_move_speed * 7.0
		attacking = true
		velocity = delta_pos.normalized() * boid_move_speed * 6.0
		particles_one_shot.emitting = true


func _physics_process(delta):
	update_boid_center()
	if not attacking:
		delta_pos = get_global_mouse_position() - self.global_position
		velocity = velocity.linear_interpolate(delta_pos.clamped(move_speed), acceleration)
	camera_pos = self.global_position - delta_pos/4.0
	velocity = move_and_slide(start * velocity)


func update_boid_center() -> void:
	if not boids:
		return
	var avg_position := Vector2()
	for boid in boids:
		avg_position += boid.global_position
	avg_position /= boids.size()
	boid_center.position = boid_center.position.linear_interpolate(avg_position - self.global_position, acceleration/3.0)


func add_boid(boid) -> void:
	boids.append(boid)
	var n_boids = boids.size()
	call_area.scale = Vector2.ONE * pow(n_boids/1.7, 0.3)
	light.target_energy = 1.0 + sqrt(n_boids) / 10
	light.target_scale = pow(n_boids/1.7, 0.3)
	particles.amount = n_boids
	particles.emission_sphere_radius = 4.0 * n_boids
	particles_one_shot.amount = 3 * n_boids
	particles_one_shot.emission_sphere_radius = 4.0 * n_boids
	call_sound.volume_db = -10.0 + 10.0 * n_boids/50.0
	attack_sound.volume_db = -5.0 + 10.0 * n_boids/50.0
	Sound.set_chord_level(n_boids)
	Sound.set_ambience_level(n_boids)


func _on_attack_timer_timeout():
	emit_signal("attack_finished")
	target.position = Vector2.ZERO
	for boid in boids:
		boid.velocity = boid.velocity.linear_interpolate(Vector2.ZERO, 0.8)
		boid.move_speed = boid_move_speed * 2.0
	attacking = false


func _on_attack_cooldown_timer_timeout():
	for boid in boids:
		boid.move_speed = boid_move_speed


func is_attacking() -> bool:
	return attacking


func get_boid_count() -> int:
	return boids.size()


func _on_call_area_body_entered(body):
	if call_buffer.time_left == 0:
		return
	if not body.is_in_group("boid"):
		return
	body.set_obtained(self, target)


func _on_call_area_area_entered(area):
	if call_buffer.time_left == 0:
		return
	if area.is_in_group("flower"):
		area.bloom()
	if area.is_in_group("door"):
		area.activate(boids.size())
