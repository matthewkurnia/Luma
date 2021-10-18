extends Area2D


export var initial_color := Color.gray
export var final_color := Color.white

var has_bloomed := false

onready var sprites = $Sprites
onready var tween = $Tween


func _ready():
	randomize()
	tween.playback_speed = 0.5 + 0.5 * randf()
	var n = randi() % 3
	sprites.scale = Vector2.ONE * (0.25 + 0.3 * randf())
	sprites.rotation = randf() * 2 * PI
	var sprites_arr = sprites.get_children()
	for i in sprites_arr.size():
		sprites_arr[i].visible = i == n
		sprites_arr[i].modulate = initial_color


func bloom():
	if has_bloomed:
		return
	has_bloomed = true
	for sprite in sprites.get_children():
		tween.interpolate_property(sprite, "scale",
				sprite.scale, sprite.scale * 2,
				1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.interpolate_property(sprite, "rotation_degrees",
				0.0, 40.0,
				1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.interpolate_property(sprite, "modulate",
				initial_color, final_color,
				1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	pass
