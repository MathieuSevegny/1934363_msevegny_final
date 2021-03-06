extends KinematicBody2D

var vitesse = 300
var velocite = Vector2()



func creer(pos,dir):
	add_to_group("Balles")
	position = pos
	velocite = Vector2(vitesse,0).rotated(dir)
	

func _physics_process(delta):
	var collision = move_and_collide(velocite*delta)
	if collision:
		if "Enemy" in collision.collider.name:
			collision.collider.touched()
			queue_free()
		if "Block" in collision.collider.name:
			queue_free()
		if "Mur" in collision.collider.name:
			queue_free()
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
