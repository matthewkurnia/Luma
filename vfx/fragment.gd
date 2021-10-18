extends Sprite


var velocity := 400.0
var direction := 0.0
var fade_duration := 1.0

onready var animation_player = $AnimationPlayer


func _ready():
	self.rotation = randf() * 2 * PI
	animation_player.playback_speed = 1.0 / fade_duration


func _process(delta):
	self.translate(Vector2.UP.rotated(direction) * velocity * delta)
	self.rotation_degrees += 1.0


func _on_animation_player_animation_finished(anim_name):
	self.queue_free()
