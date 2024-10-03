extends Node3D
@export var playerScene: Array[PackedScene]
# Assuming the node has children
var child_count
var spawnpoints
var timer=0
var gameStartLabel=["3","2","1","Let's Go",""]
signal GameEnd()
# Called when the node enters the scene tree for the first time.
func _ready():
	
	child_count = $Sets.get_child_count()
	spawnpoints = get_tree().get_nodes_in_group("spawnpoint")
	# Each instance should have its own set_array
	var set_array = [] # Create a new array for this instance
	set_array.resize(child_count)
	set_array.fill(false)
	
	var index = 0
	var keys = NakamaMultiplayer.Players.keys()
	keys.sort()
	
	for i in keys:
		#print("My Id",NakamaMultiplayer.Players[i].vehicleId)
		var instancedPlayer = playerScene[NakamaMultiplayer.Players[i].vehicleId].instantiate()
		#print("Inst",instancedPlayer)
		instancedPlayer.name = str(NakamaMultiplayer.Players[i].name)
		
		instancedPlayer.set_array = set_array.duplicate() # Assign a unique set_array to each player
		$Players.add_child(instancedPlayer)
		instancedPlayer.set_physics_process(false)
		instancedPlayer.global_position = spawnpoints[index].global_position
		index += 1
	$StartTimer/Timer.start()

# Called when an area is entered
func timerStart():
	$StartTimer.update_Timer(gameStartLabel[timer])
	timer+=1
	if timer==gameStartLabel.size():
		$StartTimer/Timer.stop()
		$StartTimer.hide()
		for player in $Players.get_children():
			player.set_physics_process(true)
		
	pass
func _on_area_3d_body_entered(body: Node3D, road_idx: int) -> void:
	if is_multiplayer_authority():
		print("Body:-", body.get_parent().name,"-->",road_idx)
		body.get_parent().set_array[road_idx] = true # Access the player's unique set_array

		if road_idx == 0:
			var all_true = true
			for value in body.get_parent().set_array:
				if not value:
					all_true = false
					break

			if all_true:
				print("Win!  Body:", body.get_parent().name)
				gameEnd.rpc(body.get_parent().name)

@rpc("any_peer", "call_local")
func gameEnd(winner):
	#print("Game starting")
	GameEnd.emit(winner)
