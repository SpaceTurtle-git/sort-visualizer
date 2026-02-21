extends CanvasLayer

@onready var settingsButton: Button = $"../settingsButton"
@onready var pauseButton:Button = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer4/pauseButton

var barNewCount 

signal algorithm_changed(index: int)

func _ready():
	self.hide() # Start with menu hidden

func _on_close_button_pressed() -> void:
	self.hide()
	settingsButton.show()
	print("Close pressed")

func _on_settings_button_pressed() -> void:
	self.show()
	settingsButton.hide()
	print("Settings pressed")

func _on_number_of_bars_value_changed(value: float) -> void:
	var mainNode = get_tree().root.get_node("Node2D")
	mainNode.array_size = value
	mainNode.to_reset = true
	print("Slider Used")


func _on_pause_button_pressed() -> void:
	var mainNode = get_tree().root.get_node("Node2D")
	mainNode.is_paused = !mainNode.is_paused
	pauseButton.text = "RESUME" if mainNode.is_paused else "PAUSE"
	print("Paused Used")

func _on_reset_button_pressed() -> void:
	var mainNode = get_tree().root.get_node("Node2D")
	mainNode.to_reset = true


func _on_speed_box_value_changed(value: float) -> void:
	var mainNode = get_tree().root.get_node("Node2D")
	mainNode.speed = value
	print("SpeedBox Used")


func _on_sorting_algorithms_menu_item_selected(index: int) -> void:
	algorithm_changed.emit(index)
