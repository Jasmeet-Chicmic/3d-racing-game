extends Node3D
const PORT = 9999;
var enet_peer
@onready var track:PackedScene = preload("res://track.tscn")
@onready var canvasLayer = $CanvasLayer;
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.server_disconnected.connect(server_disconnected)
	multiplayer.connected_to_server.connect(server_connected)


func server_disconnected() -> void :
	print("server disconnected")
	

func server_connected() -> void :
	sendPlayerInfo.rpc_id(1,$CanvasLayer/MainContainer/MarginContainer/VBoxContainer/Name.text,multiplayer.get_unique_id())
	
func peer_connected(id) ->void:
	
	print("Player is connected",id)

func peer_disconnected(id) ->void:
	#enet_peer.disconnect_peer(id)
	#multiplayer.multiplayer_peer.close()
	GameManager.Players.erase(id)
	print("Player is disconnected",id)

func hideButtons() -> void:
	$CanvasLayer/MainContainer/MarginContainer/VBoxContainer/Host.hide()
	$CanvasLayer/MainContainer/MarginContainer/VBoxContainer/Join.hide()
func _on_host_pressed() -> void:
	#Server._connect_to_server()
	enet_peer = ENetMultiplayerPeer.new()
	var error = enet_peer.create_server(PORT,2);
	if error != OK:
		print("Cannot host",error)
	multiplayer.set_multiplayer_peer(enet_peer) 
	sendPlayerInfo($CanvasLayer/MainContainer/MarginContainer/VBoxContainer/Name.text,multiplayer.get_unique_id())
	hideButtons()
	print("Host Connected, wailting for other players")


	
func _on_join_pressed() -> void:
	enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_client("localhost",PORT);
	multiplayer.set_multiplayer_peer(enet_peer) 
	hideButtons()
	 # Replace with function body.


func _on_start_game_pressed() -> void:
	
	startgame.rpc()

	
	
	
	 # Replace with function body.
@rpc("any_peer","call_local")
func startgame():
	var trackScene = track.instantiate()
	canvasLayer.hide()
	$"../".add_child(trackScene);

@rpc("any_peer")
func sendPlayerInfo(name,id) :
	if !GameManager.Players.has("id"):
		GameManager.Players[id] = {
			"id":id,
			"name":name
		}
	print("Players data",GameManager.Players)
	if multiplayer.is_server():
		for i in GameManager.Players :
			sendPlayerInfo.rpc(GameManager.Players[i].name,i)
			
	
