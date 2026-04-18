extends CharacterBody3D

@export var cam: Camera3D
@export var invert_y: bool

const SPEED: float = 2.0
const JUMP_VELOCITY: float = 1.5

const MOUSE_TURN_SPEED: float = PI * 0.001
const MOUSE_LOOK_SPEED: float = PI * 0.001
const JOY_TURN_SPEED: float = PI * 0.75
const JOY_LOOK_SPEED: float = PI * 0.5

const MOUSE_DEADZONE: float = 0.001
const MAX_PITCH_CAM: float = PI * 0.3

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

var _joy_look: Vector2
var _using_joy_look: bool

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        var m_event: InputEventMouseMotion = event
        _process_rel_look(Vector2(-m_event.relative.x * MOUSE_TURN_SPEED, m_event.relative.y * MOUSE_LOOK_SPEED))
        _using_joy_look = false

    elif event is InputEventJoypadMotion:
        var rel: Vector2 = Input.get_vector("player_look_right", "player_look_left", "player_look_up", "player_look_down")
        _joy_look = Vector2(rel.x * JOY_TURN_SPEED, rel.y * JOY_LOOK_SPEED)
        _using_joy_look = true

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
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta

    # Handle jump.
    if Input.is_action_just_pressed("player_jump") and is_on_floor():
        velocity.y = JUMP_VELOCITY

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
