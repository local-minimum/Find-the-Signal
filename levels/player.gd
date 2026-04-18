extends CharacterBody3D

@export var cam: Camera3D

const SPEED: float = 2.0
const JUMP_VELOCITY: float = 4.5
const TURN_SPEED: float = PI * 0.001
const LOOK_SPEED: float = PI * 0.001
const MOUSE_DEADZONE: float = 0.001
const MAX_PITCH_CAM: float = PI * 0.3

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        var m_event: InputEventMouseMotion = event
        var rel: Vector2 = m_event.relative
        if abs(rel.x) > MOUSE_DEADZONE:
            rotate(up_direction, -rel.x * TURN_SPEED)
        if abs(rel.y) > MOUSE_DEADZONE:
            cam.rotation = (cam.rotation + rel.y * Vector3.LEFT * LOOK_SPEED).clampf(-MAX_PITCH_CAM, MAX_PITCH_CAM)

func _physics_process(delta: float) -> void:
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta

    # Handle jump.
    if Input.is_action_just_pressed("player_jump") and is_on_floor():
        velocity.y = JUMP_VELOCITY

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
