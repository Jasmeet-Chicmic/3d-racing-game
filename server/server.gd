extends Node3D

#const DEFAULT_IP = "127.0.0.1";
#const DEFAULT_PORT = 3234;
#var network = DEFAULT_IP;
#
#func _ready():
	#network = ENetMultiplayerPeer.new()
	#get_tree().connect("network_peer_connected", _player_connected)
	#get_tree().connect("network_peer_disconnected", _player_disconnected)
	#get_tree().connect("connection_failed", _connected_fail)
	#get_tree().connect("server_disconnected", _server_disconnected)
	#
#func _connect_to_server():
	#get_tree().connect("connected_to_server", _connected_ok)
	#network.create_client(DEFAULT_IP, DEFAULT_PORT)
	#multiplayer.multiplayer_peer = network
	#
#func _player_connected(id):
	#print("Player: " + str(id) + " Connected")
	#
#func _player_disconnected(id):
	#print("Player: " + str(id) + " Disconnected")
	#
#func _connected_ok():
	#print("Successfully connected to server")
	#
#func _connected_fail():
	#print("Failed to connect")
	#
#func _server_disconnected():
	#print("Server Disconnected")
