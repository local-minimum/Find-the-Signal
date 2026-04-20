extends Node3D
static var whisper_volume: float
static var signal_volume: float

@export_file("*.tscn") var level: String

@export var whats: MenuWhisperer
@export var that: MenuWhisperer
@export var sig: MenuWhisperer

func _enter_tree() -> void:
    var bus_idx: int = AudioServer.get_bus_index("Signal")
    if signal_volume == 0.0:
        signal_volume = AudioServer.get_bus_volume_linear(bus_idx)
    else:
        AudioServer.set_bus_volume_linear(bus_idx, signal_volume)

    bus_idx = AudioServer.get_bus_index("Whispers")
    if whisper_volume == 0.0:
        whisper_volume = AudioServer.get_bus_volume_linear(bus_idx)
    else:
        AudioServer.set_bus_volume_linear(bus_idx, whisper_volume)

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _unhandled_input(event: InputEvent) -> void:
    if Time.get_ticks_msec() > 300 &&  event.is_action_pressed("player_jump"):
        get_tree().change_scene_to_file(level)

    if event is InputEventJoypadMotion:
        var _joy_look: Vector2 = Input.get_vector("player_look_right", "player_look_left", "player_look_up", "player_look_down")
        var _joy_move: Vector2 = Input.get_vector("player_strafe_right", "player_strafe_left", "player_forward", "player_backward")

        var y: float = _joy_look.y
        if y == 0.0:
            y = _joy_move.y

        var x: float = _joy_look.x
        if x == 0.0:
            x = _joy_move.x

        if y < 0:
            whats.play()
        else:
            whats.mute()

        if x != 0:
            that.play()
        else:
            that.mute()

        if y > 0:
            sig.play()
        else:
            sig.mute()
