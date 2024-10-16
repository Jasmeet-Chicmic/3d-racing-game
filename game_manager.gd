extends Node3D
@export var multiplayerScene:Array[PackedScene]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI.OnStartGame.connect(onStartGame)
	pass # Replace with function body.

func onStartGame():
	var track=multiplayerScene[1].instantiate()
	$MultiplayerScene.add_child(track)
	track.GameEnd.connect(onGameEnd)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func onGameEnd(winner):
	$MultiplayerScene.hide()
	$Control.setResult(winner)
	reload_specific_scene_after_delay("res://game_manager.tscn",3.0)
	
# Reloads the specified scene after a given delay in seconds
func reload_specific_scene_after_delay(scene_path: String, seconds: float):
	var timer = Timer.new()  # Create a new Timer instance
	add_child(timer)  # Add the timer to the scene tree
	timer.wait_time = seconds  # Set the timer duration
	timer.one_shot = true  # Set the timer to only run once
	timer.start()  # Start the timer
	await timer.timeout  # Wait for the timer to complete
	#get_tree().change_scene(scene_path)  # Change to the specified scene
	get_tree().change_scene_to_file(scene_path)
