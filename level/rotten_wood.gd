extends StaticBody2D


signal thud

export var boid_needed := 1
export var wood_fragment_1: PackedScene
export var wood_fragment_2: PackedScene

var player
var destroyed := false

onready var hit_box = $HitBox
onready var boid_collision = $BoidCollision
onready var obstacle_label = $ObstacleLabel
onready var thud_sound = $ThudSound
onready var destroy_sound = $DestroySound


func _ready():
	set_physics_process(false)


func _physics_process(delta):
	if destroyed:
		return
	if player.is_attacking():
		if player.get_boid_count() >= boid_needed:
			destroy()
		else:
			emit_signal("thud")
			obstacle_label.alert()
			if not thud_sound.playing:
				thud_sound.play()


func destroy() -> void:
	destroyed = true
	destroy_sound.play()
	boid_collision.disable_collision()
	yield(get_tree().create_timer(0.1), "timeout")
	self.visible = false
	for i in range(5):
		var frag_1 = wood_fragment_1.instance()
		var frag_2 = wood_fragment_2.instance()
		frag_1.direction = randf() * 2 * PI
		frag_2.direction = randf() * 2 * PI
		frag_1.position = position + Vector2(rand_range(-1,1)*100, rand_range(-1,1)*100)
		frag_2.position = position + Vector2(rand_range(-1,1)*100, rand_range(-1,1)*100)
		get_parent().add_child(frag_1)
		get_parent().add_child(frag_2)
	yield(destroy_sound, "finished")
	self.queue_free()


func _on_hit_box_body_entered(body):
	if body.is_in_group("player"):
		player = body
		set_physics_process(true)


func _on_hit_box_body_exited(body):
	if body.is_in_group("player"):
		set_physics_process(false)
