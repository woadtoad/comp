local COLLISION_CLASSES = {
  -- NOTE: Ordering matters!

  -- Player
  {
    name = "PlayerBody"
  },

  {
    name = "PlayerFeet"
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

  -- pickup and pickup base
  {
    name = "Pickup",
    config = {
      --ignores = { 'All' }
    }
  },

  {
    name = "Base",
    config = {
      ignores = {"All"},
    }
  },

  -- Tiles
}

return function(world)

  for i,collision in ipairs(COLLISION_CLASSES) do
    world:addCollisionClass(collision.name, collision.config or nil)
  end

end
