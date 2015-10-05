local COLLISION_CLASSES = {
  -- NOTE: Ordering matters!

  -- Player
  {
    name = "PlayerBody"
  },

  {
    name = "PlayerFeet"
  },

  {
    name = "PlayerTail",
    config = {
      ignores = {"All"}
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
  {
    name = "Tile",
    config = {
      ignores = {"All"},
    }
  },

    {
    name = "Statue",
    config = {
      --ignores = {"All"},
    }
  },
}

return function(world)

  for i,collision in ipairs(COLLISION_CLASSES) do
    world:addCollisionClass(collision.name, collision.config or nil)
  end

end
