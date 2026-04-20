extends CanvasLayer
class_name PauseMenu

static var instance: PauseMenu

@export var inv_y: CheckButton
@export var mouse_sense: HSlider
@export var joy_sense: HSlider
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
