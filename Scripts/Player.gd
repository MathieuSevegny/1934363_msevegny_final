extends KinematicBody2D

var vitesse = 200
var velocite = Vector2()
var dead = false
export var nb_vie = 100
export (PackedScene) var balle
onready var canon = $Canon
export (PackedScene) var audiomachine


func _ready():
	pass

func _physics_process(delta):
	get_input()
	var dir = get_global_mouse_position() - global_position
	if dir.length() > 5:
		rotation = dir.angle()
		
		var collision = move_and_collide(velocite * delta)
		if collision:
			if "Asteroid" in collision.collider.name:
				collision.collider.destroy()
				#kill()
			
	if nb_vie < 1:
		dead = true
	var xsign = 1
	var ysign = 1
	
	if velocite.x < 0:
		xsign = -1
	if velocite.y < 0:
		ysign = -1
	
	if abs(velocite.x) < 0.1:
		velocite.x = 0
	else:
		velocite.x -= xsign * (100 * delta)
	
	if abs(velocite.y) < 0.1:
		velocite.y = 0
	else:
		velocite.y -= ysign * (100 * delta)
	
func get_input():
	var avance = Input.is_action_pressed("move_up")
	var recule = Input.is_action_pressed("move_down")
	var gauche = Input.is_action_pressed("move_left")
	var droite = Input.is_action_pressed("move_right")
	var shoot = Input.is_action_just_pressed("shoot")
	var x = 0
	var y = 0
	
	if avance:
		y = -vitesse
		
	if recule:
		y = vitesse
		
	if gauche:
		x = -vitesse
		
	if droite:
		x = vitesse
		
	if x != 0 || y!= 0:
		velocite = Vector2(x,y)
		move_and_collide(velocite/1000)
	if shoot:
		shoot()
		var b = balle.instance()
		b.creer(canon.global_position, rotation)
		get_parent().add_child(b)
func touche_missile():
	nb_vie -= 10
	if nb_vie <= 0:
		dead = true

func touche_balle():
	nb_vie -= 5
	if nb_vie <= 0:
		dead = true


func shoot():
	touche_balle()
	var son = audiomachine.instance()
	var bruit = load("res://Assets/Sounds/shoot.wav") 
	son.stream = bruit

	get_parent().add_child(son)

