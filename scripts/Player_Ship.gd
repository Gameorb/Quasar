extends RigidBody2D

export (int) var engine_thrust
export (int) var spin_thrust
export (PackedScene) var bullet
onready var bullet_container = get_node("bullet_container")
onready var gun_timer = get_node("gun_timer")

var thrust = Vector2()
var rotation_dir = 0
var vel = Vector2()

func get_input():
	if Input.is_action_pressed("ui_up"):
		thrust = Vector2(engine_thrust, 0)
	else:
		thrust = Vector2()
	rotation_dir = 0
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1
		
func _process(delta):
	get_input()
	if Input.is_action_pressed("ui_accept"):
		if gun_timer.get_time_left() == 0:
			shoot()
	vel += thrust * delta

func _integrate_forces(state):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(rotation_dir * spin_thrust)
	
func shoot():
	gun_timer.start()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(get_rot(), get_node("muzzle").get_global_pos(), vel)
