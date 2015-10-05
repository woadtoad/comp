local TexMate = require("texmate.TexMate")

local anims = {
    Idle = {
      framerate = 14,
      frames = {
        'toad_animations_Pink/Run_0000'
      }
    },

    Running = {
      framerate = 12,
      frames = {
        "toad_animations_Pink/Run_0000","toad_animations_Pink/Run_0001","toad_animations_Pink/Run_0002"
      }
    },

    Skidding = {
      framerate = 14,
      frames = {
        "toad_animations_Pink/Toad_Skid_0000","toad_animations_Pink/Toad_Skid_0001","toad_animations_Pink/Toad_Skid_0002"
      }
    },

    Jumping = {
      framerate = 17,
      frames = {
        TexMate:frameCounter("toad_animations_Pink/Jump_",0,6,4)
      }
    },
    JumpIdle = {
      framerate = 14,
      frames = {
        "toad_animations_Pink/Jump_0006"
      }
    },
    Landing = {
      framerate = 12,
      frames = {
        "toad_animations_Pink/Run_Land_0000","toad_animations_Pink/Run_Land_0001"
      }
    },
    FatRun = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations_Pink/Fat_Run_",0,4,4)
      }
    },
    FatJump = {
      framerate = 17,
      frames = {
        TexMate:frameCounter("toad_animations_Pink/Fat_Jump_",0,7,4)
      }
    },
    Spit = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations_Pink/Spit_",0,2,4)
      }
    },
    Eat = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations_Pink/Eat_",0,3,4)
      }
    },
    Stun = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations_Pink/Spin_",0,12,4)
      }
    },
    FatIdle = {
      framerate = 14,
      frames = {"toad_animations_Pink/Fat_0003"

      }
    },
    FatLand = {
      framerate = 14,
      frames = {TexMate:frameCounter("toad_animations_Pink/Fat_Land_",0,10,4)

      }
    },
    RunLand = {
      framerate = 14,
      frames = {TexMate:frameCounter("toad_animations_Pink/Run_Land_",0,1,4)

      }
    },
    Spawning = {
      framerate = 14,
      frames = {"toad_animations_Pink/Fat_0000","toad_animations_Pink/Fat_0001","toad_animations_Pink/Fat_0002","toad_animations_Pink/Fat_0003",

      }
    },

    FatSpawn = {
      framerate = 14,
      frames = {"toad_animations_Pink/Fat_0000","toad_animations_Pink/Fat_0001","toad_animations_Pink/Fat_0002","toad_animations_Pink/Fat_0003",

      }
    },
    Fall = {
      framerate = 7,
      frames = {TexMate:frameCounter("toad_animations_Pink/Fall_",0,3,4)

      }
    },
    FatFall = {
      framerate = 7,
      frames = {TexMate:frameCounter("toad_animations_Pink/Fat_Fall_",0,3,4)

      }
    },
    Blank = {
      framerate = 7,
      frames = {"toad_animations_Pink/Dust_0007"

      }
    },
    eat = {
      framerate = 14,
      frames = {"toad_animations_Pink/Eat_0000","toad_animations_Pink/Eat_0001","toad_animations_Pink/Eat_0002","toad_animations_Pink/Eat_0003",

      }
    },
  }

return anims
