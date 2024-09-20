extends Control
signal VechileSelected
signal StartGame
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func startGame():
	StartGame.emit()
	#hide()
	
func onVechileSelect(vechileId:int):
	print("vechileId:",vechileId)
	vechileSelectedSignalEmit(vechileId)

func vechileSelectedSignalEmit(vechileId):
	#hide()
	VechileSelected.emit(vechileId)
