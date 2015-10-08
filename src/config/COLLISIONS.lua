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
    name = "PlayerJump",
    config = {
      ignores = {"All"}
    }
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
    name = "Water",
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
  {
    name = "PlayerBodyJump",
    config = {
      ignores = {"Pickup"}
    }
  },
}

return function(world)

  for i,collision in ipairs(COLLISION_CLASSES) do
    world:addCollisionClass(collision.name, collision.config or nil)
  end

end
