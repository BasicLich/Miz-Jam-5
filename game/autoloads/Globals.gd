extends Node

signal bullet_hit(bullet, collision_information)

signal tree_burned(tree)

# Statistics
var fires_put_out: int = 0
var play_time: float = 0.0
var trees_planted: int = 0
var trees_burned: int = 0
