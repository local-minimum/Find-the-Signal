extends Node3D
class_name Room

signal on_enter_room
signal on_exit_room

@export var appartment: Appartment

var is_inside: bool:
    set(value):
        is_inside = value
        if value:
            on_enter_room.emit()
        else:
            on_exit_room.emit()

func _on_area_3d_body_entered(body: Node3D) -> void:
    if body is CharacterBody3D:
        is_inside = true


func _on_area_3d_body_exited(body: Node3D) -> void:
    if body is CharacterBody3D:
        is_inside = false
