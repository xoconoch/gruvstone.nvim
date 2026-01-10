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
      string = p.bright_green,
      -- 2. Constants → Gruvstone purple
      constant = p.bright_purple,
      -- 3. Comments → Gruvstone neutral_orange (as you have it)
      comment = p.neutral_orange,
      -- 4. Global definitions → Gruvstone blue
      definition = p.bright_blue,
      -- 5. Punctuation → use light4 for subtle punctuation in dark mode
      punctuation = p.light4,

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
      punctuation    = p.dark4,

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

  return color_groups[bg]
end

local function get_groups()
  local colors = get_colors()
  local config = Gruvstone.config

  if config.terminal_colors then
    -- Keep Gruvstone terminal colors
    local term_colors = {
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
    for index, value in ipairs(term_colors) do
      vim.g["terminal_color_" .. index - 1] = value
    end
  end

  local groups = {
    -- Gruvstone color groups for UI components
    GruvstoneFg0                     = { fg = colors.fg0 },
    GruvstoneFg1                     = { fg = colors.fg1 },
    GruvstoneFg2                     = { fg = colors.fg2 },
    GruvstoneFg3                     = { fg = colors.fg3 },
    GruvstoneFg4                     = { fg = colors.fg4 },
    GruvstoneGray                    = { fg = colors.gray },
    GruvstoneBg0                     = { fg = colors.bg0 },
    GruvstoneBg1                     = { fg = colors.bg1 },
    GruvstoneBg2                     = { fg = colors.bg2 },
    GruvstoneBg3                     = { fg = colors.bg3 },
    GruvstoneBg4                     = { fg = colors.bg4 },
    GruvstoneRed                     = { fg = colors.red },
    GruvstoneRedBold                 = { fg = colors.red, bold = config.bold },
    GruvstoneGreen                   = { fg = colors.green },
    GruvstoneGreenBold               = { fg = colors.green, bold = config.bold },
    GruvstoneYellow                  = { fg = colors.yellow },
    GruvstoneYellowBold              = { fg = colors.yellow, bold = config.bold },
    GruvstoneBlue                    = { fg = colors.blue },
    GruvstoneBlueBold                = { fg = colors.blue, bold = config.bold },
    GruvstonePurple                  = { fg = colors.purple },
    GruvstonePurpleBold              = { fg = colors.purple, bold = config.bold },
    GruvstoneAqua                    = { fg = colors.aqua },
    GruvstoneAquaBold                = { fg = colors.aqua, bold = config.bold },
    GruvstoneOrange                  = { fg = colors.orange },
    GruvstoneOrangeBold              = { fg = colors.orange, bold = config.bold },
    -- Basic UI elements
    Normal                           = config.transparent_mode and { fg = colors.fg1, bg = nil } or
        { fg = colors.fg1, bg = colors.bg0 },
    NormalFloat                      = config.transparent_mode and { fg = colors.fg1, bg = nil } or
        { fg = colors.fg1, bg = colors.bg1 },
    NormalNC                         = config.dim_inactive and { fg = colors.fg0, bg = colors.bg1 } or
        { link = "Normal" },

    -- Gruvstone-style UI elements
    ColorColumn                      = { bg = colors.bg1 },
    Conceal                          = { fg = colors.blue },
    NonText                          = { link = "GruvstoneBg2" },
    SpecialKey                       = { link = "GruvstoneFg4" },
    Directory                        = { link = "GruvstoneGreen" },
    Title                            = { link = "GruvstoneGreen" },
    ErrorMsg                         = { fg = colors.bg0, bg = colors.red },
    MoreMsg                          = { link = "GruvstoneYellow" },
    ModeMsg                          = { link = "GruvstoneYellow" },
    Question                         = { link = "GruvstoneOrange" },
    WarningMsg                       = { link = "GruvstoneRed" },
    Whitespace                       = { fg = colors.bg2 },
    EndOfBuffer                      = { link = "NonText" },
    Folded                           = { fg = colors.gray, bg = colors.bg1 },
    FoldColumn                       = config.transparent_mode and { fg = colors.gray, bg = nil } or
        { fg = colors.gray, bg = colors.bg1 },

    -- Alabaster's 4 categories using Gruvstone colors:
    -- 1. Strings
    String                           = { fg = colors.string },

    -- 2. Constants (numbers, symbols, keywords, booleans)
    Constant                         = { fg = colors.constant },
    Number                           = { link = "Constant" },
    Boolean                          = { link = "Constant" },

    -- 3. Comments
    Comment                          = { fg = colors.comment },

    -- 4. Global definitions (functions, classes, etc.)
    Function                         = { fg = colors.definition },
    Identifier                       = { fg = colors.fg1 },

    -- 5. Punctuation
    Punctuation                      = { fg = colors.punctuation },
    Operator                         = { link = "Punctuation" },

    -- Neutralize all language keywords (if, else, function, etc.)
    Statement                        = { fg = colors.fg1 },
    Conditional                      = { fg = colors.fg1 },
    Repeat                           = { fg = colors.fg1 },
    Label                            = { fg = colors.fg1 },
    Keyword                          = { fg = colors.fg1 },
    Exception                        = { fg = colors.fg1 },
    PreProc                          = { fg = colors.fg1 },
    Include                          = { fg = colors.fg1 },
    Define                           = { fg = colors.fg1 },
    Macro                            = { fg = colors.fg1 },
    PreCondit                        = { fg = colors.fg1 },
    Type                             = { fg = colors.fg1 },
    StorageClass                     = { fg = colors.fg1 },
    Structure                        = { fg = colors.fg1 },
    Typedef                          = { fg = colors.fg1 },
    Special                          = { fg = colors.fg1 },
    Tag                              = { fg = colors.fg1 },
    Delimiter                        = { fg = colors.punctuation }, -- (), [], {}, ,, ;, ., :
    SpecialChar                      = { fg = colors.punctuation }, -- Special characters like \n, \t, etc.

    -- UI elements (keep Gruvstone's but simpler)
    CursorLine                       = { bg = colors.bg1 },
    CursorColumn                     = { link = "CursorLine" },
    LineNr                           = { fg = colors.fg4 },
    CursorLineNr                     = { fg = colors.fg3, bg = colors.bg1 },
    SignColumn                       = config.transparent_mode and { bg = nil } or { bg = colors.bg1 },

    -- Visual selection and search (Gruvstone style but minimal)
    Visual                           = { bg = colors.bg3, reverse = config.inverse },
    VisualNOS                        = { link = "Visual" },
    Search                           = { fg = colors.yellow, bg = colors.bg0, reverse = config.inverse },
    IncSearch                        = { fg = colors.orange, bg = colors.bg0, reverse = config.inverse },
    CurSearch                        = { link = "IncSearch" },

    -- Pmenu (Gruvstone colors)
    Pmenu                            = { fg = colors.fg1, bg = colors.bg2 },
    PmenuSel                         = { fg = colors.bg2, bg = colors.blue },
    PmenuSbar                        = { bg = colors.bg2 },
    PmenuThumb                       = { bg = colors.bg4 },

    -- Status line
    StatusLine                       = { fg = colors.fg1, bg = colors.bg2 },
    StatusLineNC                     = { fg = colors.fg4, bg = colors.bg1 },
    WinBar                           = { fg = colors.fg4, bg = colors.bg0 },
    WinBarNC                         = { fg = colors.fg3, bg = colors.bg1 },
    WinSeparator                     = config.transparent_mode and { fg = colors.bg3, bg = nil } or
        { fg = colors.bg3, bg = colors.bg0 },

    -- MiniStatusline theming (add to get_groups() function)
    MiniStatuslineDevinfo            = { link = "StatusLine" },
    MiniStatuslineFileinfo           = { link = "StatusLine" },
    MiniStatuslineFilename           = { link = "StatusLineNC" },
    MiniStatuslineInactive           = { link = "StatusLineNC" },

    -- Mode-specific statusline segments
    MiniStatuslineModeCommand        = { fg = colors.bg0, bg = colors.yellow },
    MiniStatuslineModeInsert         = { fg = colors.bg0, bg = colors.blue },
    MiniStatuslineModeNormal         = { fg = colors.bg0, bg = colors.fg1 },
    MiniStatuslineModeOther          = { fg = colors.bg0, bg = colors.aqua },
    MiniStatuslineModeReplace        = { fg = colors.bg0, bg = colors.red },
    MiniStatuslineModeVisual         = { fg = colors.bg0, bg = colors.green },
    MiniStatuslineModeSelect         = { fg = colors.bg0, bg = colors.purple },
    MiniStatuslineModeTerminal       = { fg = colors.bg0, bg = colors.orange },

    -- Diff (Gruvstone colors)
    DiffAdd                          = { bg = colors.dark_green },
    DiffDelete                       = { bg = colors.dark_red },
    DiffChange                       = { bg = colors.dark_aqua },
    DiffText                         = { bg = colors.yellow, fg = colors.bg0 },

    -- Diagnostics (Gruvstone colors)
    DiagnosticError                  = { link = "GruvstoneRed" },
    DiagnosticWarn                   = { link = "GruvstoneYellow" },
    DiagnosticInfo                   = { link = "GruvstoneBlue" },
    DiagnosticHint                   = { link = "GruvstoneAqua" },
    DiagnosticOk                     = { link = "GruvstoneGreen" },
    DiagnosticSignError              = { fg = colors.red, bg = colors.bg1 },
    DiagnosticSignWarn               = { fg = colors.yellow, bg = colors.bg1 },
    DiagnosticSignInfo               = { fg = colors.blue, bg = colors.bg1 },
    DiagnosticSignHint               = { fg = colors.aqua, bg = colors.bg1 },
    DiagnosticUnnecessary            = { fg = colors.punctuation },

    -- Git (Gruvstone colors)
    GitSignsAdd                      = { link = "GruvstoneGreen" },
    GitSignsAddLn                    = { link = "GruvstoneGreen" },
    GitSignsAddNr                    = { link = "GruvstoneGreen" },
    GitSignsChange                   = { link = "GruvstoneOrange" },
    GitSignsChangeLn                 = { link = "GruvstoneOrange" },
    GitSignsChangeNr                 = { link = "GruvstoneOrange" },
    GitSignsDelete                   = { link = "GruvstoneRed" },
    GitSignsDeleteLn                 = { link = "GruvstoneRed" },
    GitSignsDeleteNr                 = { link = "GruvstoneRed" },

    -- Clojure
    clojureKeyword                   = { fg = colors.constant },   -- Constants (purple)
    clojureCond                      = { fg = colors.fg1 },        -- Neutral
    clojureSpecial                   = { fg = colors.fg1 },        -- Neutral
    clojureDefine                    = { fg = colors.fg1 },        -- Neutral
    clojureFunc                      = { fg = colors.definition }, -- Functions (blue)
    clojureRepeat                    = { fg = colors.fg1 },        -- Neutral
    clojureCharacter                 = { fg = colors.string },     -- Strings (green)
    clojureStringEscape              = { fg = colors.constant },   -- Constants (purple)
    clojureException                 = { fg = colors.fg1 },        -- Neutral
    clojureRegexp                    = { fg = colors.string },     -- Strings (green)
    clojureRegexpEscape              = { fg = colors.constant },   -- Constants (purple)
    clojureRegexpCharClass           = { fg = colors.fg1 },        -- Neutral
    clojureRegexpMod                 = { link = "clojureRegexpCharClass" },
    clojureRegexpQuantifier          = { link = "clojureRegexpCharClass" },
    clojureParen                     = { fg = colors.punctuation }, -- Punctuation
    clojureAnonArg                   = { fg = colors.fg1 },         -- Neutral
    clojureVariable                  = { fg = colors.fg1 },         -- Neutral
    clojureMacro                     = { fg = colors.definition },  -- Functions (blue)
    clojureMeta                      = { fg = colors.fg1 },         -- Neutral
    clojureDeref                     = { fg = colors.fg1 },         -- Neutral
    clojureQuote                     = { fg = colors.fg1 },         -- Neutral
    clojureUnquote                   = { fg = colors.fg1 },         -- Neutral

    -- C/C++
    cOperator                        = { fg = colors.constant }, -- Constants (purple)
    cppOperator                      = { fg = colors.constant }, -- Constants (purple)
    cStructure                       = { fg = colors.fg1 },      -- Neutral

    -- Python
    pythonBuiltin                    = { fg = colors.definition },  -- Functions (blue)
    pythonBuiltinObj                 = { fg = colors.definition },  -- Functions (blue)
    pythonBuiltinFunc                = { fg = colors.definition },  -- Functions (blue)
    pythonFunction                   = { fg = colors.definition },  -- Functions (blue)
    pythonDecorator                  = { fg = colors.definition },  -- Functions (blue)
    pythonInclude                    = { fg = colors.fg1 },         -- Neutral
    pythonImport                     = { fg = colors.fg1 },         -- Neutral
    pythonRun                        = { fg = colors.fg1 },         -- Neutral
    pythonCoding                     = { fg = colors.fg1 },         -- Neutral
    pythonOperator                   = { fg = colors.fg1 },         -- Neutral
    pythonException                  = { fg = colors.fg1 },         -- Neutral
    pythonExceptions                 = { fg = colors.constant },    -- Constants (purple)
    pythonBoolean                    = { fg = colors.constant },    -- Constants (purple)
    pythonDot                        = { fg = colors.punctuation }, -- Punctuation
    pythonConditional                = { fg = colors.fg1 },         -- Neutral
    pythonRepeat                     = { fg = colors.fg1 },         -- Neutral
    pythonDottedName                 = { fg = colors.definition },  -- Functions (blue)

    -- CSS
    cssBraces                        = { fg = colors.punctuation }, -- Punctuation
    cssFunctionName                  = { fg = colors.definition },  -- Functions (blue)
    cssIdentifier                    = { fg = colors.fg1 },         -- Neutral
    cssClassName                     = { fg = colors.definition },  -- Functions (blue)
    cssColor                         = { fg = colors.constant },    -- Constants (purple)
    cssSelectorOp                    = { fg = colors.punctuation }, -- Punctuation
    cssSelectorOp2                   = { fg = colors.punctuation }, -- Punctuation
    cssImportant                     = { fg = colors.constant },    -- Constants (purple)
    cssVendor                        = { fg = colors.fg1 },         -- Neutral
    -- CSS properties - most should be neutral, but function-like ones blue
    cssTextProp                      = { fg = colors.fg1 },
    cssAnimationProp                 = { fg = colors.fg1 },
    cssUIProp                        = { fg = colors.fg1 },
    cssTransformProp                 = { fg = colors.definition }, -- Functions (blue)
    cssTransitionProp                = { fg = colors.fg1 },
    cssPrintProp                     = { fg = colors.fg1 },
    cssPositioningProp               = { fg = colors.fg1 },
    cssBoxProp                       = { fg = colors.fg1 },
    cssFontDescriptorProp            = { fg = colors.fg1 },
    cssFlexibleBoxProp               = { fg = colors.fg1 },
    cssBorderOutlineProp             = { fg = colors.fg1 },
    cssBackgroundProp                = { fg = colors.fg1 },
    cssMarginProp                    = { fg = colors.fg1 },
    cssListProp                      = { fg = colors.fg1 },
    cssTableProp                     = { fg = colors.fg1 },
    cssFontProp                      = { fg = colors.fg1 },
    cssPaddingProp                   = { fg = colors.fg1 },
    cssDimensionProp                 = { fg = colors.fg1 },
    cssRenderProp                    = { fg = colors.fg1 },
    cssColorProp                     = { fg = colors.fg1 },
    cssGeneratedContentProp          = { fg = colors.fg1 },

    -- JavaScript/TypeScript
    javaScriptBraces                 = { fg = colors.punctuation }, -- Punctuation
    javaScriptFunction               = { fg = colors.definition },  -- Functions (blue)
    javaScriptIdentifier             = { fg = colors.fg1 },         -- Neutral
    javaScriptMember                 = { fg = colors.fg1 },         -- Neutral
    javaScriptNumber                 = { fg = colors.constant },    -- Constants (purple)
    javaScriptNull                   = { fg = colors.constant },    -- Constants (purple)
    javaScriptParens                 = { fg = colors.punctuation }, -- Punctuation

    typescriptReserved               = { fg = colors.fg1 },         -- Neutral
    typescriptLabel                  = { fg = colors.fg1 },         -- Neutral
    typescriptFuncKeyword            = { fg = colors.definition },  -- Functions (blue)
    typescriptIdentifier             = { fg = colors.fg1 },         -- Neutral
    typescriptBraces                 = { fg = colors.punctuation }, -- Punctuation
    typescriptEndColons              = { fg = colors.punctuation }, -- Punctuation
    typescriptDOMObjects             = { fg = colors.fg1 },         -- Neutral
    typescriptAjaxMethods            = { fg = colors.definition },  -- Functions (blue)
    typescriptLogicSymbols           = { fg = colors.fg1 },         -- Neutral
    typescriptDocSeeTag              = { link = "Comment" },
    typescriptDocParam               = { link = "Comment" },
    typescriptDocTags                = { link = "Comment" },
    typescriptGlobalObjects          = { fg = colors.definition },  -- Functions (blue)
    typescriptParens                 = { fg = colors.punctuation }, -- Punctuation
    typescriptOpSymbols              = { fg = colors.punctuation }, -- Punctuation
    typescriptHtmlElemProperties     = { fg = colors.fg1 },         -- Neutral
    typescriptNull                   = { fg = colors.constant },    -- Constants (purple)
    typescriptInterpolationDelimiter = { fg = colors.punctuation }, -- Punctuation

    -- PureScript
    purescriptModuleKeyword          = { fg = colors.fg1 },         -- Neutral
    purescriptModuleName             = { fg = colors.definition },  -- Functions (blue)
    purescriptWhere                  = { fg = colors.fg1 },         -- Neutral
    purescriptDelimiter              = { fg = colors.punctuation }, -- Punctuation
    purescriptType                   = { fg = colors.fg1 },         -- Neutral
    purescriptImportKeyword          = { fg = colors.fg1 },         -- Neutral
    purescriptHidingKeyword          = { fg = colors.fg1 },         -- Neutral
    purescriptAsKeyword              = { fg = colors.fg1 },         -- Neutral
    purescriptStructure              = { fg = colors.fg1 },         -- Neutral
    purescriptOperator               = { fg = colors.punctuation }, -- Punctuation
    purescriptTypeVar                = { fg = colors.fg1 },         -- Neutral
    purescriptConstructor            = { fg = colors.fg1 },         -- Neutral
    purescriptFunction               = { fg = colors.definition },  -- Functions (blue)
    purescriptConditional            = { fg = colors.fg1 },         -- Neutral
    purescriptBacktick               = { fg = colors.punctuation }, -- Punctuation

    -- Typst (Vim syntax highlight groups)
    typstCommentBlock                = { fg = colors.comment },
    typstCommentLine                 = { fg = colors.comment },
    typstCommentTodo                 = { fg = colors.comment },

    typstCodeConditional             = { fg = colors.fg1 },
    typstCodeRepeat                  = { fg = colors.fg1 },
    typstCodeKeyword                 = { fg = colors.fg1 },
    typstCodeStatementWord           = { fg = colors.fg1 },

    typstCodeIdentifier              = { fg = colors.fg1 },
    typstCodeFunction                = { fg = colors.definition },
    typstCodeConstant                = { fg = colors.constant },
    typstCodeNumberInteger           = { fg = colors.constant },
    typstCodeNumberFloat             = { fg = colors.constant },
    typstCodeNumberLength            = { fg = colors.constant },
    typstCodeNumberAngle             = { fg = colors.constant },
    typstCodeNumberRatio             = { fg = colors.constant },
    typstCodeNumberFraction          = { fg = colors.constant },
    typstCodeString                  = { fg = colors.string },
    typstCodeLabel                   = { fg = colors.fg1 },
    typstCodeFieldAccess             = { fg = colors.fg1 },

    typstCodeParen                   = { fg = colors.punctuation },
    typstCodeBrace                   = { fg = colors.punctuation },
    typstCodeBracket                 = { fg = colors.punctuation },
    typstCodeDollar                  = { fg = colors.punctuation },

    -- Nix highlights
    nixBoolean                       = { fg = colors.constant },    -- true, false
    nixNull                          = { fg = colors.constant },    -- null
    nixRecKeyword                    = { fg = colors.fg1 },         -- rec
    nixOperator                      = { fg = colors.fg1 },         -- operators: +, //, etc.
    nixParen                         = { fg = colors.punctuation }, -- ( )
    nixInteger                       = { fg = colors.constant },    -- numbers
    nixComment                       = { fg = colors.comment },     -- # comment, /* comment */
    nixTodo                          = { fg = colors.special },     -- TODO, FIXME, etc.
    nixInterpolation                 = { fg = colors.punctuation }, -- ${…} (delimiter)
    nixInterpolationParam            = { fg = colors.fg1 },         -- variable inside ${…}
    nixSimpleString                  = { fg = colors.string },      -- "string"
    nixString                        = { fg = colors.string },      -- ''string''
    nixSimpleStringSpecial           = { fg = colors.special },     -- \n, \t, \$ etc.
    nixStringSpecial                 = { fg = colors.special },     -- ''$'' or ''\n''
    nixInvalidSimpleStringEscape     = { fg = colors.error },       -- invalid escape
    nixInvalidStringEscape           = { fg = colors.error },       -- invalid escape
    nixFunctionCall                  = { fg = colors.fg1 },         -- function call
    nixPath                          = { fg = colors.constant },    -- /path/to/file
    nixHomePath                      = { fg = colors.constant },    -- ~/path
    nixSearchPathRef                 = { fg = colors.constant },    -- <…>
    nixURI                           = { fg = colors.string },      -- URLs
    nixAttribute                     = { fg = colors.fg1 },         -- attribute name
    nixAttributeDot                  = { fg = colors.punctuation }, -- .
    nixAttributeAssignment           = { fg = colors.punctuation }, -- =
    nixAttributeDefinition           = { fg = colors.fg1 },         -- attr def
    nixAttributeSet                  = { fg = colors.punctuation }, -- { … }
    nixArgumentDefinitionWithDefault = { fg = colors.fg1 },         -- function arg with default
    nixArgumentDefinition            = { fg = colors.fg1 },         -- function arg
    nixArgumentEllipsis              = { fg = colors.punctuation }, -- ...
    nixArgOperator                   = { fg = colors.punctuation }, -- @ operator in function args
    nixFunctionArgument              = { fg = colors.punctuation }, -- { foo, bar } in functions
    nixSimpleFunctionArgument        = { fg = colors.fg1 },         -- single arg shorthand
    nixList                          = { fg = colors.punctuation }, -- [ … ]
    nixListBracket                   = { fg = colors.punctuation }, -- [ … ]
    nixLetExprKeyword                = { fg = colors.fg1 },         -- let
    nixIfExprKeyword                 = { fg = colors.fg1 },         -- if / then / else
    nixWithExprKeyword               = { fg = colors.fg1 },         -- with
    nixAssertKeyword                 = { fg = colors.fg1 },         -- assert
    nixBuiltin                       = { fg = colors.special },     -- builtins
    nixNamespacedBuiltin             = { fg = colors.special },     -- builtins.foo

    -- CoffeeScript
    coffeeExtendedOp                 = { fg = colors.punctuation }, -- Punctuation
    coffeeSpecialOp                  = { fg = colors.punctuation }, -- Punctuation
    coffeeCurly                      = { fg = colors.punctuation }, -- Punctuation
    coffeeParen                      = { fg = colors.punctuation }, -- Punctuation
    coffeeBracket                    = { fg = colors.punctuation }, -- Punctuation

    -- Ruby
    rubyStringDelimiter              = { fg = colors.string },      -- Strings (green)
    rubyInterpolationDelimiter       = { fg = colors.punctuation }, -- Punctuation
    rubyDefinedOperator              = { fg = colors.fg1 },         -- Neutral

    -- Objective-C
    objcTypeModifier                 = { fg = colors.fg1 }, -- Neutral
    objcDirective                    = { fg = colors.fg1 }, -- Neutral

    -- Go
    goDirective                      = { fg = colors.fg1 },        -- Neutral
    goConstants                      = { fg = colors.constant },   -- Constants (purple)
    goDeclaration                    = { fg = colors.definition }, -- Functions (blue)
    goDeclType                       = { fg = colors.fg1 },        -- Neutral
    goBuiltins                       = { fg = colors.definition }, -- Functions (blue)

    -- Lua
    luaIn                            = { fg = colors.fg1 },        -- Neutral
    luaFunction                      = { fg = colors.definition }, -- Functions (blue)
    luaTable                         = { fg = colors.fg1 },        -- Neutral

    -- MoonScript
    moonSpecialOp                    = { fg = colors.punctuation }, -- Punctuation
    moonExtendedOp                   = { fg = colors.punctuation }, -- Punctuation
    moonFunction                     = { fg = colors.definition },  -- Functions (blue)
    moonObject                       = { fg = colors.fg1 },         -- Neutral

    -- Java
    javaAnnotation                   = { fg = colors.fg1 }, -- Neutral
    javaDocTags                      = { link = "Comment" },
    javaCommentTitle                 = { link = "Comment" },
    javaParen                        = { fg = colors.punctuation }, -- Punctuation
    javaParen1                       = { fg = colors.punctuation }, -- Punctuation
    javaParen2                       = { fg = colors.punctuation }, -- Punctuation
    javaParen3                       = { fg = colors.punctuation }, -- Punctuation
    javaParen4                       = { fg = colors.punctuation }, -- Punctuation
    javaParen5                       = { fg = colors.punctuation }, -- Punctuation
    javaOperator                     = { fg = colors.punctuation }, -- Punctuation
    javaVarArg                       = { fg = colors.fg1 },         -- Neutral

    -- Elixir
    elixirDocString                  = { link = "Comment" },
    elixirStringDelimiter            = { fg = colors.string },      -- Strings (green)
    elixirInterpolationDelimiter     = { fg = colors.punctuation }, -- Punctuation
    elixirModuleDeclaration          = { fg = colors.definition },  -- Functions (blue)

    -- Scala
    scalaNameDefinition              = { fg = colors.definition },  -- Functions (blue)
    scalaCaseFollowing               = { fg = colors.fg1 },         -- Neutral
    scalaCapitalWord                 = { fg = colors.definition },  -- Functions (blue)
    scalaTypeExtension               = { fg = colors.fg1 },         -- Neutral
    scalaKeyword                     = { fg = colors.fg1 },         -- Neutral
    scalaKeywordModifier             = { fg = colors.fg1 },         -- Neutral
    scalaSpecial                     = { fg = colors.constant },    -- Constants (purple)
    scalaOperator                    = { fg = colors.punctuation }, -- Punctuation
    scalaTypeDeclaration             = { fg = colors.fg1 },         -- Neutral
    scalaTypeTypePostDeclaration     = { fg = colors.fg1 },         -- Neutral
    scalaInstanceDeclaration         = { fg = colors.fg1 },         -- Neutral
    scalaInterpolation               = { fg = colors.punctuation }, -- Punctuation

    -- Haskell
    haskellType                      = { fg = colors.fg1 },         -- Neutral
    haskellIdentifier                = { fg = colors.definition },  -- Functions (blue)
    haskellSeparator                 = { fg = colors.punctuation }, -- Punctuation
    haskellDelimiter                 = { fg = colors.punctuation }, -- Punctuation
    haskellOperators                 = { fg = colors.punctuation }, -- Punctuation
    haskellBacktick                  = { fg = colors.punctuation }, -- Punctuation
    haskellStatement                 = { fg = colors.fg1 },         -- Neutral
    haskellConditional               = { fg = colors.fg1 },         -- Neutral
    haskellLet                       = { fg = colors.fg1 },         -- Neutral
    haskellDefault                   = { fg = colors.fg1 },         -- Neutral
    haskellWhere                     = { fg = colors.fg1 },         -- Neutral
    haskellBottom                    = { fg = colors.fg1 },         -- Neutral
    haskellImportKeywords            = { fg = colors.fg1 },         -- Neutral
    haskellDeclKeyword               = { fg = colors.fg1 },         -- Neutral
    haskellDecl                      = { fg = colors.definition },  -- Functions (blue)
    haskellDeriving                  = { fg = colors.fg1 },         -- Neutral
    haskellAssocType                 = { fg = colors.fg1 },         -- Neutral
    haskellNumber                    = { fg = colors.constant },    -- Constants (purple)
    haskellPragma                    = { fg = colors.constant },    -- Constants (purple)
    haskellTH                        = { fg = colors.definition },  -- Functions (blue)
    haskellForeignKeywords           = { fg = colors.fg1 },         -- Neutral
    haskellKeyword                   = { fg = colors.fg1 },         -- Neutral
    haskellFloat                     = { fg = colors.constant },    -- Constants (purple)
    haskellInfix                     = { fg = colors.punctuation }, -- Punctuation
    haskellQuote                     = { fg = colors.string },      -- Strings (green)
    haskellShebang                   = { fg = colors.comment },     -- Comments
    haskellLiquid                    = { fg = colors.constant },    -- Constants (purple)
    haskellQuasiQuoted               = { fg = colors.string },      -- Strings (green)
    haskellRecursiveDo               = { fg = colors.fg1 },         -- Neutral
    haskellQuotedType                = { fg = colors.fg1 },         -- Neutral
    haskellPreProc                   = { fg = colors.fg1 },         -- Neutral
    haskellTypeRoles                 = { fg = colors.fg1 },         -- Neutral
    haskellTypeForall                = { fg = colors.fg1 },         -- Neutral
    haskellPatternKeyword            = { fg = colors.fg1 },         -- Neutral

    -- JSON
    jsonKeyword                      = { fg = colors.string },      -- Strings (green) - keys are like strings
    jsonQuote                        = { fg = colors.string },      -- Strings (green)
    jsonBraces                       = { fg = colors.punctuation }, -- Punctuation
    jsonString                       = { fg = colors.string },      -- Strings (green)

    -- C#
    csBraces                         = { fg = colors.punctuation }, -- Punctuation
    csEndColon                       = { fg = colors.punctuation }, -- Punctuation
    csLogicSymbols                   = { fg = colors.punctuation }, -- Punctuation
    csParens                         = { fg = colors.punctuation }, -- Punctuation
    csOpSymbols                      = { fg = colors.punctuation }, -- Punctuation
    csInterpolationDelimiter         = { fg = colors.punctuation }, -- Punctuation
    csInterpolationAlignDel          = { fg = colors.punctuation }, -- Punctuation
    csInterpolationFormat            = { fg = colors.string },      -- Strings (green)
    csInterpolationFormatDel         = { fg = colors.punctuation }, -- Punctuation

    -- Rust
    rustSigil                        = { fg = colors.punctuation }, -- Punctuation
    rustEscape                       = { fg = colors.constant },    -- Constants (purple)
    rustStringContinuation           = { fg = colors.string },      -- Strings (green)
    rustEnum                         = { fg = colors.fg1 },         -- Neutral
    rustStructure                    = { fg = colors.fg1 },         -- Neutral
    rustModPathSep                   = { fg = colors.punctuation }, -- Punctuation
    rustCommentLineDoc               = { link = "Comment" },
    rustDefault                      = { fg = colors.fg1 },         -- Neutral

    -- OCaml
    ocamlOperator                    = { fg = colors.punctuation }, -- Punctuation
    ocamlKeyChar                     = { fg = colors.punctuation }, -- Punctuation
    ocamlArrow                       = { fg = colors.punctuation }, -- Punctuation
    ocamlInfixOpKeyword              = { fg = colors.fg1 },         -- Neutral
    ocamlConstructor                 = { fg = colors.fg1 },         -- Neutral

    -- HTML/XML
    htmlTag                          = { fg = colors.punctuation },                          -- Punctuation
    htmlEndTag                       = { fg = colors.punctuation },                          -- Punctuation
    htmlTagName                      = { fg = colors.definition },                           -- Functions (blue)
    htmlArg                          = { fg = colors.string },                               -- Strings (green) - attributes are like strings
    htmlTagN                         = { fg = colors.definition },                           -- Functions (blue)
    htmlSpecialTagName               = { fg = colors.definition },                           -- Functions (blue)
    htmlLink                         = { fg = colors.string, underline = config.underline }, -- Strings (green)
    htmlSpecialChar                  = { fg = colors.constant },                             -- Constants (purple)

    xmlTag                           = { fg = colors.punctuation },                          -- Punctuation
    xmlEndTag                        = { fg = colors.punctuation },                          -- Punctuation
    xmlTagName                       = { fg = colors.definition },                           -- Functions (blue)
    xmlEqual                         = { fg = colors.punctuation },                          -- Punctuation
    docbkKeyword                     = { fg = colors.definition },                           -- Functions (blue)
    xmlDocTypeDecl                   = { fg = colors.comment },                              -- Comments
    xmlDocTypeKeyword                = { fg = colors.constant },                             -- Constants (purple)
    xmlCdataStart                    = { fg = colors.comment },                              -- Comments
    xmlCdataCdata                    = { fg = colors.constant },                             -- Constants (purple)
    dtdFunction                      = { fg = colors.comment },                              -- Comments
    dtdTagName                       = { fg = colors.constant },                             -- Constants (purple)
    xmlAttrib                        = { fg = colors.string },                               -- Strings (green)
    xmlProcessingDelim               = { fg = colors.comment },                              -- Comments
    dtdParamEntityPunct              = { fg = colors.comment },                              -- Comments
    dtdParamEntityDPunct             = { fg = colors.comment },                              -- Comments
    xmlAttribPunct                   = { fg = colors.comment },                              -- Comments
    xmlEntity                        = { fg = colors.constant },                             -- Constants (purple)
    xmlEntityPunct                   = { fg = colors.constant },                             -- Constants (purple)
    -- Svelte
    svelteTag                        = { fg = colors.definition },                           -- Blue for component tags (like functions)
    svelteComponentName              = { fg = colors.definition },                           -- Blue for component names
    svelteDirective                  = { fg = colors.string },                               -- Green for directives (bind:, on:, class:, etc.)
    svelteSpecialDirective           = { fg = colors.constant },                             -- Purple for special directives ({#if}, {#each}, etc.)
    svelteInterpolation              = { fg = colors.constant },                             -- Purple for {expression} interpolation
    svelteMustacheBraces             = { fg = colors.punctuation },                          -- Subtle for {} braces
    svelteShorthandAttribute         = { fg = colors.string },                               -- Green for shorthand attributes
    svelteKeyword                    = { fg = colors.fg1 },                                  -- Neutral for Svelte keywords

    -- Svelte script/style tags (inherit from HTML/JS/CSS)
    svelteScriptTag                  = { link = "htmlTag" },
    svelteStyleTag                   = { link = "htmlTag" },
    svelteScriptTagName              = { link = "htmlTagName" },
    svelteStyleTagName               = { link = "htmlTagName" },

    -- Svelte attribute rules
    svelteAttribute                  = { fg = colors.string }, -- Green for regular attributes
    svelteEventHandler               = { fg = colors.string }, -- Green for on:event handlers

    -- Svelte special syntax
    svelteSpecialExpression          = { fg = colors.constant },    -- Purple for {#if}, {#each}, {#await}, etc.
    svelteSpecialExpressionKeyword   = { fg = colors.fg1 },         -- Neutral for if, each, await keywords
    svelteSpecialExpressionBraces    = { fg = colors.punctuation }, -- Subtle for special expression braces

    -- Svelte reactivity
    svelteReactiveStatement          = { fg = colors.constant },    -- Purple for $: statements
    svelteStoreSubscript             = { fg = colors.constant },    -- Purple for $store
    svelteReactiveLabel              = { fg = colors.punctuation }, -- Subtle for $: label

    -- =========================
    -- Markdown
    -- =========================

    -- Headings
    markdownH1                       = { fg = colors.definition },
    markdownH2                       = { fg = colors.definition },
    markdownH3                       = { fg = colors.definition },
    markdownH4                       = { fg = colors.definition },
    markdownH5                       = { fg = colors.definition },
    markdownH6                       = { fg = colors.definition },

    markdownH1Delimiter              = { fg = colors.punctuation },
    markdownH2Delimiter              = { fg = colors.punctuation },
    markdownH3Delimiter              = { fg = colors.punctuation },
    markdownH4Delimiter              = { fg = colors.punctuation },
    markdownH5Delimiter              = { fg = colors.punctuation },
    markdownH6Delimiter              = { fg = colors.punctuation },
    markdownHeadingDelimiter         = { fg = colors.punctuation },
    markdownHeadingRule              = { fg = colors.punctuation },

    -- Text emphasis (neutralized)
    markdownItalic                   = { fg = colors.fg1, italic = true },
    markdownBold                     = { fg = colors.fg1, bold = true },
    markdownBoldItalic               = { fg = colors.fg1, bold = true, italic = true },
    markdownStrike                   = { fg = colors.fg1, strikethrough = true },

    markdownItalicDelimiter          = { fg = colors.punctuation },
    markdownBoldDelimiter            = { fg = colors.punctuation },
    markdownBoldItalicDelimiter      = { fg = colors.punctuation },
    markdownStrikeDelimiter          = { fg = colors.punctuation },
    markdownBlockquote               = { fg = colors.comment },
    markdownRule                     = { fg = colors.punctuation },
    markdownListMarker               = { fg = colors.punctuation },
    markdownOrderedListMarker        = { fg = colors.punctuation },
    markdownCode                     = { fg = colors.constant, bg = colors.bg1 },
    markdownCodeDelimiter            = { fg = colors.punctuation },
    markdownCodeBlock                = { fg = colors.constant, bg = colors.bg1 },
    markdownHighlight                = { fg = colors.constant, bg = colors.bg1 },
    markdownLinkText                 = { fg = colors.string },
    markdownLinkTextDelimiter        = { fg = colors.punctuation },
    markdownLinkDelimiter            = { fg = colors.punctuation },
    markdownUrl                      = { fg = colors.string, underline = config.underline },
    markdownUrlDelimiter             = { fg = colors.punctuation },
    markdownUrlTitle                 = { fg = colors.string },
    markdownUrlTitleDelimiter        = { fg = colors.punctuation },
    markdownAutomaticLink            = { fg = colors.string },
    markdownIdDeclaration            = { fg = colors.constant },
    markdownId                       = { fg = colors.constant },
    markdownIdDelimiter              = { fg = colors.punctuation },
    markdownFootnote                 = { fg = colors.constant },
    markdownFootnoteDefinition       = { fg = colors.constant },
    markdownLineBreak                = { fg = colors.punctuation },
    markdownEscape                   = { fg = colors.constant },
    markdownError                    = { fg = colors.red },
    markdownYamlHead                 = { fg = colors.comment },
    markdownValid                    = { fg = colors.fg1 },

    -- Tree-sitter groups (map to Alabaster's 4 categories)
    ["@comment"]                     = { link = "Comment" },
    ["@string"]                      = { link = "String" },
    ["@string.regex"]                = { link = "String" },
    ["@string.escape"]               = { link = "Constant" },
    ["@string.special"]              = { link = "Constant" },

    ["@constant"]                    = { link = "Constant" },
    ["@constant.builtin"]            = { link = "Constant" },
    ["@constant.macro"]              = { link = "Constant" },
    ["@boolean"]                     = { link = "Constant" },
    ["@number"]                      = { link = "Constant" },
    ["@number.float"]                = { link = "Constant" },
    ["@float"]                       = { link = "Constant" },

    ["@function"]                    = { link = "Function" },
    ["@function.builtin"]            = { link = "Function" },
    ["@function.call"]               = { link = "Function" },
    ["@function.macro"]              = { link = "Function" },
    ["@method"]                      = { link = "Function" },
    ["@method.call"]                 = { link = "Function" },
    ["@constructor"]                 = { link = "Punctuation" },
    ["@lsp.type.punct"]              = { link = "Punctuation" },
    ["@lsp.type.punctuation"]        = { link = "Punctuation" },

    -- Neutralize all other tree-sitter groups
    ["@keyword"]                     = { fg = colors.fg1 },
    ["@keyword.conditional"]         = { fg = colors.fg1 },
    ["@keyword.debug"]               = { fg = colors.fg1 },
    ["@keyword.directive"]           = { fg = colors.fg1 },
    ["@keyword.directive.define"]    = { fg = colors.fg1 },
    ["@keyword.exception"]           = { fg = colors.fg1 },
    ["@keyword.function"]            = { fg = colors.fg1 },
    ["@keyword.import"]              = { fg = colors.fg1 },
    ["@keyword.operator"]            = { fg = colors.fg1 },
    ["@keyword.repeat"]              = { fg = colors.fg1 },
    ["@keyword.return"]              = { fg = colors.fg1 },
    ["@keyword.storage"]             = { fg = colors.fg1 },
    ["@conditional"]                 = { fg = colors.fg1 },
    ["@repeat"]                      = { fg = colors.fg1 },
    ["@debug"]                       = { fg = colors.fg1 },
    ["@label"]                       = { fg = colors.fg1 },
    ["@include"]                     = { fg = colors.fg1 },
    ["@exception"]                   = { fg = colors.fg1 },
    ["@type"]                        = { fg = colors.fg1 },
    ["@type.builtin"]                = { fg = colors.fg1 },
    ["@type.definition"]             = { fg = colors.fg1 },
    ["@type.qualifier"]              = { fg = colors.fg1 },
    ["@storageclass"]                = { fg = colors.fg1 },
    ["@attribute"]                   = { fg = colors.fg1 },
    ["@field"]                       = { fg = colors.fg1 },
    ["@property"]                    = { fg = colors.fg1 },
    ["@variable"]                    = { fg = colors.fg1 },
    ["@variable.builtin"]            = { fg = colors.fg1 },
    ["@variable.member"]             = { fg = colors.fg1 },
    ["@variable.parameter"]          = { fg = colors.fg1 },
    ["@module"]                      = { fg = colors.fg1 },
    ["@namespace"]                   = { fg = colors.fg1 },
    ["@symbol"]                      = { fg = colors.fg1 },
    ["@text"]                        = { fg = colors.fg1 },
    ["@tag"]                         = { fg = colors.fg1 },
    ["@tag.attribute"]               = { fg = colors.fg1 },
    ["@tag.delimiter"]               = { fg = colors.fg1 },
    ["@punctuation"]                 = { fg = colors.punctuation },
    ["@macro"]                       = { fg = colors.fg1 },
    ["@structure"]                   = { fg = colors.fg1 },
    -- More granular Svelte highlighting (if your syntax highlighter supports it)
    ["@svelte.tag"]                  = { fg = colors.definition },  -- Blue for component tags
    ["@svelte.component"]            = { fg = colors.definition },  -- Blue for component names
    ["@svelte.directive"]            = { fg = colors.string },      -- Green for directives
    ["@svelte.directive.special"]    = { fg = colors.constant },    -- Purple for {#if}, {#each}, etc.
    ["@svelte.expression"]           = { fg = colors.constant },    -- Purple for {expression}
    ["@svelte.braces"]               = { fg = colors.punctuation }, -- Subtle for braces
    ["@svelte.attribute"]            = { fg = colors.string },      -- Green for attributes
    ["@svelte.event"]                = { fg = colors.string },      -- Green for event handlers
    ["@svelte.reactive"]             = { fg = colors.constant },    -- Purple for $: and $store
    ["@svelte.script"]               = { link = "javascript" },     -- Inherit from JavaScript
    ["@svelte.style"]                = { link = "css" },            -- Inherit from CSS
  }

  -- Apply any user overrides
  for group, hl in pairs(config.overrides) do
    if groups[group] then
      groups[group].link = nil
    end
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
