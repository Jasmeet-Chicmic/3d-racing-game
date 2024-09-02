extends Node3D


@onready var main_menu = $CanvasLayer/MainContainer
@onready var canvas_layer = $CanvasLayer
@onready var line_edit = $CanvasLayer/MainContainer/MarginContainer/VBoxContainer/LineEdit
var truck:PackedScene = preload("res://vehicles/trailer_truck.tscn")

const PORT = 9999;
var enet_peer = ENetMultiplayerPeer.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_host_pressed() -> void:
	
	enet_peer.create_server(PORT);
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(addPlayer)
	
	addPlayer(multiplayer.get_unique_id())

func addPlayer(uniqueId:int)->void :
	main_menu.hide()
	var truckNode = truck.instantiate();
	truckNode.name =  str(uniqueId);
	add_child(truckNode)
	
func _on_join_pressed() -> void:
	main_menu.hide()
	enet_peer.create_client("localhost",PORT);
	multiplayer.multiplayer_peer = enet_peer
	 # Replace with function body.
