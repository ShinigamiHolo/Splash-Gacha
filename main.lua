
local width = 800
local height = 600

local groups = {
    {
        -- GREY
        color = {128, 128, 128},
        texts = {
            "Infinite Levels!",
            "Everything Is Stackable*!",
            "Nothing to see here",
            "Heavy RoR2 Influence!",
            "Now with 33% More Salt!",
            "Magnificent!",
            "That’s Crazy!",
            "Happy Pride Month!",
            "Always Prideful Here!",
            "2+2 is Not Magikarp",
            "It’s Only Unfair When I Lose!",
            "What’s Your Favorite?",
            "Ask Your Doctor if PokéRogue is Right For You.",
            "Born to be a Winner!",
            "On a Rollout!",
            "Meta Not Included!",
            "We Hope To See You Again!",
            "Also Try Showering!",
            "We’ll Still Be Here When You Get Back!",
            "A Healthy Team Can Mean Greater Rewards!",
            "Never Give Up!",
            "1, 2, And… Poof!",
            "Also Try PokeDoku!",
            "Time for Your Deli-Delivery!",
            "Number 591 Is Looking a Bit…",
        }
    },

    {
        -- White
        color = {255, 255, 255},
        texts = {
            "Happy Holidays!",
            "Delibird Season!",
            "Unaffiliated With Delibird Services!",
            "Diamonds From the Sky!",
            "Holiday Style Pikachu Not Included!",
            "Delibird Directly To Your House!",
            "Have An Ice Day!",
            "Spin The Claydol!",
            "Be Good, For Goodness Sake!",
            "Moomoo Milk And Lava Cookies!",
            "I Need a Yache Berry…",
            "Get Jolly!",
            "’Tis The Season To Be +Speed -Special Attack!",
            "Deck The Halls!",
            "Save Scumming Gets You On The Naughty List!",
            "Bad Trainers Get Rolycoly!"
        }
    },

    {
        -- GREEN
        color = {0, 128, 0},
        texts = {
            ">1 Battles Won!",
            "April Fools!",
            "GOTCHA!",
            "Never Gonna Give You Good Rolls!",
            "You Bumbling Buffoon!",
            "Now With Z-Moves!",
        }
    },

    {
        -- BLUE
        color = {0, 0, 128},
        texts = {
            "Happy Valentines!",
            "Full of Love!",
            "An Applin for You?",
            "The Power Of Love Is 330 BST!",
            "Have a Heart Scale!",
            "I <3 You!"
        }
    },

    {
        -- PURPLE
        color = {128, 0, 128},
        texts = {
            "Happy Halloween!",
            "BOO!",
            "Pumpkaboo About!",
            "May Contain Spiders!",
            "Spooky, Scary Skeledirge!",
            "Gourgeist Used Trick-or-Treat!",
            "Let’s Snuggle Forever!"
        }
    },

    {
        -- GOLD
        color = {255, 255, 0},
        texts = {
            "W Event",
            "Happy New Year!",
            "… And a Happy New Year!"
        }
    }
}

-- VARIABLES

local entries = {}

local font
local smallFont

local position = 0
local spinning = false

local startPosition = 0
local targetPosition = 0

local spinTimer = 0
local spinDuration = 3.5

local resultText = "Result is..."
local resultColor = {255, 255, 255}

local spacing = 55

local indexOpen = false

-- LOAD

function love.load()
    love.window.setTitle("Splash Gacha")
    love.window.setMode(width, height)

    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    font = love.graphics.newFont(24)
    smallFont = love.graphics.newFont(16)

    for _, group in ipairs(groups) do
        for _, text in ipairs(group.texts) do
            table.insert(entries, {
                text = text,
                color = group.color,
                discovered = false
            })
        end
    end

    for i = #entries, 2, -1 do
        local j = love.math.random(i)
        entries[i], entries[j] = entries[j], entries[i]
    end
end

-- START SPIN

local function startSpin()
    if spinning or #entries == 0 then
        return
    end

    spinning = true
    spinTimer = 0

    startPosition = position

    local count = #entries

    local randomIndex = love.math.random(0, count - 1)

    local rotations = love.math.random(5, 8)

    local target = math.floor(position / count) * count
        + randomIndex

    while target <= position do
        target = target + count
    end

    targetPosition = target + (rotations - 1) * count

    resultText = "Spinning..."
    resultColor = {255, 255, 255}
end

-- INPUT

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "space" then
        startSpin()
    end

    if key == "i" then
        indexOpen = not indexOpen
    end
end

-- UPDATE ANIMATION

function love.update(dt)
    if not spinning then
        return
    end

    spinTimer = spinTimer + dt

    local progress = math.min(spinTimer / spinDuration, 1)

    local eased = progress * progress * (3 - 2 * progress)

    position = startPosition
        + (targetPosition - startPosition) * eased

    if progress >= 1 then
        position = targetPosition
        spinning = false

        local index = (math.floor(position + 0.5) % #entries) + 1
        local winner = entries[index]

        resultText = winner.text
        resultColor = winner.color

        winner.discovered = true
    end
end

-- DRAW

function love.draw()
    local function fnts(r, g, b, a)
        return love.math.colorFromBytes(r, g, b, a or 255)
    end

    love.graphics.setColor(fnts(108, 108, 108))
    love.graphics.rectangle(
        "fill",
        width * 1 / 5, 0,
        width * 4 / 5, height / 5
    )

    love.graphics.setColor(fnts(128, 128, 128))
    love.graphics.rectangle(
        "fill",
        width * 1 / 5, height * 4 / 5,
        width * 4 / 5, height / 5
    )

    love.graphics.setColor(fnts(96, 96, 96))
    love.graphics.rectangle(
        "fill",
        0, 0,
        width / 5, height
    )

    love.graphics.rectangle(
        "fill",
        width * 4 / 5, 0,
        width / 5, height
    )

    -- REEL SCREEN

    local screenX = width / 5
    local screenY = height / 5
    local screenW = width * 3 / 5
    local screenH = height * 3 / 5

    local centerX = screenX + screenW / 2
    local centerY = screenY + screenH / 2

    love.graphics.setColor(0.08, 0.08, 0.08)
    love.graphics.rectangle(
        "fill",
        screenX, screenY,
        screenW, screenH
    )

    -- Highlight the center slot.
    love.graphics.setColor(1, 1, 1, 0.12)
    love.graphics.rectangle(
        "fill",
        screenX,
        centerY - spacing / 2,
        screenW,
        spacing
    )

    love.graphics.setScissor(
        screenX, screenY,
        screenW, screenH
    )

    love.graphics.setFont(font)

    if #entries > 0 then
        local base = math.floor(position)
        local fraction = position - base

        for row = -6, 6 do
            local absoluteIndex = base - row
            local index = (absoluteIndex % #entries) + 1

            local entry = entries[index]

            local y = centerY + (row + fraction) * spacing

            local distance = math.abs(y - centerY) / spacing
            local scale = math.max(0.7, 1.3 - distance * 0.15)

            love.graphics.setColor(fnts(
                entry.color[1],
                entry.color[2],
                entry.color[3]
            ))

            -- Calculate actual scaled dimensions
            local textW = font:getWidth(entry.text) * scale
            local textH = font:getHeight() * scale

            -- Center every individual text
            love.graphics.print(
                entry.text,
                centerX - textW / 2,
                y - textH / 2,
                0,
                scale,
                scale
            )
        end
    end

    love.graphics.setScissor()

    -- Screen border.
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle(
        "line",
        screenX, screenY,
        screenW, screenH
    )

    -- RESULT TEXT

    love.graphics.setFont(smallFont)

    love.graphics.setColor(fnts(
        resultColor[1],
        resultColor[2],
        resultColor[3]
    ))

    -- INSTRUCTIONS


    love.graphics.setFont(smallFont)
    love.graphics.setColor(1, 1, 1)

    local instruction = spinning
        and "SPINNING..."
        or "PRESS SPACE TO SPIN"

    love.graphics.printf(
        instruction,
        0,
        height - 25,
        width,
        "center"
    )


    -- COLLECTION INDEX

    love.graphics.setFont(smallFont)
    love.graphics.setColor(1, 1, 1)

    local indexInstruction = "Press I to view the collection index"

    love.graphics.printf(
        indexInstruction,
        0,
        height - 50,
        width,
        "center"
    )

    if indexOpen then

        love.graphics.setColor(0.05, 0.05, 0.05, 0.96)
        love.graphics.rectangle("fill", 0, 0, width, height)

        love.graphics.setFont(font)
        love.graphics.setColor(1, 1, 1)

        local discoveredCount = 0

        for _, entry in ipairs(entries) do
            if entry.discovered then
                discoveredCount = discoveredCount + 1
            end
        end

        love.graphics.printf(
            "SPLASH TEXT INDEX",
            0, 25, width, "center"
        )

        love.graphics.printf(
            discoveredCount .. " / " .. #entries .. " discovered",
            0, 65, width, "center"
        )

        love.graphics.setFont(smallFont)

        local foundIndex = 0

        for _, entry in ipairs(entries) do

            if entry.discovered then
                foundIndex = foundIndex + 1

                local col = (foundIndex - 1) % 2
                local row = math.floor((foundIndex - 1) / 2)

                local x = 30 + col * 390
                local y = 115 + row * 42

                love.graphics.setColor(fnts(
                    entry.color[1],
                    entry.color[2],
                    entry.color[3]
                ))

                love.graphics.print(
                    "[X] " .. entry.text,
                    x, y
                )
            end
        end

        love.graphics.setColor(1, 1, 1)

        love.graphics.printf(
            "Press I to close",
            0, height - 35, width, "center"
        )

    end
end
