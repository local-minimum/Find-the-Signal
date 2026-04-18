extends Node3D
class_name Room

var is_inside: bool

func _on_area_3d_body_entered(body: Node3D) -> void:
    if body is CharacterBody3D:
        is_inside = true


func _on_area_3d_body_exited(body: Node3D) -> void:
    if body is CharacterBody3D:
        is_inside = false
