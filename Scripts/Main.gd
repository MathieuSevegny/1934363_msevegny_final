extends Node2D

export (PackedScene) var audiomachine
onready var enemy = load("res://Scenes/Enemy.tscn")
var isfinish = false
var currentmap
var currentspawn
 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var global = $"/root/Global"


# Called when the node enters the scene tree for the first time.
func _ready():
	changer_lvl()
	charge_enemies()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var nb_enemies = get_tree().get_nodes_in_group("Enemies").size()
	if !isfinish:
		if $Player.nb_vie <= 0:
			isfinish = true
			$Player/Camera2D.clear_current()
			$Camerafin.make_current()
			$Camerafin/MenuFin.visible = true
			$Player.queue_free()
			var son = audiomachine.instance()
			var bruit = load("res://Assets/Sounds/player_death.wav") 
			son.stream = bruit
			get_parent().add_child(son)
		else:
			$Player/Camera2D/Control/Label/ProgressBar.value = $Player.nb_vie
			$Player/Camera2D/Control/Label/Panel/Label.text = "Ennemis restants : " + str(nb_enemies)
		if nb_enemies <= 0:
			if !global.islastlvl():
				changer_lvl()
				charge_enemies()
			else:
				isfinish = true
				$Camerafin/MenuFin/Panel/FinalText.text = "Vous avez gagné!"
				$Player/Camera2D.clear_current()
				$Camerafin.make_current()
				$Camerafin/MenuFin.visible = true
				$Player.queue_free()
		
func changer_lvl():
	for balle in get_tree().get_nodes_in_group("Balles"):
		balle.queue_free()
		
	if !global.islastlvl():
		global.currentlvl += 1
		var map = global.getmap()
		if global.currentlvl == 1:
			var next_level = map.instance()
			$LvlContainer.add_child(next_level)
			currentmap = next_level
			currentspawn = $LvlContainer/Lvl/Mur/Spawn.global_position
		else:
			var next_level = map.instance()
			for n in $LvlContainer.get_children():
				$LvlContainer.remove_child(n)
				n.queue_free()
			$LvlContainer.add_child(next_level)
			currentmap = next_level
			currentspawn = $LvlContainer/Lvl/Mur/Spawn.global_position
		$Camerafin.position = currentspawn
		$Player.position = currentspawn
		
func charge_enemies():
	var enemies = global.getenemies()
	for enemynumber in enemies:
		var newenemy = enemy.instance()
		newenemy.enemytype = enemynumber
		var leftup = $LvlContainer/Lvl/Mur/SpawnZone/LEFTUP.position
		var rightdown = $LvlContainer/Lvl/Mur/SpawnZone/RIGHTDOWN.position
		var spawn = currentspawn
		var x
		var y
		var positionprobable
		var distance = 0
		while distance <= 500:
			x = rand_range(leftup.x , rightdown.x)
			y = rand_range(leftup.y , rightdown.y)
			positionprobable = Vector2(x,y)
			distance = positionprobable.distance_to(spawn)
		newenemy.position = positionprobable
		
		add_child(newenemy)
	


func _on_MainMenu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
