extends Node2D

@onready var ui_layer = $CanvasLayer

var data = []
var array_size = 5
var speed = 1:
	set(value):
		speed = value
		tick_speed = 1/speed
var tick_speed = speed 

var active_bar = -1
var next_active_bar = -1
var sorted_count = 0

var sorted_bars = []

var is_paused = false
var to_reset = false

enum SortType { BUBBLE, QUICK, SELECTION }
var current_sort_type = SortType.BUBBLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_layer.algorithm_changed.connect(_on_algorithm_selected)
	
	generateArray()
	run_sorter()

func check_if_paused():
	while is_paused:
		await get_tree().process_frame

func reset():
	sorted_count = 0
	sorted_bars.clear()
	active_bar = -1
	next_active_bar = -1
	to_reset = false
	generateArray()

func generateArray():
	data.clear()
	for i in range(array_size):
		data.append(randf_range(0.1,1.0))
	queue_redraw()

func run_sorter():
	while true:
		# 1. Reset visual state before every sort
		reset()
		
		# 2. Run the chosen algorithm
		match current_sort_type:
			SortType.BUBBLE:
				await bubble_sort(data) 
			SortType.QUICK:
				await call_quick_sort() 
			SortType.SELECTION:
				await selection_sort(data)
		
		# 3. The "Idle" State
		# After a sort finishes, we stay here until the user clicks 'Reset'
		# or changes the algorithm (which sets to_reset = true)
		print("Sort finished. Waiting for reset...")
		while not to_reset:
			await get_tree().process_frame 

func _draw():
	var screen_width = get_viewport_rect().size.x
	var screen_height = get_viewport_rect().size.y
	
	if data.is_empty():
		print("No value in array")
		return
		
	for i in range(data.size()):
		var bar_height = data[i] * screen_height  # Calculate Height (Value in array)
		var bar_width = float(screen_width) / array_size
		
		var x_pos = i * bar_width 
		var y_pos = screen_height - bar_height  #Godot's (0,0) is TOP-LEFT. 
		
		# Define the Rect2(x, y, width, height)
		var rect = Rect2(x_pos, y_pos, bar_width, bar_height)
		
		# --- COLOR LOGIC ---
		var bar_color = Color.WHITE
		if i in sorted_bars:
			bar_color = Color.GREEN_YELLOW
		if i >= array_size - sorted_count:  #bubble sort exclusive
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
			
			await check_if_paused()
			if to_reset == true:
				return
			
			if data[j]>data[j+1]:
				swap(data,j,j+1)
				swapped = true
				queue_redraw()
				await get_tree().create_timer(tick_speed).timeout
		sorted_count +=1
		queue_redraw()
		if swapped == false:
			break
	victory_sweep()

func quick_sort(data,low,high):
	if low < high:
		var pivot = data[high]
		var i = low -1
		for j in range (low,high):
			if data[j] < pivot:
				i+=1
				active_bar = j
				next_active_bar = i
				
				await check_if_paused()
				
				swap(data,i,j)
				queue_redraw()
				await get_tree().create_timer(tick_speed).timeout
		swap(data,i+1,high)
		var pi = i+1
		sorted_bars.append(pi)
		await get_tree().create_timer(tick_speed).timeout
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

func selection_sort(arr):
	for i in range(array_size):
		var min_idx = i
		for j in range(i + 1, array_size):
			active_bar = j
			next_active_bar = min_idx
			
			if to_reset: 
				return 
			await check_if_paused()
			
			if arr[j] < arr[min_idx]:
				min_idx = j
			
			queue_redraw()
			await get_tree().create_timer(tick_speed).timeout 
			
		swap(arr, min_idx, i)
		sorted_count += 1 # Update visual "green" bars

#SIGNALS \\\\\\\\\\\
func _on_algorithm_selected(index: int):
	# This function runs automatically when the signal is emitted
	current_sort_type = index as SortType 
	to_reset = true # This breaks the current 'await' loop to restart
	print("Main: Algorithm changed to: ", current_sort_type)
