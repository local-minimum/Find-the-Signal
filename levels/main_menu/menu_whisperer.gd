extends MeshInstance3D
class_name MenuWhisperer

@export var player: AudioStreamPlayer
@export var ease_duration: float = 1.0

var _tween: Tween
enum Fade { FADE_IN, FADE_OUT }

var _last_fade: Fade = Fade.FADE_OUT

func _on_area_3d_mouse_entered() -> void:
    play()

func play() -> void:
    if _last_fade == Fade.FADE_IN:
        return

    if _tween && _tween.is_running():
        _tween.kill()

    _last_fade = Fade.FADE_IN

    var duration: float = (1 - player.volume_linear) * ease_duration

    if duration > 0.0:
        _tween = create_tween()
        _tween.tween_property(
            player,
            "volume_linear",
            1.0,
            duration,
        )

func _on_area_3d_mouse_exited() -> void:
    mute()

func mute() -> void:
    if _last_fade == Fade.FADE_OUT:
        return

    if _tween && _tween.is_running():
        _tween.kill()

    _last_fade = Fade.FADE_OUT

    var duration: float = player.volume_linear * ease_duration

    if duration > 0.0:
        _tween = create_tween()
        _tween.tween_property(
            player,
            "volume_linear",
            0.0,
            duration,
        )
