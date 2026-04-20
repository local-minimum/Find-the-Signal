extends CanvasLayer

@export_file("*.tscn") var menu_scene: String
@export var the_ender: AudioStreamPlayer
@export var labels: Array[Label]

func _enter_tree() -> void:
    for l in labels:
        l.hide()

    if __SignalBus.on_trigger_the_end.connect(end_it_all) != OK:
        push_error("Failed to connect the end")

func end_it_all() -> void:
    for l in labels:
        await get_tree().create_timer(randf_range(0.05, 0.2)).timeout
        l.show()

    the_ender.play()

    await get_tree().create_timer(2.0).timeout

    get_tree().change_scene_to_file(menu_scene)
