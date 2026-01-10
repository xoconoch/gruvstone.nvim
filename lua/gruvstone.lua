---@class Gruvstone
---@field config GruvstoneConfig
---@field palette GruvstonePalette
local Gruvstone = {}

---@alias Contrast "hard" | "soft" | ""

---@class ItalicConfig
---@field strings boolean
---@field comments boolean
---@field operators boolean
---@field folds boolean
---@field emphasis boolean

---@class HighlightDefinition
---@field fg string?
---@field bg string?
---@field sp string?
---@field blend integer?
---@field bold boolean?
---@field standout boolean?
---@field underline boolean?
---@field undercurl boolean?
---@field underdouble boolean?
---@field underdotted boolean?
---@field strikethrough boolean?
---@field italic boolean?
---@field reverse boolean?
---@field nocombine boolean?

---@class GruvstoneConfig
---@field bold boolean?
---@field contrast Contrast?
---@field dim_inactive boolean?
---@field inverse boolean?
---@field invert_selection boolean?
---@field invert_signs boolean?
---@field invert_tabline boolean?
---@field italic ItalicConfig?
---@field overrides table<string, HighlightDefinition>?
---@field palette_overrides table<string, string>?
---@field strikethrough boolean?
---@field terminal_colors boolean?
---@field transparent_mode boolean?
---@field undercurl boolean?
---@field underline boolean?
local default_config = {
  terminal_colors = true,
  undercurl = false,
  underline = false,
  bold = false,      -- No bold text
  italic = {
    strings = false, -- No italics anywhere
    emphasis = false,
    comments = false,
    operators = false,
    folds = false,
  },
  strikethrough = false,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  inverse = false,
  contrast = "",
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
}

Gruvstone.config = vim.deepcopy(default_config)

-- main gruvstone color palette
---@class GruvstonePalette
Gruvstone.palette = {
  dark0_hard = "#1d2021",
  dark0 = "#282828",
  dark0_soft = "#32302f",
  dark1 = "#3c3836",
  dark2 = "#504945",
  dark3 = "#665c54",
  dark4 = "#7c6f64",
  light0_hard = "#f9f5d7",
  light0 = "#fbf1c7",
  light0_soft = "#f2e5bc",
  light1 = "#ebdbb2",
  light2 = "#d5c4a1",
  light3 = "#bdae93",
  light4 = "#a89984",
  bright_red = "#fb4934",
  bright_green = "#b8bb26",
  bright_yellow = "#fabd2f",
  bright_blue = "#83a598",
  bright_purple = "#d3869b",
  bright_aqua = "#8ec07c",
  bright_orange = "#fe8019",
  neutral_red = "#cc241d",
  neutral_green = "#98971a",
  neutral_yellow = "#d79921",
  neutral_blue = "#458588",
  neutral_purple = "#b16286",
  neutral_aqua = "#689d6a",
  neutral_orange = "#d65d0e",
  faded_red = "#9d0006",
  faded_green = "#79740e",
  faded_yellow = "#b57614",
  faded_blue = "#076678",
  faded_purple = "#8f3f71",
  faded_aqua = "#427b58",
  faded_orange = "#af3a03",
  dark_red_hard = "#792329",
  dark_red = "#722529",
  dark_red_soft = "#7b2c2f",
  light_red_hard = "#fc9690",
  light_red = "#fc9487",
  light_red_soft = "#f78b7f",
  dark_green_hard = "#5a633a",
  dark_green = "#62693e",
  dark_green_soft = "#686d43",
  light_green_hard = "#d3d6a5",
  light_green = "#d5d39b",
  light_green_soft = "#cecb94",
  dark_aqua_hard = "#3e4934",
  dark_aqua = "#49503b",
  dark_aqua_soft = "#525742",
  light_aqua_hard = "#e6e9c1",
  light_aqua = "#e8e5b5",
  light_aqua_soft = "#e1dbac",
  gray = "#928374",
}

-- get a hex list of gruvstone colors based on current bg and constrast config
local function get_colors()
  local p = Gruvstone.palette
  local config = Gruvstone.config

  for color, hex in pairs(config.palette_overrides) do
    p[color] = hex
  end

  local bg = vim.o.background
  local color_groups = {
    dark = {
      bg0 = p.dark0,
      bg1 = p.dark1,
      bg2 = p.dark2,
      bg3 = p.dark3,
      bg4 = p.dark4,
      fg0 = p.light0,
      fg1 = p.light1, -- Default text color
      fg2 = p.light2,
      fg3 = p.light3,
      fg4 = p.light4,

      -- Keep Gruvstone colors but map them to Alabaster's 4 categories
      -- 1. Strings → Gruvstone green
      string = {
        fg = p.bright_green,
        bg = nil,
      },

      -- 2. Constants → Gruvstone purple
      constant = {
        fg = p.bright_purple,
        bg = nil,
      },

      -- 3. Comments → Gruvstone neutral_orange
      comment = {
        fg = p.neutral_orange,
        bg = nil,
      },

      -- 4. Global definitions → Gruvstone blue
      definition = {
        fg = p.bright_blue,
        bg = nil,
      },

      -- 5. Punctuation → subtle in dark mode
      punctuation = {
        fg = p.light4,
        bg = nil,
      },

      -- Everything else uses normal text color (light1)
      red = p.bright_red,
      green = p.bright_green,
      yellow = p.bright_yellow,
      blue = p.bright_blue,
      purple = p.bright_purple,
      aqua = p.bright_aqua,
      orange = p.bright_orange,
      neutral_red = p.neutral_red,
      neutral_green = p.neutral_green,
      neutral_yellow = p.neutral_yellow,
      neutral_blue = p.neutral_blue,
      neutral_purple = p.neutral_purple,
      neutral_aqua = p.neutral_aqua,
      dark_red = p.dark_red,
      dark_green = p.dark_green,
      dark_aqua = p.dark_aqua,
      gray = p.gray,
    },
    light = {
      bg0            = p.light0,
      bg1            = p.light1,
      bg2            = p.light2,
      bg3            = p.light3,
      bg4            = p.light4,
      fg0            = p.dark0,
      fg1            = p.dark1, -- Default text color
      fg2            = p.dark2,
      fg3            = p.dark3,
      fg4            = p.dark4,

      string         = {
        fg = p.faded_green,
        bg = p.light_green_soft,
      },

      constant       = {
        fg = p.faded_purple,
        bg = p.light0_soft,
      },

      comment        = {
        fg = p.faded_orange,
        bg = p.light0_soft,
      },

      definition     = {
        fg = p.faded_blue,
        bg = p.light_aqua_soft,
      },
      -- 5. Punctuation → use dark4 for subtle punctuation in light mode
      punctuation = {
        fg = p.dark4,
        bg = nil,
      },

      red            = p.faded_red,
      green          = p.faded_green,
      yellow         = p.faded_yellow,
      blue           = p.faded_blue,
      purple         = p.faded_purple,
      aqua           = p.faded_aqua,
      orange         = p.faded_orange,
      neutral_red    = p.neutral_red,
      neutral_green  = p.neutral_green,
      neutral_yellow = p.neutral_yellow,
      neutral_blue   = p.neutral_blue,
      neutral_purple = p.neutral_purple,
      neutral_aqua   = p.neutral_aqua,
      dark_red       = p.light_red,
      dark_green     = p.light_green,
      dark_aqua      = p.light_aqua,
      gray           = p.gray,
    },
  }

return color_groups[bg] or color_groups.dark
end

local function get_groups()
  local colors = get_colors()
  local config = Gruvstone.config

  ---------------------------------------------------------------------------
  -- Helpers
  ---------------------------------------------------------------------------

  local function fg(c) return { fg = c } end
  local function bg(c) return { bg = c } end
  local function fg_bg(f, b) return { fg = f, bg = b } end
  local function link(name) return { link = name } end

  local neutral_bg = config.transparent_mode and nil or colors.bg0
  local float_bg   = config.transparent_mode and nil or colors.bg1
  local panel_bg   = config.transparent_mode and nil or colors.bg2

  ---------------------------------------------------------------------------
  -- Terminal colors
  ---------------------------------------------------------------------------

  if config.terminal_colors then
    local term = {
      colors.bg0,
      colors.neutral_red,
      colors.neutral_green,
      colors.neutral_yellow,
      colors.neutral_blue,
      colors.neutral_purple,
      colors.neutral_aqua,
      colors.fg4,
      colors.gray,
      colors.red,
      colors.green,
      colors.yellow,
      colors.blue,
      colors.purple,
      colors.aqua,
      colors.fg1,
    }
    for i, c in ipairs(term) do
      vim.g["terminal_color_" .. (i - 1)] = c
    end
  end

  ---------------------------------------------------------------------------
  -- Semantic base groups (THE FOUNDATION)
  ---------------------------------------------------------------------------

  local groups = {

    -- Core semantic primitives
    Neutral        = fg_bg(colors.fg1, neutral_bg),
    NeutralFloat   = fg_bg(colors.fg1, float_bg),
    NeutralPanel   = fg_bg(colors.fg1, panel_bg),

    Punctuation = fg(colors.punctuation.fg),

    String         = fg(colors.string.fg),
    Constant       = fg(colors.constant.fg),
    Comment        = fg(colors.comment.fg),
    Function       = fg(colors.definition.fg),

    Error          = fg(colors.red),
    Warning        = fg(colors.yellow),
    Info           = fg(colors.blue),
    Hint           = fg(colors.aqua),

    -------------------------------------------------------------------------
    -- Core UI
    -------------------------------------------------------------------------

    Normal         = link("Neutral"),
    NormalFloat    = link("NeutralFloat"),
    NormalNC       = link("Neutral"),

    CursorLine     = bg(colors.bg1),
    CursorColumn   = link("CursorLine"),

    LineNr         = fg(colors.fg4),
    CursorLineNr   = fg_bg(colors.fg3, colors.bg1),

    SignColumn     = bg(config.transparent_mode and nil or colors.bg1),
    EndOfBuffer    = link("Punctuation"),
    Whitespace     = fg(colors.bg2),

    ColorColumn    = bg(colors.bg1),
    Folded         = fg_bg(colors.gray, colors.bg1),
    FoldColumn     = fg_bg(colors.gray, colors.bg1),

    StatusLine     = link("NeutralPanel"),
    StatusLineNC   = fg_bg(colors.fg4, colors.bg1),
    WinSeparator   = fg_bg(colors.bg3, neutral_bg),

    Pmenu          = link("NeutralPanel"),
    PmenuSel       = fg_bg(colors.bg2, colors.blue),
    PmenuSbar      = bg(colors.bg2),
    PmenuThumb     = bg(colors.bg4),

    Visual         = bg(colors.bg3),
    Search         = fg_bg(colors.yellow, colors.bg0),
    IncSearch      = fg_bg(colors.orange, colors.bg0),

    -------------------------------------------------------------------------
    -- Diagnostics
    -------------------------------------------------------------------------

    DiagnosticError = link("Error"),
    DiagnosticWarn  = link("Warning"),
    DiagnosticInfo  = link("Info"),
    DiagnosticHint  = link("Hint"),

    DiagnosticSignError = fg_bg(colors.red, colors.bg1),
    DiagnosticSignWarn  = fg_bg(colors.yellow, colors.bg1),
    DiagnosticSignInfo  = fg_bg(colors.blue, colors.bg1),
    DiagnosticSignHint  = fg_bg(colors.aqua, colors.bg1),

    -------------------------------------------------------------------------
    -- Diff
    -------------------------------------------------------------------------

    DiffAdd    = bg(colors.dark_green),
    DiffDelete = bg(colors.dark_red),
    DiffChange = bg(colors.dark_aqua),
    DiffText   = fg_bg(colors.bg0, colors.yellow),

    -------------------------------------------------------------------------
    -- Language-agnostic syntax
    -------------------------------------------------------------------------

    Identifier = link("Neutral"),
    Statement  = link("Neutral"),
    Keyword    = link("Neutral"),
    Type       = link("Neutral"),
    Operator   = link("Punctuation"),
    Delimiter  = link("Punctuation"),

    Number     = link("Constant"),
    Boolean    = link("Constant"),

    -------------------------------------------------------------------------
    -- Treesitter (Alabaster mapping)
    -------------------------------------------------------------------------

    ["@comment"]        = link("Comment"),
    ["@string"]         = link("String"),
    ["@string.regex"]   = link("String"),
    ["@string.escape"]  = link("Constant"),

    ["@constant"]       = link("Constant"),
    ["@number"]         = link("Constant"),
    ["@boolean"]        = link("Constant"),

    ["@function"]       = link("Function"),
    ["@method"]         = link("Function"),

    ["@keyword"]        = link("Neutral"),
    ["@type"]           = link("Neutral"),
    ["@variable"]       = link("Neutral"),

    ["@punctuation"]    = link("Punctuation"),
  }

  ---------------------------------------------------------------------------
  -- User overrides (safe)
  ---------------------------------------------------------------------------

  for group, hl in pairs(config.overrides) do
    groups[group] = vim.tbl_extend("force", groups[group] or {}, hl)
  end

  return groups
end

---@param config GruvstoneConfig?
Gruvstone.setup = function(config)
  Gruvstone.config = vim.deepcopy(default_config)
  Gruvstone.config = vim.tbl_deep_extend("force", Gruvstone.config, config or {})
end

--- main load function
Gruvstone.load = function()
  if vim.version().minor < 8 then
    vim.notify_once("gruvstone.nvim: you must use neovim 0.8 or higher")
    return
  end

  -- reset colors
  if vim.g.colors_name then
    vim.cmd.hi("clear")
  end
  vim.g.colors_name = "gruvstone"
  vim.o.termguicolors = true

  local groups = get_groups()

  -- add highlights
  for group, settings in pairs(groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

return Gruvstone
