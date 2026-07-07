---@class DarkPartyMenu : Object
---@overload fun(...) : DarkPartyMenu
local DarkPartyMenu, super = Class(Object)

function DarkPartyMenu:init()
    super.init(self)

    self.parallax_x = 0
    self.parallax_y = 0

    self.font = Assets.getFont("main")

    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.ui_cant_select = Assets.newSound("ui_cant_select")
	self.ui_cancel = Assets.newSound("ui_cancel")
	self.ui_cancel_small = Assets.newSound("ui_cancel_small")

    self.heart_sprite = Sprite("player/heart")
	self.heart_sprite:setOrigin(0.5, 0.5)

    self.up = Assets.getTexture("ui/page_arrow_up")
    self.down = Assets.getTexture("ui/page_arrow_down")

    self.bg = UIBox(100, 100, 440, 300)
    self.bg.layer = -1

    self:addChild(self.bg)

	self.slot_selected = 1

	self.char = Game.party[1]

	self.characters = {"kris", "susie", "ralsei", "noelle", "flowery", "ralsei", "ralsei", "ralsei", "ralsei"}


	-- This is the text for the menu/page titles.
	self.text = Text("")
	self:addChild(self.text)
	self.text.x = 240
	self.text.y = 80

	self.selected_menu = 1

	self.state = "menu_select"

	self.party_selected = 1

        for i, _ in ipairs(self.characters) do
            local party = Game:getPartyMember(self.characters[i])            

            local icon = party.menu_icon 
            local x = 100

            local m = math.floor((i - 1) / 6)
            local a = 60 * m * (m + 1) / 2

            local v = i - (m*6)

            local sprite = Sprite(icon, 90 + (80*(v)) - 80, 100 + a)
            sprite:setScale(2)
            self:addChild(sprite) 
        end

end

function DarkPartyMenu:update()
	super.update(self)


Game.world:closeMenu()
end

function DarkPartyMenu:draw()
    super.draw(self)
end

return DarkPartyMenu
