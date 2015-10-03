local COLLISION_CLASSES = {
  -- NOTE: Ordering matters!

  -- Player
  {
    name = "PlayerBody",
    config = {}
  },

  {
    name = "PlayerFeet",
    config = {}
  },


  -- Players Arm
  {
    name = "ArmOut",
    config = {
      ignores = {'PlayerFeet'}
    }
  },

  {
    name = "ArmIn",
    config = {
      ignores = {'PlayerFeet'}
    }
  },

  -- Tiles
}

return function(world)

  for i,collision in ipairs(COLLISION_CLASSES) do
    world:addCollisionClass(collision.name, collision.config)
  end

end
