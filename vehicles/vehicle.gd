extends Node3D

const STEER_SPEED = 1.5
const STEER_LIMIT = 0.9
const BRAKE_STRENGTH = 2.0
@onready var body = $Body;
@export var engineValue := 140.0
#@export var body:VehicleBody3D;
@onready var previous_speed = body.linear_velocity.length()
var _steer_target = 0.0

@onready var desired_engine_pitch: float = $Body/EngineSound.pitch_scale

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	
@rpc("any_peer","call_local")
func moveCar(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		_steer_target = Input.get_axis(&"right", &"left")
		
		_steer_target *= STEER_LIMIT

		# Engine sound simulation (not realistic, as this car script has no notion of gear or engine RPM).
		desired_engine_pitch = 0.05 + body.linear_velocity.length() / (engineValue * 0.5)
		# Change pitch smoothly to avoid abrupt change on collision.
		$Body/EngineSound.pitch_scale = lerpf($Body/EngineSound.pitch_scale, desired_engine_pitch, 0.2)

		if abs(body.linear_velocity.length() - previous_speed) > 1.0:
			# Sudden velocity change, likely due to a collision. Play an impact sound to give audible feedback,
			# and vibrate for haptic feedback.
			$Body/ImpactSound.play()
			Input.vibrate_handheld(100)
			for joypad in Input.get_connected_joypads():
				Input.start_joy_vibration(joypad, 0.0, 0.5, 0.1)

		# Automatically accelerate when using touch controls (reversing overrides acceleration).
		if DisplayServer.is_touchscreen_available() or Input.is_action_pressed(&"accelerate"):
			# Increase engine force at low speeds to make the initial acceleration faster.
			var speed = body.linear_velocity.length()
			if speed < 5.0 and not is_zero_approx(speed):
				body.engine_force = clampf(engineValue * 5.0 / speed, 0.0, 100.0)
			else:
				body.engine_force = engineValue

			if not DisplayServer.is_touchscreen_available():
				# Apply analog throttle factor for more subtle acceleration if not fully holding down the trigger.
				body.engine_force *= Input.get_action_strength(&"accelerate")
		else:
			body.engine_force = 0.0

		if Input.is_action_pressed(&"brake"):
			# Increase engine force at low speeds to make the initial reversing faster
			
			var speed = body.linear_velocity.length()
			if speed < 5.0 and not is_zero_approx(speed):
				body.engine_force = -clampf(engineValue * BRAKE_STRENGTH * 5.0 / speed, 0.0, 100.0)
			else:
				body.engine_force = -engineValue * BRAKE_STRENGTH


			# Apply analog brake factor for more subtle braking if not fully holding down the trigger.
			body.engine_force *= Input.get_action_strength(&"brake")
			
			#Added brake for space
		if Input.is_action_pressed(&"spacebrake"):
			
			if(body.linear_velocity.length()>0.5):
				body.engine_force = -engineValue * BRAKE_STRENGTH
			else:
				body.engine_force=0;
				body.linear_velocity = Vector3(0,0,0)
			
		body.steering = move_toward(body.steering, _steer_target, STEER_SPEED * delta)
		
		previous_speed =body.linear_velocity.length()
func _physics_process(delta: float) -> void:
	
	# if is_multiplayer_authority():
	moveCar.rpc(delta)
