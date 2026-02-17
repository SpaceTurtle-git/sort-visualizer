extends Node2D

var data = []
var array_size = 100

var active_bar = -1
var next_active_bar = -1
var sorted_count = 0

var sorted_bars = []

@onready var screen_width = get_viewport_rect().size.x
@onready var screen_height = get_viewport_rect().size.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generateArray()
	print(data)
	call_quick_sort()
	print (data)
	#await bubble_sort(data)
	#print(data)

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
		var bar_height = data[i]  # Calculate Height (Value in array)
		
		var x_pos = i * bar_width 
		var y_pos = screen_height - bar_height  #Godot's (0,0) is TOP-LEFT. 
		
		# Define the Rect2(x, y, width, height)
		var rect = Rect2(x_pos, y_pos, bar_width, bar_height)
		
		# --- COLOR LOGIC ---
		var bar_color = Color.WHITE
		if i in sorted_bars:
			bar_color = Color.GREEN_YELLOW
		if i >= array_size - sorted_count:
			bar_color = Color.GREEN_YELLOW
		if i == active_bar or i == next_active_bar:
			bar_color = Color.RED # The bars currently being compared/moved
		
		draw_rect(rect, bar_color)
		draw_rect(rect, Color.BLACK, false, 1.0)

func swap(arr,i,j):
	var temp = arr[j]
	arr[j] = arr[i]
	arr[i] = temp

func bubble_sort(data):
	for i in range(array_size):
		var swapped = false
		for j in range(0,array_size-i-1):
			active_bar = j
			next_active_bar = j + 1
			if data[j]>data[j+1]:
				swap(data,j,j+1)
				swapped = true
				queue_redraw()
				await get_tree().create_timer(0.01).timeout
		sorted_count +=1
		queue_redraw()
		if swapped == false:
			break
	active_bar = -1
	next_active_bar = -1

func quick_sort(data,low,high):
	if low < high:
		var pivot = data[high]
		var i = low -1
		for j in range (low,high):
			if data[j] < pivot:
				i+=1
				active_bar = j
				next_active_bar = i
				swap(data,i,j)
				queue_redraw()
				await get_tree().create_timer(0.01).timeout
		swap(data,i+1,high)
		var pi = i+1
		sorted_bars.append(pi)
		await get_tree().create_timer(0.01).timeout
		queue_redraw()
		await quick_sort(data,low,pi-1)
		await quick_sort(data,pi+1,high)

func victory_sweep():
	for i in range(array_size):
		if i not in sorted_bars:
			sorted_bars.append(i)
	queue_redraw()
	
func call_quick_sort():
	await quick_sort(data,0,array_size-1)
	victory_sweep()
