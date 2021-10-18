extends KinematicBody2D


export var initial_modulate := Color(1.0, 0.7, 0.7, 1.0)
export var glow_modulate := Color(1.0, 2.0, 2.0, 1.0)
export var transition_duration = 0.5
export var alignment_force := 0.3
export var cohesion_force := 0.5
export var seperation_force := 1.0
export var avoidance_force := 3.0
export var follow_force := 1.0
export var view_radius := 40.0
export var move_speed := 80.0
export var acceleration := 40.0

var neighbors := {}
var velocity := Vector2()
var delta_velocity := Vector2()
var target_node

onready var glow_tween = $GlowTween
onready var sprite = $Sprite
onready var transition_timer = $TransitionTimer
onready var blub = $Blub


func _ready():
	blub.play(randf() * 9.0)
	self.modulate = initial_modulate
	transition_timer.wait_time = transition_duration
	randomize()
	velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * move_speed


func _physics_process(delta):
	delta_velocity = Vector2.ZERO
	delta_velocity += process_alignment() * alignment_force
	delta_velocity += process_cohesion() * cohesion_force
	delta_velocity += process_seperation() * seperation_force
	delta_velocity += process_follow() * follow_force
	delta_velocity *= acceleration
	
	velocity = velocity.linear_interpolate((velocity + delta_velocity).clamped(move_speed), 0.5)
	rotation = velocity.angle()
	
	velocity = move_and_slide(velocity)
#	var collision = move_and_collide(velocity * delta)
#	if collision:
#		velocity = velocity.bounce(collision.normal) * 0.5


func process_neighbors() -> Array:
	for neighbor in neighbors:
		return []
	return []


func process_alignment() -> Vector2:
	var avg_vector := Vector2.ZERO
	if neighbors.empty():
		return avg_vector
	for neighbor in neighbors:
		avg_vector += neighbor.velocity
	return avg_vector.normalized()


func process_cohesion() -> Vector2:
	var avg_position := Vector2.ZERO
	if neighbors.empty():
		return avg_position
	for neighbor in neighbors:
		avg_position += neighbor.position
	return (avg_position - position).normalized()


func process_seperation() -> Vector2:
	var avg_vector := Vector2.ZERO
	if neighbors.empty():
		return avg_vector
	for neighbor in neighbors:
		var diff = position - neighbor.position
		avg_vector += diff.normalized() / diff.length()
	return avg_vector.normalized()


func process_follow() -> Vector2:
	if not target_node:
		return Vector2.ZERO
	return (target_node.global_position - global_position).normalized()


func set_obtained(player, target) -> void:
	if target_node == target:
		return
	transition_timer.start()
	glow_tween.interpolate_property(sprite, "modulate",
			initial_modulate,glow_modulate, transition_duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	glow_tween.start()
	yield(transition_timer, "timeout")
	target_node = target
	player.add_boid(self)


func set_collision(value: bool) -> void:
	if value:
		self.collision_mask = 524288
	else:
		self.collision_mask = 0


func _on_view_body_entered(body):
	if body != self and body.is_in_group("boid") and neighbors.size() < 20:
		neighbors[body] = body


func _on_view_body_exited(body):
	neighbors.erase(body)
