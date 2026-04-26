extends Node3D
class_name Appartment

enum AnimationTarget { EVERYTHING = 0, NOT_STRUCTURE = 1, NOT_LARGE = 2, NOT_MEDIUM = 3, NOT_SMALL = 4, NOTHING = 5, UNSET = -1 }

static var animation_target: AnimationTarget = AnimationTarget.UNSET

@export var needed_signals: int = 6

@export var default_animation_target: AnimationTarget = AnimationTarget.NOT_STRUCTURE
@export var structure_meshes: Array[MeshInstance3D]
@export var large_furniture: Array[MeshInstance3D]
@export var medium_things: Array[MeshInstance3D]
@export var small_things: Array[MeshInstance3D]
@export var signals: Array[MeshInstance3D]

func _enter_tree() -> void:
    if __SignalBus.on_change_text_animation_targets.connect(_handle_anim_target_update) != OK:
        push_error("Failed to connect animation text targets")

func _ready() -> void:
    if animation_target == AnimationTarget.UNSET:
        _handle_anim_target_update(default_animation_target)
    else:
        _handle_anim_target_update(animation_target)

func _handle_anim_target_update(target: AnimationTarget) -> void:
    animation_target = default_animation_target
    match target:
        AnimationTarget.EVERYTHING:
            _set_anim(structure_meshes, true)
            _set_anim(large_furniture, true)
            _set_anim(medium_things, true)
            _set_anim(small_things, true)
            _set_anim(signals, true)

        AnimationTarget.NOT_STRUCTURE:
            _set_anim(structure_meshes, false)
            _set_anim(large_furniture, true)
            _set_anim(medium_things, true)
            _set_anim(small_things, true)
            _set_anim(signals, true)

        AnimationTarget.NOT_LARGE:
            _set_anim(structure_meshes, false)
            _set_anim(large_furniture, false)
            _set_anim(medium_things, true)
            _set_anim(small_things, true)
            _set_anim(signals, true)

        AnimationTarget.NOT_MEDIUM:
            _set_anim(structure_meshes, false)
            _set_anim(large_furniture, false)
            _set_anim(medium_things, false)
            _set_anim(small_things, true)
            _set_anim(signals, true)

        AnimationTarget.NOT_SMALL:
            _set_anim(structure_meshes, false)
            _set_anim(large_furniture, false)
            _set_anim(medium_things, false)
            _set_anim(small_things, false)
            _set_anim(signals, true)

        AnimationTarget.NOTHING:
            _set_anim(structure_meshes, false)
            _set_anim(large_furniture, false)
            _set_anim(medium_things, false)
            _set_anim(small_things, false)
            _set_anim(signals, false)

func _set_anim(group: Array[MeshInstance3D], animate: bool) -> void:
    for m: MeshInstance3D in group:
        for i: int in m.get_surface_override_material_count():
            var mat: Material = m.get_surface_override_material(i)
            if mat is not ShaderMaterial:
                continue

            var smat: ShaderMaterial = mat
            smat.set_shader_parameter("animate", animate)

var signals_found: int:
    set(value):
        signals_found = value
        if value == needed_signals:
            __SignalBus.on_ready_goal.emit()
