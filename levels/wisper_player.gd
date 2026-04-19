extends AudioStreamPlayer3D
class_name WisperPlayer

@export var room: Room
@export var area: Area3D
@export var replacement_whisper: AudioStream

func _enter_tree() -> void:
    if room.on_enter_room.connect(_handle_player_enter_room) != OK:
        push_error("Failed to connect enter room")
    if room.on_exit_room.connect(_handle_player_exit_room) != OK:
        push_error("Failed to connect exit room")

    if area != null:
        if area.area_entered.connect(_handle_player_looks_at) != OK:
            push_error("Failed to connect look")
        if area.area_exited.connect(_handle_player_looks_away) != OK:
            push_error("Failed to connect look away")

func _handle_player_enter_room() -> void:
    play()

func _handle_player_exit_room() -> void:
    stop()


func change_to_whisper() -> void:
    stream = replacement_whisper
    bus = "Whispers"

const EASE_DURATION = 0.5
const LOOK_VOLUME = 1.5

var _tween: Tween

func _handle_player_looks_at(_area: Area3D) -> void:
    if _tween != null && _tween.is_running():
        _tween.kill()

    if volume_linear < LOOK_VOLUME:
        var delta: float = LOOK_VOLUME - volume_linear
        _tween = create_tween()
        _tween.tween_property(self, "volume_linear", LOOK_VOLUME, delta / (LOOK_VOLUME - 1.0) * EASE_DURATION)

func _handle_player_looks_away(_area: Area3D) -> void:
    if _tween != null && _tween.is_running():
        _tween.kill()

    if volume_linear > 1.0:
        var delta: float = volume_linear - 1.0
        _tween = create_tween()
        _tween.tween_property(self, "volume_linear", 1.0, delta / (LOOK_VOLUME - 1.0) * EASE_DURATION)
