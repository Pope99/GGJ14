-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local controller =  require("Objects.UI.controller")
local player =  require("Objects.player.player")
local buffEffectMod = require("buffEffect")
local eventCentralMOD =  require("eventCentral")
local map = require("Objects.map.map")
local eventCentral = eventCentralMOD.new()
local buffEffect = buffEffectMod.new()
eventCentral:start( )
-- include Corona's "physics" library
local physics = require "physics"
local testElement = require "Objects.item.element"
physics.start(); physics.pause()

physics.setGravity( 0, 0 )

system.activate("multitouch")

local trap =  require("Objects.item.trap")
--------------------------------------------
-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view


	
	playerA = player.new({x=360,y=200,direction={x=0,y=150}, path ="image/playerA_set.png"})
	playerB = player.new({x=360,y=1080,direction={x=0,y=-150}, path = "image/playerB_set.png"})
	controllA = controller.new({y=62,player = playerA, rotate = 180})
	controllB = controller.new({y=display.contentHeight-62,player = playerB,rotate = 0})

	local elementDeploy = require "elementDeploy"
	elementGroup = elementDeploy.initDeploy()

	


	-- create a grey rectangle as the backdrop
	local background = display.newImage( "gd2.png", screenW/2, screenH/2 , true)
	local mapA = map.new()
	
	-- make a crate (off-screen), position it, and rotate slightly
	
	-- all display objects must be inserted into group

	group:insert(mapA.image)

	group:insert( background )
	
	group:insert( controllA.image )
	group:insert( controllB.image )
	group:insert( elementGroup )
	group:insert( playerA.image )
	group:insert( playerB.image )

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	physics.start()
		freeChannel = 	freeChannel+1
	local battleSong = audio.loadSound("battleSong.mp3")
	audio.play(battleSong , {channel = freeChannel , fadein = 1000,volume =0 })
	print(freeChannel)
	--audio.stop({channel = 1})

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )

	local group = self.view
	audio.fadeOut({channel = freeChannel , time = 1000 })

	physics.stop()
	storyboard.removeScene( storyboard.getPrevious() )
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	package.loaded[physics] = nil
	physics = nil
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene