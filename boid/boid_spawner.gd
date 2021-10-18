extends Node2D


export var boid_scene: PackedScene
export var spawn_radius := 100.0
export var boid_count := 20
export var can_be_obtained := true

var boids := []


func _ready():
	for i in range(boid_count):
		randomize()
		var boid = boid_scene.instance()
		boid.target_node = self
		boids.append(boid)
		var offset = Vector2.LEFT.rotated(2 * PI * randf()) * randf() * spawn_radius
		boid.position = self.position + offset
#		boid.set_collision(can_be_obtained)
		get_parent().call_deferred("add_child", boid)


func set_can_be_obtained(value: bool) -> void:
	can_be_obtained = value
	for boid in boids:
		boid.set_collision(can_be_obtained)
