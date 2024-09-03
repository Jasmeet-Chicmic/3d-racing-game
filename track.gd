extends Node3D

@onready var vehicle:PackedScene = preload("res://vehicles/car_base.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(GameManager.Players)
	for player in GameManager.Players:
		var vehicleScene = vehicle.instantiate();
		vehicleScene.name = str(player);
		$Players.add_child(vehicleScene)
		
	
