extends Node3D
@export var multiplayerScene:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI.OnStartGame.connect(onStartGame)
	pass # Replace with function body.

func onStartGame():
	var track=multiplayerScene.instantiate()
	$MultiplayerScene.add_child(track)
	track.GameEnd.connect(onGameEnd)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func onGameEnd(winner):
	$MultiplayerScene.hide()
	$Control.setResult(winner)
	
