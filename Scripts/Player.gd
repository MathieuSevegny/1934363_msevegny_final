extends KinematicBody2D

var vitesse = 200
var velocite = Vector2()
onready var canon = $Model/Canon
export (PackedScene) var balle
export (PackedScene) var audiomachine
var dead = false
export var nb_vie = 100
var rotate
var maxshootdelay = 0.50
var shootdelay


func _ready():
	shootdelay = maxshootdelay

func _physics_process(delta):
	get_input()
	var shoot = Input.is_action_just_pressed("shoot")
	var dir = get_global_mouse_position() - global_position
	if dir.length() > 5:
		rotate = dir.angle()
		$CollisionPolygon2D.rotation = rotate
		var collision = move_and_collide(velocite * delta)
		if collision:
			if "Enemy" in collision.collider.name:
				touche_missile()
			
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
	if shootdelay < 0:
		if shoot:
			shoot()
			var b = balle.instance()
			b.creer(canon.global_position, rotate)
			get_parent().add_child(b)
	else:
		shootdelay -= 1.0 * delta
func get_input():
	var avance = Input.is_action_pressed("move_up")
	var recule = Input.is_action_pressed("move_down")
	var gauche = Input.is_action_pressed("move_left")
	var droite = Input.is_action_pressed("move_right")
	
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
		
func touche_missile():
	nb_vie -= 10
	if nb_vie <= 0:
		dead = true

func touche_balle():
	nb_vie -= 5
	if nb_vie <= 0:
		dead = true

func shoot():
	shootdelay = maxshootdelay
	var son = audiomachine.instance()
	var bruit = load("res://Assets/Sounds/shoot.wav") 
	son.stream = bruit

	get_parent().add_child(son)



