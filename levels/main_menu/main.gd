extends Node3D

@export_file("*.tscn") var level: String

@export var whats: MenuWhisperer
@export var that: MenuWhisperer
@export var sig: MenuWhisperer



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
