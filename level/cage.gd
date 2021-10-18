extends StaticBody2D


signal thud

export var boid_needed := 1
export var fragment_1: PackedScene
export var fragment_2: PackedScene
export var wood_fragment: PackedScene

var player
var destroyed := false

onready var spawner = get_parent()
onready var hit_box = $HitBox
onready var boid_collision = $BoidCollision
onready var obstacle_label = $ObstacleLabel
onready var thud_sound = $ThudSound
onready var destroy_sound = $DestroySound


func _ready():
	spawner.call_deferred("set_can_be_obtained", false)
	set_physics_process(false)


func _physics_process(delta):
	if destroyed:
		return
	if player.is_attacking():
		if player.get_boid_count() >= boid_needed:
			destroy()
		else:
			obstacle_label.alert()
			emit_signal("thud")
			if not thud_sound.playing:
				thud_sound.play()


func destroy() -> void:
	destroyed = true
	destroy_sound.play()
	boid_collision.disable_collision()
	spawner.set_can_be_obtained(true)
	yield(get_tree().create_timer(0.1), "timeout")
	self.visible = false
	var frag_1 = fragment_1.instance()
	var frag_2 = fragment_2.instance()
	frag_1.direction = randf() * 2 * PI
	frag_2.direction = randf() * 2 * PI
	frag_1.position = Vector2(rand_range(-1,1)*100, rand_range(-1,1)*100)
	frag_2.position = Vector2(rand_range(-1,1)*100, rand_range(-1,1)*100)
	spawner.add_child(frag_1)
	spawner.add_child(frag_2)
	for i in range(4):
		var wood_frag = wood_fragment.instance()
		wood_frag.direction = randf() * 2 * PI
		wood_frag.velocity *= 1 + randf()
		wood_frag.position = Vector2(rand_range(-1,1)*100, rand_range(-1,1)*100)
		spawner.add_child(wood_frag)
	yield(destroy_sound, "finished")
	self.queue_free()


func _on_hit_box_body_entered(body):
	if body.is_in_group("player"):
		player = body
		set_physics_process(true)


func _on_hit_box_body_exited(body):
	if body.is_in_group("player"):
		set_physics_process(false)
