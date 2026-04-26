extends CanvasLayer
class_name PauseMenu

static var instance: PauseMenu

@export var inv_y: CheckButton
@export var mouse_sense: HSlider
@export var joy_sense: HSlider
@export var anim_text: HSlider
@export var anim_text_explain: Label
@export var resume: Button

func _enter_tree() -> void:
    instance = self

func _exit_tree() -> void:
    if instance == self:
        instance = null

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        hide_menu()


func _ready() -> void:
    hide()

func show_menu() -> void:
    get_tree().paused = true
    show()

    inv_y.button_pressed = AccessibilitySettings.mouse_inverted_y
    mouse_sense.value = AccessibilitySettings.mouse_sensitivity
    joy_sense.value = AccessibilitySettings.joy_sensitivity
    anim_text.value = animation_target_slider_value
    anim_text_explain.text = get_animation_target_explained(roundi(anim_text.value))

    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    inv_y.grab_focus()

func hide_menu() -> void:
    get_tree().paused = false
    hide()

    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_invert_y_pressed() -> void:
    AccessibilitySettings.mouse_inverted_y = inv_y.button_pressed

func _on_mouse_sens_drag_ended(value_changed: bool) -> void:
    if value_changed:
        AccessibilitySettings.mouse_sensitivity = mouse_sense.value

func _on_controller_sens_drag_ended(value_changed: bool) -> void:
    if value_changed:
        AccessibilitySettings.joy_sensitivity = joy_sense.value

func _on_resume_pressed() -> void:
    hide_menu()

func _on_invert_y_gui_input(event: InputEvent) -> void:
    if event is InputEventJoypadButton:
        var e: InputEventJoypadButton = event
        if e.pressed && (e.button_index == 0 || e.button_index == 2):
            inv_y.button_pressed = !inv_y.button_pressed
            _on_invert_y_pressed()


func _on_resume_gui_input(event: InputEvent) -> void:
    if event is InputEventJoypadButton:
        var e: InputEventJoypadButton = event
        if e.pressed && (e.button_index == 0 || e.button_index == 2):
            hide_menu()


var animation_target_slider_value: int:
    get():
        if Appartment.animation_target == Appartment.AnimationTarget.UNSET:
            return int(anim_text.max_value) - int(Appartment.AnimationTarget.NOT_STRUCTURE)
        return int(anim_text.max_value) - int(Appartment.animation_target)

func get_animation_target_explained(slider_value: int) -> String:
    match slider_value:
        0:
            return "NOTHING"
        1:
            return "ONLY SIGNALS"
        2:
            return "ONLY SMALL THINGS"
        3:
            return "NOT LARGE THINGS"
        4:
            return "NOT STRUCTURE SURFACES"
        5:
            return "EVERYTHING!"
        _:
            return "?? UNKNOWN SETTING ??"

func _on_moving_text_slider_drag_ended(value_changed: bool) -> void:
    if !value_changed:
        return

    __SignalBus.on_change_text_animation_targets.emit(_get_new_animation_target())
    _on_moving_text_slider_value_changed(anim_text.value)

func _on_moving_text_slider_value_changed(value: float) -> void:
    __SignalBus.on_change_text_animation_targets.emit(_get_new_animation_target())
    anim_text_explain.text = get_animation_target_explained(roundi(value))

func _get_new_animation_target() -> Appartment.AnimationTarget:
    match roundi(anim_text.value):
        0:
            return Appartment.AnimationTarget.NOTHING

        1:
            return Appartment.AnimationTarget.NOT_SMALL

        2:
            return Appartment.AnimationTarget.NOT_MEDIUM

        3:
            return Appartment.AnimationTarget.NOT_LARGE

        4:
            return Appartment.AnimationTarget.NOT_STRUCTURE

        5:
            return Appartment.AnimationTarget.EVERYTHING

        _:
            push_warning("Unhandled slider value %s" % [anim_text.value])
            return Appartment.animation_target
