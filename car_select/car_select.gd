extends Control
signal MultiPlayerConnection

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func onVechileSelect(vechileId:int):
	print("vechileId:",vechileId)
	signalEmit(vechileId)

func signalEmit(vechileId):
	hide()
	MultiPlayerConnection.emit(vechileId)
