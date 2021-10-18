extends CanvasLayer


export var player_path = NodePath()
export var menu_path = NodePath()

onready var anim_player = $CenterContainer/AnimationPlayer


func _input(event):
	if Input.is_action_just_released("attack") or Input.is_action_just_pressed("call"):
		get_node(player_path).set_deferred("start", 1)
		get_node(menu_path).set_deferred("can_pause", true)
		anim_player.play("start")
		yield(anim_player, "animation_finished")
		self.queue_free()
