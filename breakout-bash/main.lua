--Audio taken http://www.theallsounds.com/2018/07/ball-bouncing-sound-effects-all-sounds.html
--Images all created from scratch using Photoshop CC 2019
--CBE and prism for the particles:
--https://github.com/GymbylCoding/CBEffects
--https://github.com/GymbylCoding/Prism

local json      = require("json")
local particles = require("particlesModule")
local physics   = require("physics")
physics.start()
physics.setGravity(0,0)

local data = {}
local gameStarted = false
local brick
local startButton
local paddle
local ball
local background
local logo
local audioButton
local mode = "light"
local score = 0
local highScore = 0
local color
local audioOn = true
local modeButton
local redoButton_dark
local brickBeingDestroyed = false

local bounceSound = audio.loadSound("bounceSound.wav")

local velocityX = 5
local velocityY = -5

local leftBorder  = display.screenOriginX
local rightBorder = display.viewableContentWidth + display.screenOriginX
local topBorder   = display.screenOriginY

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup   = display.newGroup()

local background_dark  = {type = "image", filename = "background_dark.png"}
local logo_dark        = {type = "image", filename = "logo_dark.png"}
local brick_dark       = {type = "image", filename = "brick_dark.png"}
local startButton_dark = {type = "image", filename = "start_dark.png"}
local paddle_dark      = {type = "image", filename = "paddle_dark.png"}
local ball_dark        = {type = "image", filename = "ball_dark.png"}
local redoButton_dark  = {type = "image", filename = "redo_dark.png"}
local audio_on_dark    = {type = "image", filename = "audio_on_dark.png"}
local audio_off_dark   = {type = "image", filename = "audio_off_dark.png"}
local modeButton_dark  = {type = "image", filename = "modeButton_dark.png"}

local background_light  = {type = "image", filename = "background_light.png"}
local logo_light        = {type = "image", filename = "logo_light.png"}
local brick_light       = {type = "image", filename = "brick_light.png"}
local startButton_light = {type = "image", filename = "start_light.png"}
local paddle_light      = {type = "image", filename = "paddle_light.png"}
local ball_light        = {type = "image", filename = "ball_light.png"}
local redoButton_light  = {type = "image", filename = "redo_light.png"}
local audio_on_light    = {type = "image", filename = "audio_on_light.png"}
local audio_off_light   = {type = "image", filename = "audio_off_light.png"}
local modeButton_light  = {type = "image", filename = "modeButton_light.png"}

background   = display.newImageRect(backGroup, "background_light.png", 800, 1400)
background.x = display.contentCenterX
background.y = display.contentCenterY

logo   = display.newImageRect(backGroup, "logo_light.png", 337.5, 147)
logo.x = display.contentCenterX
logo.y = display.contentCenterY - 250

brick   = display.newImageRect(mainGroup, "brick_light.png", 64.5, 64.5)
brick.x = math.random(leftBorder + brick.width/2, rightBorder - brick.width/2)
brick.y = math.random(((brick.height/2) + 110), display.contentHeight/1.5)
physics.addBody(brick, "static")
brick.isSensor  = true
brick.myName    = "brick"
brick.isVisible = false

startButton       = display.newImageRect(backGroup, "start_light.png", 800, 1036)
startButton.x     = display.contentCenterX
startButton.y     = display.contentCenterY - 200
startButton.alpha = 0.8
transition.blink(startButton, {time=2500})

paddle = display.newImageRect(mainGroup, "paddle_light.png", 162.75, 25.5)
paddle.x = display.contentCenterX
paddle.y = display.contentHeight - 150
physics.addBody(paddle, "static")
paddle.myName = "paddle"

ball   = display.newImageRect(mainGroup, "ball_light.png", 34.5, 34.5)
ball.x = display.contentCenterX
ball.y = display.contentCenterY + 300
physics.addBody(ball, "dynamic", {density = 1, friction = 0, bounce = 0})
ball.myName = "ball"

audioButton   = display.newImageRect(uiGroup, "audio_on_light.png", 120, 99)
audioButton.x = leftBorder + 60
audioButton.y = display.contentHeight - 75

modeButton   = display.newImageRect(uiGroup, "modeButton_light.png", 76.5, 76.5)
modeButton.x = rightBorder - 60
modeButton.y = display.contentHeight - 75

redoButton   = display.newImageRect(uiGroup, "redo_light.png", 156, 149.25)
redoButton.x = display.contentCenterX
redoButton.y = 1000
redoButton.isVisible = false

scoreText = display.newText(uiGroup, highScore, display.contentCenterX, 80, native.systemFont, 48)
scoreText:setTextColor(0, 0, 0)

bestScoreText = display.newText(uiGroup, "BEST SCORE", display.contentCenterX, 1000, native.systemFont, 36)
bestScoreText:setTextColor(0, 0, 0)
bestScoreText.isVisible = false

highScoreText = display.newText(uiGroup, highScore, display.contentCenterX, 1000, native.systemFont, 72)
highScoreText:setTextColor(0, 0, 0)
highScoreText.isVisible = false

local function lightMode()
    mode = "light"
    background.fill = (background_light)
    logo.fill = (logo_light)
    brick.fill = (brick_light)
    startButton.fill = (startButton_light)
    paddle.fill = (paddle_light)
    ball.fill = (ball_light)
    redoButton.fill = (redoButton_light)
    if audioOn then
        audioButton.fill = (audio_on_light)
    else
        audioButton.fill = (audio_off_light)
    end
    modeButton.fill = (modeButton_light)
    scoreText:setTextColor(0, 0, 0)
    bestScoreText:setTextColor(0, 0, 0)
    highScoreText:setTextColor(0, 0, 0)
end

local function darkMode()
    mode = "dark"
    background.fill = background_dark
    logo.fill = logo_dark
    brick.fill = brick_dark
    startButton.fill = (startButton_dark)
    paddle.fill = (paddle_dark)
    ball.fill = (ball_dark)
    redoButton.fill = (redoButton_dark)
    if audioOn then
        audioButton.fill = (audio_on_dark)
    else
        audioButton.fill = (audio_off_dark)
    end
    modeButton.fill = (modeButton_dark)
    scoreText:setTextColor(0.761, 0.761, 0.761)
    bestScoreText:setTextColor(0.761, 0.761, 0.761)
    highScoreText:setTextColor(0.761, 0.761, 0.761)
end

local function toggleMode()
    if mode == "light" then
        darkMode()
    elseif mode == "dark" then
        lightMode()
    end
end

local function turnOnAudio()
    audioOn = true
    if mode == "light" then
        audioButton.fill = (audio_on_light)
    else
        audioButton.fill = (audio_on_dark)
    end
end

local function turnOffAudio()
    audioOn = false
    if mode == "light" then
        audioButton.fill = (audio_off_light)
    else
        audioButton.fill = (audio_off_dark)
    end
end

local function toggleAudio()
    if audioOn then
        turnOffAudio()
    else
        turnOnAudio()
    end
end

local function playSound()
    if audioOn then
        audio.play(bounceSound)
    end
end



local function dragPaddle(event)
    local paddle = event.target
    local phase  = event.phase


    if phase == "began" then
        display.currentStage:setFocus(paddle)
        paddle.touchOffsetX = event.x - paddle.x
    end

    if phase == "moved" then
        if not paddle.touchOffsetX then return end --stops bug
        paddle.x = event.x - paddle.touchOffsetX
    end

    if phase == "ended" or phase == "cancelled" then
        display.currentStage:setFocus(nil)
    end

    if (paddle.x - paddle.width/2 < leftBorder) then
        paddle.x =  leftBorder + paddle.width/2
    elseif(paddle.x + paddle.width/2 > rightBorder) then
        paddle.x = rightBorder - paddle.width/2
    end

    return true
end

local function updateBall()
    particles.Trail(ball.x, ball.y, color)

    ball.x = ball.x + velocityX
    ball.y = ball.y + velocityY

    if (ball.x - ball.width/2) < leftBorder or (ball.x + ball.width/2) > rightBorder then
        velocityX = -velocityX
        playSound()
    end

    if ball.y < 0 then
        velocityY = -velocityY
        playSound()
    end
    if (ball.y > display.contentHeight - 100) then
        endGame()
    end
end

local function bounce(event)
    if event.phase == "began" then
        if velocityY > 0 then
            velocityY = -velocityY
        end
        if (ball.x + ball.width * 0.5) < paddle.x then
            velocityX = -velocityX
        elseif (ball.x + ball.width * 0.5) >= paddle.x then
            velocityX = velocityX
        end
        playSound()
    end
end

local function brickBounce(event)
    if event.phase == "began" then
        if brickBeingDestroyed == false then
            velocityY = -velocityY
            velocityX = -velocityX
            playSound()
        end
    end
end

local function createBrick(event)
    if event.phase == "began" then
        if brickBeingDestroyed == false then
            brickBeingDestroyed = true
            transition.to(brick, {time = 250, alpha = 0, xScale = 0.01, yScale=0.01})
            transition.to(brick, {time = 250, alpha = 1, xScale = 1, yScale=1, delay = 500,
            onComplete = function()
                brickBeingDestroyed = false
            end})

            if mode == "light" then
                color = {0, 0, 0}
            else
                color = {0.761, 0.761, 0.761}
            end
            particles.Explosion(brick.x, brick.y, color)

            transition.to(brick, {
                x = math.random(leftBorder + brick.width/2, rightBorder - brick.width/2) ,
                y = math.random(((brick.height/2) + 100), display.contentHeight/1.5),
            time = 0, delay = 250})

            score          = score + 1
            scoreText.text = score

        end
    end
end

local function quickenBall()
    print(velocityY)
    print(velocityX)

    if velocityY > 15 or velocityY < -15 then return end
    if velocityX > 0 then
        velocityX = velocityX + 0.05
    else
        velocityX = velocityX - 0.05
    end

    if velocityY > 0 then
        velocityY = velocityY + 0.05
    else
        velocityY = velocityY - 0.05
    end
end

local function goToMenu()
    brick.isVisible         = false
    logo.isVisible          = true
    startButton.isVisible   = true
    bestScoreText.isVisible = false
    highScoreText.isVisible = false
    redoButton.isVisible    = false
    audioButton.isVisible   = true
    modeButton.isVisible    = true

    transition.to(paddle, {time = 0, alpha = 1, xScale = 1, yScale = 1})
    transition.to(ball,   {time = 0, alpha = 1, xScale = 1, yScale = 1})
    transition.to(brick,  {time = 0, alpha = 1, xScale = 1, yScale = 1})

    paddle.x = display.contentCenterX
    paddle.y = display.contentHeight - 150
    ball.x   = display.contentCenterX
    ball.y   = display.contentCenterY + 200

    velocityX = 5
    velocityY = -5

    scoreText.text = highScore
end

function startGame()
    physics.start()
    brick.isVisible       = true
    logo.isVisible        = false
    startButton.isVisible = false
    audioButton.isVisible = false
    modeButton.isVisible  = false
    if gameStarted == false then
        timer.performWithDelay(500, quickenBall, 0)
        gameStarted = true
    end
    paddle:addEventListener("touch", dragPaddle)
    paddle:addEventListener("collision", bounce)
    brick:addEventListener("collision", brickBounce)
    Runtime:addEventListener("enterFrame", updateBall)
    brick:addEventListener("collision", createBrick)

    score = 0
    scoreText.text = 0
end

function endGame()
    physics.pause()
    paddle:removeEventListener("touch", dragPaddle)
    Runtime:removeEventListener("enterFrame", updateBall)
    brick:removeEventListener("collision", brickBounce) --handles dragging the paddle
    paddle:removeEventListener("collision", bounce) --makes ball bounce when collides with paddle
    brick:removeEventListener("collision", createBrick)

    transition.to(paddle, {time = 250, alpha = 0, xScale = 0.01, yScale = 0.01})
    transition.to(ball,   {time = 250, alpha = 0, xScale = 0.01, yScale = 0.01})
    transition.to(brick,  {time = 250, alpha = 0, xScale = 0.01, yScale = 0.01})

    if score > highScore then
        highScore  = score
    end

    bestScoreText.isVisible = true
    bestScoreText.Y         = 1000

    highScoreText.isVisible = true
    highScoreText.Y         = 1000
    highScoreText.text      = highScore

    redoButton.isVisible = true
    redoButton.y         = 1000

    transition.moveTo(bestScoreText, {x = display.contentCenterX, y = 300, time = 250, transition = easing.outQuad})
    transition.moveTo(highScoreText, {x = display.contentCenterX, y = 360, time = 250, transition = easing.outQuad})
    transition.moveTo(redoButton,    {x = display.contentCenterX, y = display.contentCenterY + 100, time = 250, transition = easing.outQuad})

    display.currentStage:setFocus(nil)
end

local function loadData()
    local path              = system.pathForFile("data.json", system.DocumentsDirectory)
    local file, errorString = io.open(path, "r")

    if file then
        local contents = file:read("*a")
        io.close(file)
        data           = json.decode(contents)
        highScore      = data[1]
        audioOn        = data[2]
        mode           = data[3]
        scoreText.text = highScore
        if audioOn == false then
            turnOffAudio()
        end
        if mode == "dark" then
            darkMode()
        end
    end

    file = nil
end


local function saveData()
    local path = system.pathForFile("data.json", system.DocumentsDirectory)

        local file = io.open(path, "w")

        if file then
            data = {highScore, audioOn, mode}
            file:write(json.encode(data))
            io.close(file)
        end
end

local function onSystemEvent(event)
    local eventType = event.type

    if eventType == "applicationStart" then
        loadData()
    elseif eventType == "applicationExit" then
        saveData()
    end
end

Runtime:addEventListener("system", onSystemEvent)

startButton:addEventListener("tap", startGame)
modeButton:addEventListener("tap", toggleMode)
audioButton:addEventListener("tap", toggleAudio)
redoButton:addEventListener("tap", goToMenu)
Runtime:addEventListener("applicationStart", loadData)
Runtime:addEventListener("applicationExit", saveData)
