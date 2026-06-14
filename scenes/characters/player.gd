extends CharacterBody2D

var direction:Vector2
var last_dir:Vector2
var speed:=70
var can_move:= true
@onready var move_state_machine = $Animation/AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine = $Animation/AnimationTree.get("parameters/ToolStateMachine/playback")
var current_tool: Enum.Tool = Enum.Tool.HOE  
var current_seed: Enum.Seed  
signal tool_use(tool:Enum.Tool,pos:Vector2)


func _physics_process(_delta: float) -> void:
	if can_move:
		move()
		animate()
		basic_input_ani()
	if direction:
		last_dir=direction
	
func basic_input_ani():
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
		var dir = Input.get_axis("tool_backward","tool_forward")
		current_tool = posmod((current_tool + int(dir)), Enum.Tool.size()) as Enum.Tool
	if Input.is_action_just_pressed("seed_forward"):
		current_seed = posmod(current_seed + 1, Enum.Seed.size()) as Enum.Seed
		print(current_seed)
		
	if Input.is_action_just_pressed("action"):
		tool_state_machine.travel(Data.TOOL_STATE_ANIMATIONS[current_tool])
		$Animation/AnimationTree.set("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func move():
	direction=Input.get_vector("left","right","up","down")
	velocity=direction*speed
	move_and_slide()
	
func animate():
	if direction:
		move_state_machine.travel("Walk")
		var ani_dir = Vector2(round(direction.x),round(direction.y))
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position",ani_dir)
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position",ani_dir)
		for animation in Data.TOOL_STATE_ANIMATIONS.values():
			var animations_sel : String =  "parameters/ToolStateMachine/"+ animation +"/blend_position"
			$Animation/AnimationTree.set(animations_sel,ani_dir)		
	else:
		move_state_machine.travel("Idle")
	
	
func tool_use_emit():
	tool_use.emit(current_tool,position + last_dir * 16 + Vector2(0,4.13))


func _on_animation_tree_animation_started(_anim_name: StringName) -> void:
	can_move = false


func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	can_move = true
