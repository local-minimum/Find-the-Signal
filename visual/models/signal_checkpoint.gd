extends Node3D
class_name SignalCheckpoint

@export var _require_room: Room
@export var _text_write_helper: TextWriterHelper
@export var _near_threshold: float = 0.2
@export var _spellings: Array[String] = ["SIGNAL?"]
@export var _word_spacings: Array[int] = [2]
@export var _whisperer: WisperPlayer
@export var _dialogue: SubbedAudio

var completed: bool:
    set(value):
        if value && !completed:
            completed = value

            if _whisperer:
                _whisperer.change_to_whisper()
            else:
                push_warning("This signal %s doesn't have a whisper" % self)

            if _dialogue != null:
                _dialogue.play()

            if _require_room:
                _require_room.appartment.signals_found += 1
            else:
                push_warning("This signal %s doesn't have a room" % self)

var _entry_dist: float
var _body: Node3D

func _ready() -> void:
    set_process(false)

func _planar_dist_to(body: Node3D) -> float:
    var delta: Vector3 = body.global_position - global_position
    delta.y = 0
    return delta.length()

func _on_area_3d_body_entered(body: Node3D) -> void:
    if body is CharacterBody3D && !completed && (_require_room == null || _require_room.is_inside):
        _body = body
        _entry_dist = _planar_dist_to(body)
        _text_write_helper.text = _spellings[0]
        set_process(true)

func _on_area_3d_body_exited(body: Node3D) -> void:
    if body is CharacterBody3D:
        set_process(false)


func _process(_delta: float) -> void:
    if _body == null || completed:
        set_process(false)
        return

    var progress: float = 1.0 - clampf((_planar_dist_to(_body) - _near_threshold) / (maxf(0.01, _entry_dist - _near_threshold)), 0.0, 1.0)
    var idx: int = ceili(progress * (_spellings.size() - 1))
    if progress == 1.0:
        idx = _spellings.size() - 1
        completed = true

    _text_write_helper.text = _spellings[idx]
    if !_word_spacings.is_empty():
        _text_write_helper.word_spacing = _word_spacings[mini(idx, _word_spacings.size() - 1)]
