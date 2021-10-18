extends Camera2D


export var player_path = NodePath()

var acceleration := 0.1
var player
var is_shaking := false
var shake_strength = 20.0


func _ready():
	player = get_node(player_path)
	player.connect("call", self, "player_call")
	player.connect("attack", self, "player_attack")
	player.connect("attack_finished", self, "player_attack_finished")


func _process(delta):
	if not player:
		return
	global_position = global_position.linear_interpolate(player.camera_pos, acceleration)
	zoom = zoom.linear_interpolate(Vector2.ONE, acceleration)
	if is_shaking:
		global_position += Vector2.RIGHT.rotated(randf() * 2 * PI) * randf() * shake_strength


func set_shake(shaking: bool, strength := 10.0) -> void:
	is_shaking = shaking
	shake_strength = strength


func player_call() -> void:
	zoom = Vector2.ONE * 0.98
	pass


func player_attack() -> void:
	set_shake(true, 10.0)


func player_attack_finished() -> void:
	set_shake(false)
