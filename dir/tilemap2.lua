return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.11.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 32,
  height = 32,
  tilewidth = 16,
  tileheight = 16,
  nextlayerid = 8,
  nextobjectid = 24,
  properties = {},
  tilesets = {
    {
      name = "monochrome_red_tileset",
      firstgid = 1,
      class = "",
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "res/mono_tile_set.png",
      imagewidth = 256,
      imageheight = 256,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      wangsets = {},
      tilecount = 256,
      tiles = {}
    },
    {
      name = "monochrome_red_tileset",
      firstgid = 257,
      class = "",
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "res/mono_tile_set.png",
      imagewidth = 256,
      imageheight = 256,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      wangsets = {},
      tilecount = 256,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 32,
      height = 32,
      id = 2,
      name = "Floor",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 4, 5, 5, 0, 0, 5, 5, 4, 0,
        0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 5, 5, 5, 0, 0, 4, 5, 5, 0,
        0, 5, 0, 0, 5, 5, 5, 5, 5, 5, 5, 0, 5, 5, 5, 4, 5, 0, 0, 0, 0, 0, 0, 5, 4, 5, 0, 0, 0, 5, 0, 0,
        0, 5, 0, 5, 5, 5, 5, 5, 5, 0, 0, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 5, 0, 0,
        0, 5, 0, 5, 5, 5, 5, 5, 5, 5, 5, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 5, 5, 5, 0, 0,
        0, 5, 0, 5, 5, 5, 5, 5, 5, 5, 5, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 0, 0, 0, 0, 0,
        0, 5, 0, 0, 72, 0, 0, 0, 0, 72, 0, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 0, 0, 0, 0, 0,
        0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 0, 0, 0, 0, 0,
        0, 5, 5, 5, 5, 4, 5, 5, 5, 5, 5, 5, 5, 4, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 0,
        0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0,
        0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 5, 5, 5, 5, 4, 5, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 0, 5, 0,
        0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 5, 0, 5, 0,
        0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 5, 5, 5, 0,
        0, 5, 0, 0, 5, 5, 5, 5, 5, 5, 5, 0, 5, 4, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 5, 0, 0, 0,
        0, 5, 0, 5, 5, 5, 5, 5, 5, 0, 0, 0, 5, 5, 5, 5, 5, 64, 64, 64, 64, 64, 5, 5, 5, 0, 0, 0, 5, 0, 0, 0,
        0, 5, 0, 5, 5, 5, 5, 5, 5, 5, 5, 0, 5, 5, 5, 5, 5, 64, 64, 64, 64, 64, 5, 5, 5, 0, 0, 0, 5, 0, 0, 0,
        0, 5, 0, 5, 5, 5, 5, 5, 5, 5, 5, 0, 5, 5, 5, 4, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 4, 5, 5, 5, 0,
        0, 5, 0, 0, 72, 0, 0, 0, 0, 72, 0, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 5, 5, 4, 5, 0,
        0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0,
        0, 5, 5, 5, 5, 5, 5, 5, 5, 4, 5, 5, 5, 4, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 5, 5, 5, 5, 0,
        0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 5, 5, 4, 5, 0,
        0, 5, 5, 5, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 0,
        0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 4, 5, 5, 5, 0,
        0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 5, 5, 5, 5, 0,
        0, 5, 0, 0, 5, 5, 5, 5, 5, 5, 5, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0,
        0, 5, 0, 5, 5, 5, 5, 5, 5, 0, 0, 0, 5, 5, 5, 4, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 5, 5, 5, 4, 0,
        0, 5, 0, 5, 5, 5, 5, 5, 5, 5, 5, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 5, 5, 5, 5, 0,
        0, 5, 0, 5, 5, 5, 5, 5, 5, 5, 5, 0, 5, 4, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 4, 5, 5, 0,
        0, 5, 0, 0, 72, 0, 0, 0, 0, 72, 0, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 5, 5, 5, 5, 0,
        0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 5, 5, 5, 5, 5, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 32,
      height = 32,
      id = 1,
      name = "Walls",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 0, 0, 0, 128, 128, 0, 0, 0, 128,
        63, 0, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 0, 0, 0, 128, 128, 0, 0, 0, 128,
        63, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 0, 0, 0, 128, 128, 128, 0, 128, 128,
        63, 0, 128, 0, 0, 0, 0, 0, 0, 125, 380, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 128, 128, 128, 0, 128, 128,
        63, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 0, 0, 0, 0, 128, 128,
        63, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 0, 128, 128, 128, 128, 128,
        63, 0, 128, 128, 0, 128, 128, 128, 128, 0, 128, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 0, 128, 128, 128, 128, 128,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 0, 128, 128, 128, 128, 128,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 0, 0, 0, 0, 0, 0, 128,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 128, 128, 128, 128, 128, 128, 0, 128,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 0, 0, 0, 0, 128, 0, 128,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 128, 128, 0, 128, 0, 128,
        63, 0, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 128, 128, 0, 0, 0, 128,
        63, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 63, 26, 26, 26, 63, 128, 128, 0, 128, 128, 128, 0, 128, 128, 128,
        63, 0, 128, 0, 0, 0, 0, 0, 0, 125, 124, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 128, 128, 0, 128, 128, 128,
        63, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 128, 128, 0, 128, 128, 128,
        63, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 63, 27, 27, 27, 63, 128, 128, 0, 128, 0, 0, 0, 0, 0, 128,
        63, 0, 128, 128, 0, 128, 128, 128, 128, 0, 128, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 0, 0, 0, 0, 0, 128,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 128, 128, 128, 128, 128, 128,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 0, 0, 0, 0, 0, 128,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 0, 0, 0, 0, 0, 128,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 0, 0, 0, 0, 0, 0, 128,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 0, 0, 0, 0, 0, 128,
        63, 0, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 0, 0, 0, 0, 0, 128,
        63, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 128, 128, 128, 128, 128, 128,
        63, 0, 128, 0, 0, 0, 0, 0, 0, 125, 124, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 0, 0, 0, 0, 0, 128,
        63, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 0, 0, 0, 0, 0, 128,
        63, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 0, 0, 0, 0, 0, 0, 128,
        63, 0, 128, 128, 0, 128, 128, 128, 128, 0, 128, 128, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 0, 0, 0, 0, 0, 128,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 3, 3, 3, 63, 128, 128, 0, 128, 0, 0, 0, 0, 0, 128,
        63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "SpawnPoints",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 5,
          name = "",
          type = "",
          shape = "point",
          x = 384,
          y = 32,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["SubType"] = "GOBLIN",
            ["Type"] = "MONSTER"
          }
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "point",
          x = 464,
          y = 16,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["SubType"] = "GOBLIN",
            ["Type"] = "MONSTER"
          }
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "point",
          x = 464,
          y = 336,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["SubType"] = "GOBLIN",
            ["Type"] = "MONSTER"
          }
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "point",
          x = 464,
          y = 448,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["SubType"] = "DARKELF",
            ["Type"] = "MONSTER"
          }
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "point",
          x = 464,
          y = 368,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["SubType"] = "GOBLIN",
            ["Type"] = "MONSTER"
          }
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "point",
          x = 96,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["Name"] = "Lea",
            ["SubType"] = "MOOK",
            ["Type"] = "NPC"
          }
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "point",
          x = 96,
          y = 64,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["Name"] = "Aimee",
            ["SubType"] = "TRAINER",
            ["Type"] = "NPC"
          }
        }
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 32,
      height = 32,
      id = 5,
      name = "Interactable",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 61, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 68, 0, 0, 0, 0, 68, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 61, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 68, 0, 0, 0, 0, 68, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 61, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
      name = "PlayerSpawn",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 23,
          name = "",
          type = "",
          shape = "point",
          x = 16,
          y = 48,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
      name = "Interactable",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 14,
          name = "",
          type = "",
          shape = "point",
          x = 48,
          y = 48,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["Content"] = "gold#5,ironSword#1,blueKey#1,leatherArmor#1,healthPotion#4",
            ["Locked"] = false,
            ["Opened"] = false,
            ["Type"] = "CHEST"
          }
        },
        {
          id = 15,
          name = "",
          type = "",
          shape = "point",
          x = 48,
          y = 224,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["Content"] = "gold#5,healthPotion#1",
            ["Locked"] = true,
            ["Opened"] = false,
            ["Type"] = "CHEST"
          }
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "point",
          x = 48,
          y = 400,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["Content"] = "sword#1",
            ["Locked"] = false,
            ["Opened"] = false,
            ["Type"] = "CHEST"
          }
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "point",
          x = 64,
          y = 112,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["Locked"] = false,
            ["Type"] = "DOOR"
          }
        },
        {
          id = 19,
          name = "",
          type = "",
          shape = "point",
          x = 144,
          y = 112,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["Color"] = "blue",
            ["Locked"] = true,
            ["Type"] = "DOOR"
          }
        },
        {
          id = 20,
          name = "",
          type = "",
          shape = "point",
          x = 64,
          y = 288,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["Locked"] = false,
            ["Type"] = "DOOR"
          }
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "point",
          x = 144,
          y = 288,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["Locked"] = false,
            ["Type"] = "DOOR"
          }
        }
      }
    }
  }
}
