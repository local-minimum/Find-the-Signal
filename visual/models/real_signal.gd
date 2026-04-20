extends Node

@export var anim_player: AnimationPlayer
@export var anim: String = "Outro"

@export var poem: SubbedAudio

@export var signal_player: AudioStreamPlayer3D

@export var distance: float = 1.5
@export var vertical_view_bias: float = 0.5
@export var look_target: Node3D
@export var _camera: Camera3D
@export var ease_duration: float = 0.5
@export var _focus_fov: float = 65

@export var _fade_wispers_time: float = 4.0

var _outro_ready: bool

func _enter_tree() -> void:
    if __SignalBus.on_ready_goal.connect(_handle_ready_goal) != OK:
        push_error("Failed to connect ready goal")

func _handle_ready_goal() -> void:
    _outro_ready = true
    signal_player.play()

func _trigger_outro() -> void:
    __SignalBus.on_trigger_outro.emit()
    _focus_on_target()
    _silence_signals()
    _silence_whispers()
    poem.play(null, _do_the_end, AudioHub.QueueBehaviour.IGNORE_QUEUE_SILENCE_PLAYING, 2.5)
    anim_player.play(anim)
    _outro_ready = false

var _cam_slide_tween: Tween

func _silence_signals() -> void:
    var bus_idx: int = AudioServer.get_bus_index("Signal")
    var start_volume = AudioServer.get_bus_volume_linear(bus_idx)

    var fn: Callable = func(volume: float) -> void:
        AudioServer.set_bus_volume_linear(bus_idx, volume)
        if volume == 0.0:
            signal_player.stop()

    var tween = create_tween()
    tween.tween_method(fn, start_volume, 0.0, _fade_wispers_time * 0.5)


func _silence_whispers() -> void:
    var bus_idx: int = AudioServer.get_bus_index("Wispers")
    var start_volume = AudioServer.get_bus_volume_linear(bus_idx)

    var fn: Callable = func(volume: float) -> void:
        AudioServer.set_bus_volume_linear(bus_idx, volume)

    var tween = create_tween()
    tween.tween_method(fn, start_volume, 0.0, _fade_wispers_time)

func _focus_on_target() -> void:
    if _cam_slide_tween != null && _cam_slide_tween.is_running():
        _cam_slide_tween.kill()

    var offset: Vector3 = (_camera.global_position - look_target.global_position).normalized()
    var up: Vector3 = offset.project(Vector3.UP)
    var lateral: Vector3 = offset - up

    offset = (
        up.normalized() * vertical_view_bias +
        lateral.normalized()
    ).normalized() * distance

    var expected: Vector3 = look_target.global_position + offset

    var tw_rot_method: Callable = QuaternionUtils.create_tween_rotation_method(_camera)

    _cam_slide_tween = create_tween().set_parallel()
    @warning_ignore_start("return_value_discarded")
    _cam_slide_tween.tween_property(_camera, "global_position", expected, ease_duration)
    #_cam_slide_tween.tween_property(_camera, "near", _gridless_controller.camera_near if _gridless_controller != null else 0.01, ease_duration)
    _cam_slide_tween.tween_property(_camera, "fov", _focus_fov, ease_duration)
    _cam_slide_tween.tween_method(tw_rot_method, _camera.global_basis.get_rotation_quaternion(), Basis.looking_at(-offset).get_rotation_quaternion(), ease_duration)
    @warning_ignore_restore("return_value_discarded")


func _do_the_end(_success: bool) -> void:
    __SignalBus.on_trigger_the_end.emit()


func _on_area_3d_body_entered(_body: Node3D) -> void:
    if _outro_ready:
        _trigger_outro()
