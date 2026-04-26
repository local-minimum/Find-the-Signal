extends Node
class_name SignalBus

@warning_ignore_start("unused_signal")
# Cursor
signal on_toggle_captured_cursor(active: bool)
signal on_captured_cursor_change(cursor_shape: Input.CursorShape)

# Settings
#signal on_update_input_mode(method: BindingHints.InputMode)
signal on_update_handedness(handedness: AccessibilitySettings.Handedness)
signal on_update_mouse_y_inverted(inverted: bool)
signal on_update_mouse_sensitivity(sensistivity: float)
signal on_update_joy_sensitivity(sensistivity: float)

# A11Y systems
signal on_subtitle(data: SubData)
signal on_clear_queued_subtitles(subs: Array[SubData])
signal on_clear_all_queued_subtitles()
signal on_toggle_subtitles(enabled: bool)
signal on_change_subtitles_size(size: int)
signal on_change_text_animation_targets(target: Appartment.AnimationTarget)
signal on_change_whisper_muting(mute_priority: int)

# Trigger outro
signal on_ready_goal
signal on_trigger_outro
signal on_trigger_the_end
