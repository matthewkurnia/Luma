extends Area2D


export var boid_needed := 1
export var bar_fill := 0.0

var fill_ratio := 0.0

onready var animation_player = $StaticBody2D/AnimationPlayer
onready var bar_anim = $StaticBody2D/BarAnimation
onready var bar = $StaticBody2D/Bar


func _ready():
	var shader_material = bar.material.duplicate()
	bar.material = shader_material


func _process(delta):
	bar.material.set_shader_param("fill_ratio", bar_fill * fill_ratio)


func activate(boid_count: int) -> void:
	fill_ratio = float(boid_count)/float(boid_needed)
	bar_anim.play("show_bar")
	yield(bar_anim, "animation_finished")
	if fill_ratio >= 1.0:
		animation_player.play("open")
		yield(animation_player, "animation_finished")
		self.queue_free()
	else:
		bar_anim.play_backwards("show_bar")
