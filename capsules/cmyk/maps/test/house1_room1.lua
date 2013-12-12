return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 16,
  height = 9,
  tilewidth = 32,
  tileheight = 32,
  properties = {
    ["sortmode"] = "yz"
  },
  tilesets = {
    {
      name = "hyptosis_ff6-recreated",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "../../images/tilesets/hyptosis_ff6-recreated.png",
      imagewidth = 512,
      imageheight = 1335,
      properties = {},
      tiles = {
        {
          id = 56,
          properties = {
            ["blendmode"] = "additive"
          }
        }
      }
    },
    {
      name = "doorshade",
      firstgid = 657,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "../../images/tilesets/doorshade.png",
      imagewidth = 32,
      imageheight = 64,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "0.0",
      x = 0,
      y = 0,
      width = 16,
      height = 9,
      visible = true,
      opacity = 1,
      properties = {
        ["z"] = "0"
      },
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 69, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 69, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 83, 66, 67, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 71, 70, 66, 83, 66, 0,
        0, 102, 103, 103, 103, 103, 103, 103, 103, 104, 66, 67, 67, 66, 66, 0,
        0, 0, 145, 0, 0, 145, 145, 145, 145, 146, 83, 66, 68, 66, 67, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "0.1",
      x = 0,
      y = 0,
      width = 16,
      height = 9,
      visible = true,
      opacity = 1,
      properties = {
        ["z"] = "0"
      },
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 122, 0, 121, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 121, 0, 0, 0, 0, 0, 0, 121, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "1.0",
      x = 0,
      y = 0,
      width = 16,
      height = 9,
      visible = true,
      opacity = 1,
      properties = {
        ["z"] = "1"
      },
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 50, 130, 51, 51, 51, 51, 51, 51, 88, 0, 0, 50, 658, 52, 0,
        0, 9, 180, 9, 9, 9, 9, 72, 9, 10, 55, 54, 0, 0, 0, 0,
        0, 25, 25, 25, 25, 25, 25, 25, 25, 26, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "1.1",
      x = 0,
      y = 0,
      width = 16,
      height = 9,
      visible = true,
      opacity = 1,
      properties = {
        ["z"] = "1"
      },
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 106, 0, 105, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 105, 0, 0, 0, 0, 0, 0, 105, 0, 59, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "2.0",
      x = 0,
      y = 0,
      width = 16,
      height = 9,
      visible = true,
      opacity = 1,
      properties = {
        ["z"] = "2"
      },
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 34, 114, 35, 76, 35, 35, 35, 76, 36, 0, 0, 34, 657, 36, 0,
        0, 0, 0, 0, 0, 0, 0, 56, 0, 57, 39, 38, 0, 0, 0, 0,
        0, 59, 0, 0, 0, 27, 43, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "3.0",
      x = 0,
      y = 0,
      width = 16,
      height = 9,
      visible = true,
      opacity = 1,
      properties = {
        ["z"] = "3"
      },
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 18, 101, 19, 60, 19, 19, 19, 60, 20, 0, 0, 18, 101, 20, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 22, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "4.0",
      x = 0,
      y = 0,
      width = 16,
      height = 9,
      visible = true,
      opacity = 1,
      properties = {
        ["z"] = "4"
      },
      encoding = "lua",
      data = {
        37, 2, 3, 3, 3, 3, 3, 3, 3, 4, 5, 37, 2, 3, 4, 5,
        17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 17, 0, 0, 0, 21,
        17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21,
        17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21,
        17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21,
        17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21,
        17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21,
        81, 82, 0, 98, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21,
        33, 81, 41, 85, 81, 84, 84, 84, 84, 84, 84, 84, 84, 84, 84, 85
      }
    },
    {
      type = "objectgroup",
      name = "Collision",
      visible = true,
      opacity = 1,
      properties = {
        ["type"] = "collision"
      },
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 160,
          width = 320,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 128,
          width = 32,
          height = 160,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 416,
          y = 0,
          width = 32,
          height = 96,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 448,
          y = 0,
          width = 32,
          height = 128,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 0,
          width = 32,
          height = 288,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 96,
          y = 256,
          width = 64,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 256,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 352,
          y = 128,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "polygon",
          x = 352,
          y = 192,
          width = 0,
          height = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 32, y = -32 },
            { x = 0, y = -32 }
          },
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 288,
          y = 0,
          width = 64,
          height = 160,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "ellipse",
          x = 256,
          y = 176,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "ellipse",
          x = 32,
          y = 176,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "ellipse",
          x = 384,
          y = 112,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "ellipse",
          x = 448,
          y = 112,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 288,
          height = 128,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 384,
          y = 128,
          width = 16,
          height = 16,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 352,
          y = 0,
          width = 64,
          height = 128,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 464,
          y = 128,
          width = 16,
          height = 16,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "Portals",
      visible = true,
      opacity = 1,
      properties = {
        ["type"] = "portals"
      },
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 64,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {
            ["map"] = "test/arkanos",
            ["spawn"] = "house1"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 416,
          y = 64,
          width = 32,
          height = 32,
          visible = true,
          properties = {
            ["map"] = "test/arkanos",
            ["spawn"] = "entrance"
          }
        }
      }
    },
    {
      type = "objectgroup",
      name = "Spawn",
      visible = true,
      opacity = 1,
      properties = {
        ["type"] = "spawns"
      },
      objects = {
        {
          name = "door1",
          type = "",
          shape = "rectangle",
          x = 64,
          y = 256,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "door2",
          type = "",
          shape = "rectangle",
          x = 416,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "behind_counter",
          type = "",
          shape = "rectangle",
          x = 64,
          y = 128,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "Entities",
      visible = true,
      opacity = 1,
      properties = {
        ["type"] = "_entities"
      },
      objects = {
        {
          name = "Bart the Tender",
          type = "humanoid",
          shape = "ellipse",
          x = 128,
          y = 128,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "monster",
          shape = "ellipse",
          x = 384,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
