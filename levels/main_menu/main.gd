extends Node3D

@export_file("*.tscn") var level: String

func _unhandled_input(event: InputEvent) -> void:
    if Time.get_ticks_msec() > 300 &&  event.is_action_pressed("player_jump"):
        get_tree().change_scene_to_file(level)
