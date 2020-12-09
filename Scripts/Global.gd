extends Node

var currentlvl = 0
var numberoflvl = 3
var n1_types_enemies = [1,1,2,2,3]
var n1_map = load("res://Scenes/LVL1.tscn")
var n2_types_enemies = [1,1,2,2,3,2,3]
var n2_map = load("res://Scenes/LVL2.tscn")
var n3_types_enemies = [1,1,2,2,3,2,3,3,2]
var n3_map = load("res://Scenes/LVL3.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func islastlvl():
	if currentlvl >= numberoflvl:
		return true
	return false
func getenemies():
	if currentlvl == 1:
		return n1_types_enemies
	if currentlvl == 2:
		return n2_types_enemies
	if currentlvl == 3:
		return n3_types_enemies
func getmap():
	if currentlvl == 1:
		return n1_map
	if currentlvl == 2:
		return n2_map
	if currentlvl == 3:
		return n3_map
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
