---@class Other_Player : Character
---@overload fun(...) : Other_Player
local Other_Player, super = Class(Character)

local PlayerPlatformState = libRequire("featherfall", "scripts.world.states.Other_PlayerPlatformState")

function Other_Player:init(chara, x, y, name, uuid)
    super.init(self, chara, x, y)
    self.name = name
    self.targetX = x
    self.targetY = y
    self.uuid = uuid
    self.facing = "down"

    self.alpha = 0
    self.fadingOut = false
    self.nametag = UserNametag(self, self.name)
    self:addChild(self.nametag)

    self.state_manager = StateManager("WALK", self, true)

    self.platform_state = PlayerPlatformState(self)
    self.state_manager:addState("FEATHERFALL", self.platform_state)
    self.platform_action_target_event = true
    self.platform_action_target = true
    self.action_kind = "all"
end

function Other_Player:getActionPlatformState()
    if not self.platform_action_target then
        return
    end
    for _, follower in ipairs(Game.world and Game.world.followers or {}) do
        local state = follower.platform_state
        if state
            and state.action_platform_target == self
            and (state.action_platform_mode or 0) > 0
        then
            return state
        end
    end
end

function Other_Player:cancelFollowerTweens() --cheat
end

function Other_Player:isPlatMovementEnabled() --cheat cheat
    return true
end

function Other_Player:getFacing()
    return self.facing or "left"
end

function Other_Player:isPlatforming()
    if self.state == "FEATHERFALL" then return true end
    return false
end

function Other_Player:getDebugInfo()
    local info = super.getDebugInfo(self)
    table.insert(info, "player: " .. self.name)
    table.insert(info, "facing: " .. self.facing)
    return info
end

function Other_Player:setActor(actor)
    super.setActor(self, actor)
end

function Other_Player:handleMovement()
end


function Other_Player:moveTo(x, y, keep_facing)
    if type(x) == "string" then
        keep_facing = y
        x, y = self.world.map:getMarker(x)
    end
    self:move(x - self.x, y - self.y, 0.5, keep_facing)
end

-- Example of updating sprite animation in Other_Player class
function Other_Player:update(...)
    if self.fadingOut then
        self.alpha = math.max(0, self.alpha - (DT * 4))
        if self.alpha <= 0 then
            self:remove()
        end
    else
        self.alpha = math.min(1, self.alpha + (DT * 4))
    end
    super.update(self, ...)


    self.cx = self.x
    self.cy = self.y - 25

    -- Check if this player is moving
    if self.targetX and self.targetY then
        local moved = self:moveTo(self.targetX, self.targetY, true)  -- Assuming moveTo updates movement

        -- Update sprite animation based on movement state
        self.sprite.walking = moved
        self.sprite.walk_speed = moved and 4 or 0  -- Set appropriate walk speed

        -- Optionally, set facing direction based on movement
        if moved then
            self:faceTowards({ x = self.targetX, y = self.targetY })
        end
    end

    self.state_manager:update()
end


function Other_Player:draw()
    -- Draw the player
    super.draw(self)
end

return Other_Player
