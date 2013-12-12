local map = {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 100,
  height = 100,
  tilewidth = 32,
  tileheight = 32,
  properties = {},
  tilesets = {
    {
      name = "grasswater",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "../../images/grasswater.png",
      imagewidth = 96,
      imageheight = 224,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Random",
      x = 0,
      y = 0,
      width = 100,
      height = 100,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {}
    },
    {
      type = "objectgroup",
      name = "Spawns",
      visible = true,
      opacity = 1,
      properties = {
        ["type"] = "spawns"
      },
      objects = {
        {
          name = "start",
          type = "",
          shape = "ellipse",
          x = 512,
          y = 160,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "arkanos",
          type = "",
          shape = "ellipse",
          x = 512,
          y = 128,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        }
      }
    }
  }
}

for i = 1, 100 * 100 do
  table.insert(map.layers[1].data, math.random(1, 6))
end

return map