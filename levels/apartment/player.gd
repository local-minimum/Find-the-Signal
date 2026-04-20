extends CharacterBody3D
class_name PlayerCharacter

@export var cam: Camera3D
var invert_y: bool:
    get():
        return AccessibilitySettings.mouse_inverted_y

var mouse_speed: float:
    get():
        return AccessibilitySettings.mouse_sensitivity

var mouse_look_speed: float:
    get():
        return AccessibilitySettings.mouse_sensitivity * 0.5

var joy_turn_speed:
    get():
        return AccessibilitySettings.joy_sensitivity * PI

var joy_look_speed:
    get():
        return AccessibilitySettings.joy_sensitivity * PI * 0.5

var cinematic: bool

const SPEED: float = 2.0
const JUMP_VELOCITY: float = 1.5

const MOUSE_DEADZONE: float = 0.001
const MAX_PITCH_CAM: float = PI * 0.3

func _enter_tree() -> void:
    if __SignalBus.on_trigger_outro.connect(_handle_trigger_outro) != OK:
        push_error("Failed to connect trigger outro")

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

var _joy_look: Vector2
var _using_joy_look: bool

func _input(event: InputEvent) -> void:
    if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED && event is InputEventMouseButton:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

    elif Input.mouse_mode == Input.MOUSE_MODE_CAPTURED && !cinematic:
        if event is InputEventMouseMotion:
            var m_event: InputEventMouseMotion = event
            _process_rel_look(Vector2(-m_event.relative.x * mouse_speed, m_event.relative.y * mouse_look_speed))
            _using_joy_look = false

            get_viewport().set_input_as_handled()

        elif event is InputEventJoypadMotion:
            var rel: Vector2 = Input.get_vector("player_look_right", "player_look_left", "player_look_up", "player_look_down")
            _joy_look = Vector2(rel.x * joy_turn_speed, rel.y * joy_look_speed)
            _using_joy_look = true

            get_viewport().set_input_as_handled()

    if Input.is_action_just_pressed("pause"):
        get_tree().quit()

func _process_rel_look(rel: Vector2) -> void:
        if abs(rel.x) > MOUSE_DEADZONE:
            rotate(up_direction, rel.x)
        if abs(rel.y) > MOUSE_DEADZONE:
            if invert_y:
                cam.rotation = (cam.rotation - rel.y * Vector3.LEFT).clampf(-MAX_PITCH_CAM, MAX_PITCH_CAM)
            else:
                cam.rotation = (cam.rotation + rel.y * Vector3.LEFT).clampf(-MAX_PITCH_CAM, MAX_PITCH_CAM)

func _physics_process(delta: float) -> void:
    if cinematic:
        return

    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta

    # Handle jump.
    #if Input.is_action_just_pressed("player_jump") and is_on_floor():
        #velocity.y = JUMP_VELOCITY

    if _using_joy_look && _joy_look != Vector2.ZERO:
        _process_rel_look(_joy_look * delta)

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var input_dir := Input.get_vector("player_strafe_left", "player_strafe_right", "player_forward", "player_backward")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()

func _handle_trigger_outro() -> void:
    cinematic = true
