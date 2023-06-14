extends RefCounted
class_name Timing

var time: int
var type: int

func _init(_type := 1): # 1: ms, 0: us
	type = _type

func start():
	time = Time.get_ticks_msec() if type else Time.get_ticks_usec()

func check() -> int:
	var t := (Time.get_ticks_msec() if type else Time.get_ticks_usec()) - time
	start()
	return t
