extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$Player.dead :
		$Contour/VieContainer/Vie.rect_size.x = 40 * (float($Player.nb_vie) / 100)
	else:
		queue_free()
