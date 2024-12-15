local M = {}

M.dtn_pong = 1.85
M.dtn_fade = 0.5
M.dtn_fall = 0.4
M.dtn_create = 0.25
M.dtn_pressed = 0.128

M.start = hash("start")
M.game = hash("game")
M.over = hash("over")
M.help = hash("help")
M.settings = hash("settings")
M.fade_in = hash("fade_in")
M.fade_out = hash("fade_out")
M.scale_in = hash("scale_in")
M.scale_out = hash("scale_out")
M.touch = hash("touch")
M.delete = hash("delete")
M.reset = hash("reset")
M.link = hash("link")
M.unlink = hash("unlink")
M.levelup = hash("levelup")
M.update_score = hash("set_score")
M.set_preview = hash("set_preview")

M.scl_button = vmath.vector3(1.12, 1.12, 1)
M.scl_unit = vmath.vector3(1)
M.scl_pong = vmath.vector3(0.85, 0.85, 1)
M.scl_zero = vmath.vector3()

M.proj = vmath.matrix4()
M.width = 540
M.height = 960

M.save_file = "blockscubes2048_main_saveload"
M.score = (sys.load(sys.get_save_file(M.save_file, "score"))).score or 0
M.best = (sys.load(sys.get_save_file(M.save_file, "best"))).best or 0
M.volume = (sys.load(sys.get_save_file(M.save_file, "volume"))).volume or 1

function M.delay_input_focus(duration)
	timer.delay(duration, false, function()
		msg.post(".", "acquire_input_focus")
	end)
end

function M.screen_to_world(screen)
	local inv = vmath.inv(M.proj)
	screen.x = (2 * screen.x / M.width) - 1
	screen.y = (2 * screen.y / M.height) - 1
	screen.z = (2 * screen.z) - 1
	local x = screen.x * inv.m00 + screen.y * inv.m01 + screen.z * inv.m02 + inv.m03
	local y = screen.x * inv.m10 + screen.y * inv.m11 + screen.z * inv.m12 + inv.m13
	local z = screen.x * inv.m20 + screen.y * inv.m21 + screen.z * inv.m22 + inv.m23
	screen.x = x
	screen.y = y
	screen.z = z
	return screen
end

function M.go_animate_alpha(url, playback, to, duration)
	go.cancel_animations(url, "tint.w")
	go.animate(url, "tint.w", playback, to, go.EASING_LINEAR, duration)
end

function M.gui_animate_scale(node, to, duration, playback)
	gui.cancel_animation(node, "scale")
	gui.animate(node, "scale", to, gui.EASING_INOUTSINE, duration, 0, nil, playback)
end

function M.gui_animate_alpha(node, to)
	gui.cancel_animation(node, "color.w")
	gui.animate(node, "color.w", to, gui.EASING_LINEAR, M.dtn_fade)
end

function M.gui_pressed(node, scale)
	msg.post(".", "release_input_focus")
	M.gui_animate_scale(node, scale, M.dtn_create, gui.PLAYBACK_ONCE_PINGPONG)
	sound.play("/main#sound-press", {gain = M.volume})
end

function M.gui_switch(name)
	msg.post(".", M.fade_out)
	timer.delay(M.dtn_fade, false, function()
		msg.post("/main#main", name)
	end)
end

return M
