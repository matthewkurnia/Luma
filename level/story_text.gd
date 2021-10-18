extends Area2D


export var area_active := true

onready var anim_player = $Label/AnimationPlayer



func _ready():
	set_pop_up(false)
	if not area_active:
		self.collision_layer = 0
		self.collision_mask = 0


func _on_story_text_body_entered(body):
	if not body.is_in_group("player"):
		return
	set_pop_up(true)


func _on_story_text_body_exited(body):
	if not body.is_in_group("player"):
		return
	set_pop_up(false)


func alert() -> void:
	anim_player.play("pop_up")
	yield(get_tree().create_timer(2.0), "timeout")
	anim_player.play_backwards("pop_up")


func set_pop_up(value: bool) -> void:
	if value:
		anim_player.play("pop_up")
	else:
		anim_player.play_backwards("pop_up")
