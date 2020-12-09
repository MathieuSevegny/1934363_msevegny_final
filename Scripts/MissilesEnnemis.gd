extends KinematicBody2D

var vitesse = 200
var velocite = Vector2()
# var a = 2
# var b = "text"


func creer(pos,dir):
	add_to_group("Balles")
	position = pos
	rotation = dir
	velocite = Vector2(0,-vitesse).rotated(dir)
	

func _physics_process(delta):
	if vitesse < 400:
		vitesse += 100*delta
		velocite = Vector2(0,-vitesse).rotated(rotation)
	var collision = move_and_collide(velocite*delta)
	if collision:
		if "Player" in collision.collider.name:
			collision.collider.touche_missile()
			queue_free()
		if "Block" in collision.collider.name:
			queue_free()
		if "Mur" in collision.collider.name:
			queue_free()
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
