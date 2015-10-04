local TexMate = require("texmate.TexMate")


return  {
    Idle = {
      framerate = 14,
      frames = {
        'toad_animations_Orange/ToadIdle_0000'
      }
    },

    Running = {
      framerate = 12,
      frames = {
        "toad_animations_Orange/Run_0000","toad_animations_Orange/Run_0001","toad_animations_Orange/Run_0002"
      }
    },

    Skidding = {
      framerate = 14,
      frames = {
        'toad_animations_Orange/ToadIdle_0000'
      }
    },

    Jumping = {
      framerate = 17,
      frames = {
        TexMate:frameCounter("toad_animations_Orange/Jump_",0,6,4)
      }
    },
    JumpIdle = {
      framerate = 14,
      frames = {
        "toad_animations_Orange/Jump_0006"
      }
    },
    Landing = {
      framerate = 12,
      frames = {
        "toad_animations_Orange/Run_Land_0000","toad_animations_Orange/Run_Land_0001"
      }
    },
    FatRun = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations_Orange/Fat_Run_",0,4,4)
      }
    },
    FatJump = {
      framerate = 17,
      frames = {
        TexMate:frameCounter("toad_animations_Orange/Fat_Jump_",0,7,4)
      }
    },
    Spit = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations_Orange/Spit_",0,2,4)
      }
    },
    Eat = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations_Orange/Eat_",0,3,4)
      }
    },
    Stun = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations_Orange/Spin_",0,12,4)
      }
    },
    FatIdle = {
      framerate = 14,
      frames = {"toad_animations_Orange/Fat_0003"

      }
    },
    FatLand = {
      framerate = 14,
      frames = {TexMate:frameCounter("toad_animations_Orange/Fat_Land_",0,10,4)

      }
    },
    RunLand = {
      framerate = 14,
      frames = {TexMate:frameCounter("toad_animations_Orange/Run_Land_",0,1,4)

      }
    },
    Spawning = {
      framerate = 14,
      frames = {"toad_animations_Orange/Fat_0000","toad_animations_Orange/Fat_0001","toad_animations_Orange/Fat_0002","toad_animations_Orange/Fat_0003",

      }
    },
        FatSpawn = {
      framerate = 14,
      frames = {"toad_animations_Orange/Fat_0000","toad_animations_Orange/Fat_0001","toad_animations_Orange/Fat_0002","toad_animations_Orange/Fat_0003",

      }
    },
    Fall = {
      framerate = 7,
      frames = {TexMate:frameCounter("toad_animations_Orange/Fall_",0,3,4)

      }
    },
    FatFall = {
      framerate = 7,
      frames = {TexMate:frameCounter("toad_animations_Orange/Fat_Fall_",0,3,4)

      }
    },
    Blank = {
      framerate = 7,
      frames = {"toad_animations_Orange/Dust_0007"

      }
    },
    eat = {
      framerate = 14,
      frames = {"toad_animations_Orange/Eat_0000","toad_animations_Orange/Eat_0001","toad_animations_Orange/Eat_0002","toad_animations_Orange/Eat_0003",

      }
    },
  }
