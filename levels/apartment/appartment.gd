extends Node3D
class_name Appartment

@export var needed_signals: int = 6

var signals_found: int:
    set(value):
        signals_found = value
        if value == needed_signals:
            __SignalBus.on_ready_goal.emit()
