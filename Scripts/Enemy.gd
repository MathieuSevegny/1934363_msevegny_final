extends KinematicBody2D

export var enemytype = 1
var isnear = false
var player
var firsttimeseeing = true
var vie
export (PackedScene) var balle
export (PackedScene) var missile
export (PackedScene) var audiomachine
var explosion = preload("res://Scenes/Explosion.tscn")
onready var canon = $Canon
var maxshootdelay
var shootdelay
var vitesse


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Enemies")
	if enemytype == 1:
		vie = 10
		vitesse = 10
		maxshootdelay = 0.75
		$Sprite1.visible = true
		$Coll1.disabled = false
	if enemytype == 2:
		maxshootdelay = 1.00
		vie = 30
		vitesse = 5
		$Sprite2.visible = true
		$Coll2.disabled = false
	if enemytype == 3:
		maxshootdelay = 1.00
		vitesse = 5
		vie = 50
		$Sprite3.visible = true
		$Coll3.disabled = false
	shootdelay = maxshootdelay


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocite
	var dir
	var distance
	if isnear:
		dir = player.position - global_position
		rotation = dir.angle() + 1.5
		distance = global_position.distance_to(player.global_position);
		if distance > 300:
			velocite = Vector2(0, -1).rotated(rotation)
			move_and_collide(velocite)
		elif distance > 200:
			velocite = Vector2(1, 0).rotated(rotation)
			move_and_collide(velocite)
		elif distance < 200:
			velocite = Vector2(0, 1).rotated(rotation)
			move_and_collide(velocite)
		if shootdelay < 0:
			if enemytype == 1:
				tireBalle()
			if enemytype == 2:
				tireMissile()
			if enemytype == 3:
				tireTroisBalles()
			shootdelay = maxshootdelay
		else:
			shootdelay -= 1.0 * delta
func _physics_process(delta):
	pass

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		if firsttimeseeing:
			firsttimeseeing = false
			player = body
		isnear = true

func _on_Area2D_body_exited(body):
	if "Player" in body.name:
		isnear = false

func touched():
	vie -= 10
	if vie <= 0:
		var son = audiomachine.instance()
		var bruit = load("res://Assets/Sounds/player_death.wav") 
		son.stream = bruit
		var newexplosion = explosion.instance()
		newexplosion.position = position
		newexplosion.scale = Vector2(enemytype,enemytype)
		get_parent().add_child(newexplosion)
		get_parent().add_child(son)
		queue_free()

func tireMissile():
	var m = missile.instance()
	m.creer(canon.global_position, rotation)
	get_parent().add_child(m)
	var son = audiomachine.instance()
	var bruit = load("res://Assets/Sounds/missile.wav") 
	son.stream = bruit
	get_parent().add_child(son)

func tireBalle():
	var b = balle.instance()
	b.creer(canon.global_position, rotation)
	get_parent().add_child(b)
	var son = audiomachine.instance()
	var bruit = load("res://Assets/Sounds/shoot.wav") 
	son.stream = bruit
	get_parent().add_child(son)

func tireTroisBalles():
	var b1 = balle.instance()
	b1.creer(canon.global_position, rotation - 0.3)
	var b2 = balle.instance()
	b2.creer(canon.global_position, rotation)
	var b3 = balle.instance()
	b3.creer(canon.global_position, rotation + 0.3)
	get_parent().add_child(b1)
	get_parent().add_child(b2)
	get_parent().add_child(b3)
	var son = audiomachine.instance()
	var bruit = load("res://Assets/Sounds/shoot.wav") 
	son.stream = bruit
	get_parent().add_child(son)
