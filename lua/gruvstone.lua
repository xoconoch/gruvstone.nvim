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
      punctuation    = {
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
  local colors     = get_colors()
  local config     = Gruvstone.config

  ---------------------------------------------------------------------------
  -- Helpers
  ---------------------------------------------------------------------------

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
    -- ============================================================================
    -- REQUIRED BASE SEMANTIC GROUPS (DO NOT REMOVE)
    -- ============================================================================

    Neutral                          = { fg = colors.fg1, bg = nil },
    NeutralFloat                     = { fg = colors.fg1, bg = float_bg },
    NeutralPanel                     = { fg = colors.fg1, bg = panel_bg },

    Punctuation                      = { fg = colors.punctuation.fg, bg = colors.punctuation.bg },

    String                           = { fg = colors.string.fg, bg = colors.string.bg },
    Constant                         = { fg = colors.constant.fg, bg = colors.constant.bg },
    Comment                          = { fg = colors.comment.fg, bg = colors.comment.bg },
    Function                         = { fg = colors.definition.fg, bg = colors.definition.bg },

    Error                            = { fg = colors.red },
    Warning                          = { fg = colors.yellow },
    Info                             = { fg = colors.blue },
    Hint                             = { fg = colors.aqua },

    -- ============================================================================
    -- CORE NORMAL GROUPS (THIS IS WHAT MAKES IT A THEME)
    -- ============================================================================

    Normal                           = { fg = colors.fg1, bg = neutral_bg },
    NormalFloat                      = { link = "NeutralFloat" },
    NormalNC                         = { link = "Neutral" },

    EndOfBuffer                      = { link = "Punctuation" },
    Whitespace                       = { fg = colors.bg2 },
    -- UI elements
    CursorLine                       = { bg = colors.bg1 },
    CursorColumn                     = { link = "CursorLine" },
    LineNr                           = { fg = colors.fg4 },
    CursorLineNr                     = { fg = colors.fg3, bg = colors.bg1 },
    SignColumn                       = config.transparent_mode and { bg = nil } or { bg = colors.bg1 },

    -- Visual selection and search
    Visual                           = { bg = colors.bg3, reverse = config.inverse },
    VisualNOS                        = { link = "Visual" },
    Search                           = { fg = colors.yellow, bg = colors.bg0, reverse = config.inverse },
    IncSearch                        = { fg = colors.orange, bg = colors.bg0, reverse = config.inverse },
    CurSearch                        = { link = "IncSearch" },

    -- Pmenu
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

    -- MiniStatusline
    MiniStatuslineDevinfo            = { link = "StatusLine" },
    MiniStatuslineFileinfo           = { link = "StatusLine" },
    MiniStatuslineFilename           = { link = "StatusLineNC" },
    MiniStatuslineInactive           = { link = "StatusLineNC" },

    -- Mode-specific status segments (fg from flat colors is OK)
    MiniStatuslineModeCommand        = { fg = colors.bg0, bg = colors.yellow },
    MiniStatuslineModeInsert         = { fg = colors.bg0, bg = colors.blue },
    MiniStatuslineModeNormal         = { fg = colors.bg0, bg = colors.fg1 },
    MiniStatuslineModeOther          = { fg = colors.bg0, bg = colors.aqua },
    MiniStatuslineModeReplace        = { fg = colors.bg0, bg = colors.red },
    MiniStatuslineModeVisual         = { fg = colors.bg0, bg = colors.green },
    MiniStatuslineModeSelect         = { fg = colors.bg0, bg = colors.purple },
    MiniStatuslineModeTerminal       = { fg = colors.bg0, bg = colors.orange },

    -- Diff
    DiffAdd                          = { bg = colors.dark_green },
    DiffDelete                       = { bg = colors.dark_red },
    DiffChange                       = { bg = colors.dark_aqua },
    DiffText                         = { bg = colors.yellow, fg = colors.bg0 },

    -- Diagnostics
    DiagnosticError                  = { link = "Error" },
    DiagnosticWarn                   = { link = "Warning" },
    DiagnosticInfo                   = { link = "Info" },
    DiagnosticHint                   = { link = "Hint" },
    DiagnosticOk                     = { link = "Neutral" },
    DiagnosticSignError              = { fg = colors.red, bg = colors.bg1 },
    DiagnosticSignWarn               = { fg = colors.yellow, bg = colors.bg1 },
    DiagnosticSignInfo               = { fg = colors.blue, bg = colors.bg1 },
    DiagnosticSignHint               = { fg = colors.aqua, bg = colors.bg1 },
    DiagnosticUnnecessary            = { link = "Punctuation" },

    -- Git signs (use flat color strings so they always show)
    GitSignsAdd                      = { fg = colors.green },
    GitSignsAddLn                    = { fg = colors.green },
    GitSignsAddNr                    = { fg = colors.green },
    GitSignsChange                   = { fg = colors.orange },
    GitSignsChangeLn                 = { fg = colors.orange },
    GitSignsChangeNr                 = { fg = colors.orange },
    GitSignsDelete                   = { fg = colors.red },
    GitSignsDeleteLn                 = { fg = colors.red },
    GitSignsDeleteNr                 = { fg = colors.red },

    -- General syntax
    Delimiter                        = { link = "Punctuation" },
    Operator                         = { link = "Punctuation" },
    Statement                        = { link = "Neutral" },

    -- Clojure
    clojureKeyword                   = { link = "Constant" },
    clojureCond                      = { link = "Neutral" },
    clojureSpecial                   = { link = "Neutral" },
    clojureDefine                    = { link = "Neutral" },
    clojureFunc                      = { link = "Function" },
    clojureRepeat                    = { link = "Neutral" },
    clojureCharacter                 = { link = "String" },
    clojureStringEscape              = { link = "Constant" },
    clojureException                 = { link = "Neutral" },
    clojureRegexp                    = { link = "String" },
    clojureRegexpEscape              = { link = "Constant" },
    clojureRegexpCharClass           = { link = "Neutral" },
    clojureRegexpMod                 = { link = "clojureRegexpCharClass" },
    clojureRegexpQuantifier          = { link = "clojureRegexpCharClass" },
    clojureParen                     = { link = "Punctuation" },
    clojureAnonArg                   = { link = "Neutral" },
    clojureVariable                  = { link = "Neutral" },
    clojureMacro                     = { link = "Function" },
    clojureMeta                      = { link = "Neutral" },
    clojureDeref                     = { link = "Neutral" },
    clojureQuote                     = { link = "Neutral" },
    clojureUnquote                   = { link = "Neutral" },

    -- C/C++
    cOperator                        = { link = "Constant" },
    cppOperator                      = { link = "Constant" },
    cStructure                       = { link = "Neutral" },

    -- Python
    pythonBuiltin                    = { link = "Function" },
    pythonBuiltinObj                 = { link = "Function" },
    pythonBuiltinFunc                = { link = "Function" },
    pythonFunction                   = { link = "Function" },
    pythonDecorator                  = { link = "Function" },
    pythonInclude                    = { link = "Neutral" },
    pythonImport                     = { link = "Neutral" },
    pythonRun                        = { link = "Neutral" },
    pythonCoding                     = { link = "Neutral" },
    pythonOperator                   = { link = "Neutral" },
    pythonException                  = { link = "Neutral" },
    pythonExceptions                 = { link = "Constant" },
    pythonBoolean                    = { link = "Constant" },
    pythonDot                        = { link = "Punctuation" },
    pythonConditional                = { link = "Neutral" },
    pythonRepeat                     = { link = "Neutral" },
    pythonDottedName                 = { link = "Function" },

    -- CSS
    cssBraces                        = { link = "Punctuation" },
    cssFunctionName                  = { link = "Function" },
    cssIdentifier                    = { link = "Neutral" },
    cssClassName                     = { link = "Function" },
    cssColor                         = { link = "Constant" },
    cssSelectorOp                    = { link = "Punctuation" },
    cssSelectorOp2                   = { link = "Punctuation" },
    cssImportant                     = { link = "Constant" },
    cssVendor                        = { link = "Neutral" },
    cssTextProp                      = { link = "Neutral" },
    cssAnimationProp                 = { link = "Neutral" },
    cssUIProp                        = { link = "Neutral" },
    cssTransformProp                 = { link = "Function" },
    cssTransitionProp                = { link = "Neutral" },
    cssPrintProp                     = { link = "Neutral" },
    cssPositioningProp               = { link = "Neutral" },
    cssBoxProp                       = { link = "Neutral" },
    cssFontDescriptorProp            = { link = "Neutral" },
    cssFlexibleBoxProp               = { link = "Neutral" },
    cssBorderOutlineProp             = { link = "Neutral" },
    cssBackgroundProp                = { link = "Neutral" },
    cssMarginProp                    = { link = "Neutral" },
    cssListProp                      = { link = "Neutral" },
    cssTableProp                     = { link = "Neutral" },
    cssFontProp                      = { link = "Neutral" },
    cssPaddingProp                   = { link = "Neutral" },
    cssDimensionProp                 = { link = "Neutral" },
    cssRenderProp                    = { link = "Neutral" },
    cssColorProp                     = { link = "Neutral" },
    cssGeneratedContentProp          = { link = "Neutral" },

    -- JS/TS
    javaScriptBraces                 = { link = "Punctuation" },
    javaScriptFunction               = { link = "Function" },
    javaScriptIdentifier             = { link = "Neutral" },
    javaScriptMember                 = { link = "Neutral" },
    javaScriptNumber                 = { link = "Constant" },
    javaScriptNull                   = { link = "Constant" },
    javaScriptParens                 = { link = "Punctuation" },

    typescriptReserved               = { link = "Neutral" },
    typescriptLabel                  = { link = "Neutral" },
    typescriptFuncKeyword            = { link = "Function" },
    typescriptIdentifier             = { link = "Neutral" },
    typescriptBraces                 = { link = "Punctuation" },
    typescriptEndColons              = { link = "Punctuation" },
    typescriptDOMObjects             = { link = "Neutral" },
    typescriptAjaxMethods            = { link = "Function" },
    typescriptLogicSymbols           = { link = "Neutral" },
    typescriptDocSeeTag              = { link = "Comment" },
    typescriptDocParam               = { link = "Comment" },
    typescriptDocTags                = { link = "Comment" },
    typescriptGlobalObjects          = { link = "Function" },
    typescriptParens                 = { link = "Punctuation" },
    typescriptOpSymbols              = { link = "Punctuation" },
    typescriptHtmlElemProperties     = { link = "Neutral" },
    typescriptNull                   = { link = "Constant" },
    typescriptInterpolationDelimiter = { link = "Punctuation" },

    -- PureScript
    purescriptModuleKeyword          = { link = "Neutral" },
    purescriptModuleName             = { link = "Function" },
    purescriptWhere                  = { link = "Neutral" },
    purescriptDelimiter              = { link = "Punctuation" },
    purescriptType                   = { link = "Neutral" },
    purescriptImportKeyword          = { link = "Neutral" },
    purescriptHidingKeyword          = { link = "Neutral" },
    purescriptAsKeyword              = { link = "Neutral" },
    purescriptStructure              = { link = "Neutral" },
    purescriptOperator               = { link = "Punctuation" },
    purescriptTypeVar                = { link = "Neutral" },
    purescriptConstructor            = { link = "Neutral" },
    purescriptFunction               = { link = "Function" },
    purescriptConditional            = { link = "Neutral" },
    purescriptBacktick               = { link = "Punctuation" },

    -- Typst
    typstCommentBlock                = { link = "Comment" },
    typstCommentLine                 = { link = "Comment" },
    typstCommentTodo                 = { link = "Comment" },

    typstCodeConditional             = { link = "Neutral" },
    typstCodeRepeat                  = { link = "Neutral" },
    typstCodeKeyword                 = { link = "Neutral" },
    typstCodeStatementWord           = { link = "Neutral" },

    typstCodeIdentifier              = { link = "Neutral" },
    typstCodeFunction                = { link = "Function" },
    typstCodeConstant                = { link = "Constant" },
    typstCodeNumberInteger           = { link = "Constant" },
    typstCodeNumberFloat             = { link = "Constant" },
    typstCodeNumberLength            = { link = "Constant" },
    typstCodeNumberAngle             = { link = "Constant" },
    typstCodeNumberRatio             = { link = "Constant" },
    typstCodeNumberFraction          = { link = "Constant" },
    typstCodeString                  = { link = "String" },
    typstCodeLabel                   = { link = "Neutral" },
    typstCodeFieldAccess             = { link = "Neutral" },

    typstCodeParen                   = { link = "Punctuation" },
    typstCodeBrace                   = { link = "Punctuation" },
    typstCodeBracket                 = { link = "Punctuation" },
    typstCodeDollar                  = { link = "Punctuation" },

    -- Nix (fix special/error usage)
    nixBoolean                       = { link = "Constant" },
    nixNull                          = { link = "Constant" },
    nixRecKeyword                    = { link = "Neutral" },
    nixOperator                      = { link = "Neutral" },
    nixParen                         = { link = "Punctuation" },
    nixInteger                       = { link = "Constant" },
    nixComment                       = { link = "Comment" },
    nixTodo                          = { link = "Warning" }, -- TODO/FIXME -> warning
    nixInterpolation                 = { link = "Punctuation" },
    nixInterpolationParam            = { link = "Neutral" },
    nixSimpleString                  = { link = "String" },
    nixString                        = { link = "String" },
    nixSimpleStringSpecial           = { link = "Constant" },
    nixStringSpecial                 = { link = "Constant" },
    nixInvalidSimpleStringEscape     = { link = "Error" },
    nixInvalidStringEscape           = { link = "Error" },
    nixFunctionCall                  = { link = "Neutral" },
    nixPath                          = { link = "Constant" },
    nixHomePath                      = { link = "Constant" },
    nixSearchPathRef                 = { link = "Constant" },
    nixURI                           = { link = "String" },
    nixAttribute                     = { link = "Neutral" },
    nixAttributeDot                  = { link = "Punctuation" },
    nixAttributeAssignment           = { link = "Punctuation" },
    nixAttributeDefinition           = { link = "Neutral" },
    nixAttributeSet                  = { link = "Punctuation" },
    nixArgumentDefinitionWithDefault = { link = "Neutral" },
    nixArgumentDefinition            = { link = "Neutral" },
    nixArgumentEllipsis              = { link = "Punctuation" },
    nixArgOperator                   = { link = "Punctuation" },
    nixFunctionArgument              = { link = "Punctuation" },
    nixSimpleFunctionArgument        = { link = "Neutral" },
    nixList                          = { link = "Punctuation" },
    nixListBracket                   = { link = "Punctuation" },
    nixLetExprKeyword                = { link = "Neutral" },
    nixIfExprKeyword                 = { link = "Neutral" },
    nixWithExprKeyword               = { link = "Neutral" },
    nixAssertKeyword                 = { link = "Neutral" },
    nixBuiltin                       = { link = "Constant" },
    nixNamespacedBuiltin             = { link = "Constant" },

    -- CoffeeScript
    coffeeExtendedOp                 = { link = "Punctuation" },
    coffeeSpecialOp                  = { link = "Punctuation" },
    coffeeCurly                      = { link = "Punctuation" },
    coffeeParen                      = { link = "Punctuation" },
    coffeeBracket                    = { link = "Punctuation" },

    -- Ruby
    rubyStringDelimiter              = { link = "String" },
    rubyInterpolationDelimiter       = { link = "Punctuation" },
    rubyDefinedOperator              = { link = "Neutral" },

    -- Objective-C
    objcTypeModifier                 = { link = "Neutral" },
    objcDirective                    = { link = "Neutral" },

    -- Go
    goDirective                      = { link = "Neutral" },
    goConstants                      = { link = "Constant" },
    goDeclaration                    = { link = "Function" },
    goDeclType                       = { link = "Neutral" },
    goBuiltins                       = { link = "Function" },

    -- Lua
    luaIn                            = { link = "Neutral" },
    luaFunction                      = { link = "Function" },
    luaTable                         = { link = "Neutral" },

    -- MoonScript
    moonSpecialOp                    = { link = "Punctuation" },
    moonExtendedOp                   = { link = "Punctuation" },
    moonFunction                     = { link = "Function" },
    moonObject                       = { link = "Neutral" },

    -- Java
    javaAnnotation                   = { link = "Neutral" },
    javaDocTags                      = { link = "Comment" },
    javaCommentTitle                 = { link = "Comment" },
    javaParen                        = { link = "Punctuation" },
    javaParen1                       = { link = "Punctuation" },
    javaParen2                       = { link = "Punctuation" },
    javaParen3                       = { link = "Punctuation" },
    javaParen4                       = { link = "Punctuation" },
    javaParen5                       = { link = "Punctuation" },
    javaOperator                     = { link = "Punctuation" },
    javaVarArg                       = { link = "Neutral" },

    -- Elixir
    elixirDocString                  = { link = "Comment" },
    elixirStringDelimiter            = { link = "String" },
    elixirInterpolationDelimiter     = { link = "Punctuation" },
    elixirModuleDeclaration          = { link = "Function" },

    -- Scala
    scalaNameDefinition              = { link = "Function" },
    scalaCaseFollowing               = { link = "Neutral" },
    scalaCapitalWord                 = { link = "Function" },
    scalaTypeExtension               = { link = "Neutral" },
    scalaKeyword                     = { link = "Neutral" },
    scalaKeywordModifier             = { link = "Neutral" },
    scalaSpecial                     = { link = "Constant" },
    scalaOperator                    = { link = "Punctuation" },
    scalaTypeDeclaration             = { link = "Neutral" },
    scalaTypeTypePostDeclaration     = { link = "Neutral" },
    scalaInstanceDeclaration         = { link = "Neutral" },
    scalaInterpolation               = { link = "Punctuation" },

    -- Haskell
    haskellType                      = { link = "Neutral" },
    haskellIdentifier                = { link = "Function" },
    haskellSeparator                 = { link = "Punctuation" },
    haskellDelimiter                 = { link = "Punctuation" },
    haskellOperators                 = { link = "Punctuation" },
    haskellBacktick                  = { link = "Punctuation" },
    haskellStatement                 = { link = "Neutral" },
    haskellConditional               = { link = "Neutral" },
    haskellLet                       = { link = "Neutral" },
    haskellDefault                   = { link = "Neutral" },
    haskellWhere                     = { link = "Neutral" },
    haskellBottom                    = { link = "Neutral" },
    haskellImportKeywords            = { link = "Neutral" },
    haskellDeclKeyword               = { link = "Neutral" },
    haskellDecl                      = { link = "Function" },
    haskellDeriving                  = { link = "Neutral" },
    haskellAssocType                 = { link = "Neutral" },
    haskellNumber                    = { link = "Constant" },
    haskellPragma                    = { link = "Constant" },
    haskellTH                        = { link = "Function" },
    haskellForeignKeywords           = { link = "Neutral" },
    haskellKeyword                   = { link = "Neutral" },
    haskellFloat                     = { link = "Constant" },
    haskellInfix                     = { link = "Punctuation" },
    haskellQuote                     = { link = "String" },
    haskellShebang                   = { link = "Comment" },
    haskellLiquid                    = { link = "Constant" },
    haskellQuasiQuoted               = { link = "String" },
    haskellRecursiveDo               = { link = "Neutral" },
    haskellQuotedType                = { link = "Neutral" },
    haskellPreProc                   = { link = "Neutral" },
    haskellTypeRoles                 = { link = "Neutral" },
    haskellTypeForall                = { link = "Neutral" },
    haskellPatternKeyword            = { link = "Neutral" },

    -- JSON
    jsonKeyword                      = { link = "String" },
    jsonQuote                        = { link = "String" },
    jsonBraces                       = { link = "Punctuation" },
    jsonString                       = { link = "String" },

    -- C#
    csBraces                         = { link = "Punctuation" },
    csEndColon                       = { link = "Punctuation" },
    csLogicSymbols                   = { link = "Punctuation" },
    csParens                         = { link = "Punctuation" },
    csOpSymbols                      = { link = "Punctuation" },
    csInterpolationDelimiter         = { link = "Punctuation" },
    csInterpolationAlignDel          = { link = "Punctuation" },
    csInterpolationFormat            = { link = "String" },
    csInterpolationFormatDel         = { link = "Punctuation" },

    -- Rust
    rustSigil                        = { link = "Punctuation" },
    rustEscape                       = { link = "Constant" },
    rustStringContinuation           = { link = "String" },
    rustEnum                         = { link = "Neutral" },
    rustStructure                    = { link = "Neutral" },
    rustModPathSep                   = { link = "Punctuation" },
    rustCommentLineDoc               = { link = "Comment" },
    rustDefault                      = { link = "Neutral" },

    -- OCaml
    ocamlOperator                    = { link = "Punctuation" },
    ocamlKeyChar                     = { link = "Punctuation" },
    ocamlArrow                       = { link = "Punctuation" },
    ocamlInfixOpKeyword              = { link = "Neutral" },
    ocamlConstructor                 = { link = "Neutral" },

    -- HTML / XML
    htmlTag                          = { link = "Punctuation" },
    htmlEndTag                       = { link = "Punctuation" },
    htmlTagName                      = { link = "Function" },
    htmlArg                          = { link = "String" },
    htmlTagN                         = { link = "Function" },
    htmlSpecialTagName               = { link = "Function" },
    htmlLink                         = { link = "String", underline = config.underline },
    htmlSpecialChar                  = { link = "Constant" },

    xmlTag                           = { link = "Punctuation" },
    xmlEndTag                        = { link = "Punctuation" },
    xmlTagName                       = { link = "Function" },
    xmlEqual                         = { link = "Punctuation" },
    docbkKeyword                     = { link = "Function" },
    xmlDocTypeDecl                   = { link = "Comment" },
    xmlDocTypeKeyword                = { link = "Constant" },
    xmlCdataStart                    = { link = "Comment" },
    xmlCdataCdata                    = { link = "Constant" },
    dtdFunction                      = { link = "Comment" },
    dtdTagName                       = { link = "Constant" },
    xmlAttrib                        = { link = "String" },
    xmlProcessingDelim               = { link = "Comment" },
    dtdParamEntityPunct              = { link = "Comment" },
    dtdParamEntityDPunct             = { link = "Comment" },
    xmlAttribPunct                   = { link = "Comment" },
    xmlEntity                        = { link = "Constant" },
    xmlEntityPunct                   = { link = "Constant" },

    -- Svelte (use links)
    svelteTag                        = { link = "Function" },
    svelteComponentName              = { link = "Function" },
    svelteDirective                  = { link = "String" },
    svelteSpecialDirective           = { link = "Constant" },
    svelteInterpolation              = { link = "Constant" },
    svelteMustacheBraces             = { link = "Punctuation" },
    svelteShorthandAttribute         = { link = "String" },
    svelteKeyword                    = { link = "Neutral" },
    svelteScriptTag                  = { link = "htmlTag" },
    svelteStyleTag                   = { link = "htmlTag" },
    svelteScriptTagName              = { link = "htmlTagName" },
    svelteStyleTagName               = { link = "htmlTagName" },
    svelteAttribute                  = { link = "String" },
    svelteEventHandler               = { link = "String" },
    svelteSpecialExpression          = { link = "Constant" },
    svelteSpecialExpressionKeyword   = { link = "Neutral" },
    svelteSpecialExpressionBraces    = { link = "Punctuation" },
    svelteReactiveStatement          = { link = "Constant" },
    svelteStoreSubscript             = { link = "Constant" },
    svelteReactiveLabel              = { link = "Punctuation" },
    ["@svelte.script"]               = { link = "javascript" },
    ["@svelte.style"]                = { link = "css" },

    -- Markdown (preserve bg where given; use .fg where necessary)
    markdownH1                       = { link = "Function" },
    markdownH2                       = { link = "Function" },
    markdownH3                       = { link = "Function" },
    markdownH4                       = { link = "Function" },
    markdownH5                       = { link = "Function" },
    markdownH6                       = { link = "Function" },

    markdownH1Delimiter              = { link = "Punctuation" },
    markdownH2Delimiter              = { link = "Punctuation" },
    markdownH3Delimiter              = { link = "Punctuation" },
    markdownH4Delimiter              = { link = "Punctuation" },
    markdownH5Delimiter              = { link = "Punctuation" },
    markdownH6Delimiter              = { link = "Punctuation" },
    markdownHeadingDelimiter         = { link = "Punctuation" },
    markdownHeadingRule              = { link = "Punctuation" },

    markdownItalic                   = { link = "Neutral", italic = config.italic and config.italic.emphasis },
    markdownBold                     = { link = "Neutral", bold = config.bold },
    markdownBoldItalic               = { link = "Neutral", bold = config.bold, italic = config.italic and config.italic.emphasis },
    markdownStrike                   = { link = "Neutral", strikethrough = config.strikethrough },

    markdownItalicDelimiter          = { link = "Punctuation" },
    markdownBoldDelimiter            = { link = "Punctuation" },
    markdownBoldItalicDelimiter      = { link = "Punctuation" },
    markdownStrikeDelimiter          = { link = "Punctuation" },
    markdownBlockquote               = { link = "Comment" },
    markdownRule                     = { link = "Punctuation" },
    markdownListMarker               = { link = "Punctuation" },
    markdownOrderedListMarker        = { link = "Punctuation" },
    markdownCode                     = { fg = colors.constant.fg, bg = colors.bg1 },
    markdownCodeDelimiter            = { link = "Punctuation" },
    markdownCodeBlock                = { fg = colors.constant.fg, bg = colors.bg1 },
    markdownHighlight                = { fg = colors.constant.fg, bg = colors.bg1 },
    markdownLinkText                 = { link = "String" },
    markdownLinkTextDelimiter        = { link = "Punctuation" },
    markdownLinkDelimiter            = { link = "Punctuation" },
    markdownUrl                      = { link = "String", underline = config.underline },
    markdownUrlDelimiter             = { link = "Punctuation" },
    markdownUrlTitle                 = { link = "String" },
    markdownUrlTitleDelimiter        = { link = "Punctuation" },
    markdownAutomaticLink            = { link = "String" },
    markdownIdDeclaration            = { link = "Constant" },
    markdownId                       = { link = "Constant" },
    markdownIdDelimiter              = { link = "Punctuation" },
    markdownFootnote                 = { link = "Constant" },
    markdownFootnoteDefinition       = { link = "Constant" },
    markdownLineBreak                = { link = "Punctuation" },
    markdownEscape                   = { link = "Constant" },
    markdownError                    = { fg = colors.red },
    markdownYamlHead                 = { link = "Comment" },
    markdownValid                    = { link = "Neutral" },

    -- Tree-sitter mappings (keep links to semantic groups)
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

    ["@function"]                    = { link = "Function" },
    ["@function.builtin"]            = { link = "Function" },
    ["@function.call"]               = { link = "Function" },
    ["@function.macro"]              = { link = "Function" },
    ["@method"]                      = { link = "Function" },
    ["@method.call"]                 = { link = "Function" },
    ["@constructor"]                 = { link = "Punctuation" },
    ["@lsp.type.punctuation"]        = { link = "Punctuation" },

    ["@keyword"]                     = { link = "Neutral" },
    ["@keyword.conditional"]         = { link = "Neutral" },
    ["@keyword.debug"]               = { link = "Neutral" },
    ["@keyword.directive"]           = { link = "Neutral" },
    ["@keyword.exception"]           = { link = "Neutral" },
    ["@keyword.function"]            = { link = "Neutral" },
    ["@keyword.import"]              = { link = "Neutral" },
    ["@keyword.operator"]            = { link = "Neutral" },
    ["@keyword.repeat"]              = { link = "Neutral" },
    ["@keyword.return"]              = { link = "Neutral" },
    ["@keyword.storage"]             = { link = "Neutral" },
    ["@conditional"]                 = { link = "Neutral" },
    ["@repeat"]                      = { link = "Neutral" },
    ["@label"]                       = { link = "Neutral" },
    ["@include"]                     = { link = "Neutral" },
    ["@exception"]                   = { link = "Neutral" },
    ["@type"]                        = { link = "Neutral" },
    ["@storageclass"]                = { link = "Neutral" },
    ["@attribute"]                   = { link = "Neutral" },
    ["@field"]                       = { link = "Neutral" },
    ["@property"]                    = { link = "Neutral" },
    ["@variable"]                    = { link = "Neutral" },
    ["@variable.builtin"]            = { link = "Neutral" },
    ["@variable.member"]             = { link = "Neutral" },
    ["@variable.parameter"]          = { link = "Neutral" },
    ["@module"]                      = { link = "Neutral" },
    ["@namespace"]                   = { link = "Neutral" },
    ["@symbol"]                      = { link = "Neutral" },
    ["@text"]                        = { link = "Neutral" },
    ["@tag"]                         = { link = "Neutral" },
    ["@tag.attribute"]               = { link = "Neutral" },
    ["@tag.delimiter"]               = { link = "Neutral" },
    ["@punctuation"]                 = { link = "Punctuation" },
    ["@macro"]                       = { link = "Neutral" },
    ["@structure"]                   = { link = "Neutral" },

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

  -- IMPORTANT: background must be resolved before palette selection
  if vim.o.background ~= "light" and vim.o.background ~= "dark" then
    vim.o.background = "dark"
  end

  local groups = get_groups()

  -- add highlights
  for group, settings in pairs(groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

return Gruvstone
