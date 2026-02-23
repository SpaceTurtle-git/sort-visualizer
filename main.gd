extends Node2D

@onready var ui_layer = $CanvasLayer

var data = []
var array_size = 5
var speed = 1:
	set(value):
		speed = value
		tick_speed = 1/speed
var tick_speed = 0.01 

var active_bar = -1
var next_active_bar = -1
var sorted_count = 0

var sorted_bars = []
var bars_in_buckets = []

var is_paused = false
var to_reset = false

enum SortType { BUBBLE, QUICK, SELECTION, INSERTION, SHELL, BOGO ,MIRACLE ,STALIN ,RADIX}
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
			SortType.INSERTION:
				await insertion_sort(data)
			SortType.SHELL:
				await shell_sort(data)
			SortType.BOGO:
				await bogo_sort(data)
			SortType.MIRACLE:
				await miracle_sort(data)
			SortType.STALIN:
				await  stalin_sort(data)
			SortType.RADIX:
				await  radix_sort(data)
		
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
		if i in bars_in_buckets:
			bar_color = Color.RED
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
		sorted_bars.append(array_size-i-1)
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
		sorted_bars.append(i)
	victory_sweep()

func insertion_sort(arr):
	for i in range(1, array_size):
		var key = arr[i]
		var j = i - 1
		
		# Highlight the bar we are currently trying to place
		active_bar = i
		
		while j >= 0 and arr[j] > key:
			next_active_bar = j
			
			if to_reset:
				return
			await check_if_paused()
			
			# Shift the bar over
			arr[j + 1] = arr[j]
			j -= 1
			
			queue_redraw()
			await get_tree().create_timer(tick_speed).timeout
			
		# Place the bar in its final home for this pass
		arr[j + 1] = key
		
		sorted_bars.append(i) 
		queue_redraw()
	victory_sweep()

func shell_sort(arr):
	var gap = array_size / 2
	
	while gap > 0:
		for i in range(gap, array_size):
			if to_reset: return
			
			var temp = arr[i]
			var j = i
			
			active_bar = i
			next_active_bar = j - gap
			
			await check_if_paused()
			
			while j >= gap and arr[j - gap] > temp:
				if to_reset: return
				
				arr[j] = arr[j - gap]
				j -= gap
				
				queue_redraw()
				await get_tree().create_timer(tick_speed).timeout
			
			arr[j] = temp
			queue_redraw()
			
		gap /= 2
	
	victory_sweep()

func bogo_sort(arr):
	while not is_array_sorted(arr):
		for i in range(array_size):
			
			if to_reset:return
			await check_if_paused()
			
			var target = randi() % array_size #rand int from 0 to array size
			swap(arr, i, target)
			
			active_bar = i
			next_active_bar = target
			
			queue_redraw()
			
			await get_tree().create_timer(tick_speed).timeout

func is_array_sorted(arr):
	for i in range(array_size - 1):
		if arr[i]>arr[i+1]:
			return false
	return true

func miracle_sort(arr):
	for i in range (array_size):
		active_bar = i
			
		await get_tree().create_timer(tick_speed).timeout
		if to_reset: return
		await check_if_paused()
		queue_redraw()
	
	if is_array_sorted(arr):
		victory_sweep()

func stalin_sort(arr):
	var arr_min = arr[0]
	for i in range(array_size):
		if to_reset: return
		await check_if_paused()
		if arr[i] < arr_min:
			arr[i] = 0
		else:
			arr_min = arr[i]
		await get_tree().create_timer(tick_speed).timeout
		queue_redraw()
	victory_sweep()

func radix_sort(arr):
	var max_val = 0
	for val in arr:
		max_val = max(max_val, int(val * 100))
	
	var exp = 1
	while max_val / exp > 0:
		if to_reset: return
		
		# 1. THE BUCKET PHASE (Internal logic)
		var buckets = [[], [], [], [], [], [], [], [], [], []]
		for i in range(array_size):
			var digit = int((arr[i] * 100) / exp) % 10
			buckets[digit].append(arr[i])
			
		# 2. THE COLLECTION PHASE (The Visual Polish)
		var write_ptr = 0
		for digit_value in range(10): 
			if to_reset: return
			
			# --- THE FIX: HIGHLIGHT ALL BARS MATCHING THIS DIGIT ---
			bars_in_buckets.clear()
			for i in range(array_size):
				var d = int((arr[i] * 100) / exp) % 10
				if d == digit_value:
					bars_in_buckets.append(i)
			
			# Briefly show the group we're about to collect
			if not bars_in_buckets.is_empty():
				queue_redraw()
				await get_tree().create_timer(tick_speed * 2).timeout 

			# Move them into position
			for val in buckets[digit_value]:
				if to_reset: return
				await check_if_paused()
				
				arr[write_ptr] = val
				active_bar = write_ptr
				
				# Update visual to show the bar has been "moved"
				queue_redraw()
				write_ptr += 1
				await get_tree().create_timer(tick_speed).timeout
				
		exp *= 10
	
	bars_in_buckets.clear()
	active_bar = -1
	victory_sweep()
	
#SIGNALS \\\\\\\\\\\
func _on_algorithm_selected(index: int):
	# This function runs automatically when the signal is emitted
	current_sort_type = index as SortType 
	to_reset = true # This breaks the current 'await' loop to restart
	print("Main: Algorithm changed to: ", current_sort_type)
