extends Node2D

var data = []
var array_size = 100

@onready var screen_width = get_viewport_rect().size.x
@onready var screen_height = get_viewport_rect().size.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generateArray()
	print(data)
	await bubble_sort(data)
	print(data)

func generateArray():
	data.clear()
	for i in range(array_size):
		data.append(randi_range(12,720))
	queue_redraw()

func _draw():
	if data.is_empty():
		print("No value in array")
		return
	var bar_width = float(screen_width) / array_size
	for i in range(data.size()):
		# Calculate X position
		var x_pos = i * bar_width
		# Calculate Height (Value in array)
		var bar_height = data[i] 
		
		# Calculate Y position 
		# (Godot's (0,0) is TOP-LEFT. To draw from bottom-up, 
		# we start at screen_height and subtract the bar_height)
		var y_pos = screen_height - bar_height
		# Define the Rect2(x, y, width, height)
		var rect = Rect2(x_pos, y_pos, bar_width, bar_height)
		# Draw it
		draw_rect(rect, Color.WHITE)
		# Optional: Draw an outline so bars don't look like one giant blob
		draw_rect(rect, Color.BLACK, false, 1.0)

func bubble_sort(data):
	for i in range(array_size):
		var swapped = false
		for j in range(0,array_size-i-1):
			if data[j]>data[j+1]:
				var temp = data[j]
				data[j] = data[j + 1]
				data[j + 1] = temp
				swapped = true
				queue_redraw()
				await get_tree().create_timer(0.01).timeout
		if swapped == false:
			break
