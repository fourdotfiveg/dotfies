local snips = {}
local utils = require "snippets.utils"

local function branch()
  local handle = io.popen("git branch --show-current 2>/dev/null")
  local result = handle:read("*a")
  handle:close()
  return result:gsub("^(.-)%s$", "%1")
end

local function parse_clickup_ticket(s)
  return string.gsub(s, "(CU%-[0-9a-z]+).*", "%1")
end

snips._global = {
  todo = "TODO(babariviere): ",
  date = [[${=os.date("%Y-%m-%d")}]],
  branch = branch,
  clickup = function()
    return parse_clickup_ticket(branch()) or ""
  end,
  clickupr = function()
    return "[" .. parse_clickup_ticket(branch()) .. "]"
  end
}

snips.elixir = {
  --
  -- Functions
  --
  def = utils.match_indentation [[
def $1($2) do
  $0
end]],
  defp = utils.match_indentation [[
defp $1($2) do
  $0
end]],
  ["def:"] = "def ${1:myfunc}($2), do: $0",
  ["defp:"] = "defp ${1:myfunc}($2), do: $0",
  --
  -- Module
  --
  -- TODO(babariviere): try to determine module from path
  defm = utils.match_indentation [[
defmodule $1 do
  $0
end]],
  deft = utils.match_indentation [[
defmodule $1 do
  use ${2:$1}.${3:DataCase}
end
]],
  ["test"] = utils.match_indentation [[
test "$1" do
  $0
end]],
  --
  -- Blocks
  --
  ["do"] = utils.match_indentation [[
do
  $0
end]],
  ["do:"] = "do: $0",
  --
  -- Lambda
  --
  ["fn"] = "fn ${1:args} -> $0 end",
  --
  -- Conditions
  --
  ["case"] = utils.match_indentation [[
case $1 do
  $2 ->
    $0
end]],
  ["if"] = utils.match_indentation [[
if $1 do
  $0
end]],
  ["if:"] = utils.match_indentation "if $1, do: $0",
  ["ife:"] = utils.match_indentation "if $1, do: $2, else: $0",
  --
  -- Enum
  --
  ["map"] = "Enum.map($1, fn $2 -> $0 end)",
  ["each"] = "Enum.each($1, fn $2 -> $0 end)",
  --
  -- Pipe
  --
  ["p"] = "|> $0",
  [">e"] = "|> Enum.each(fn $1 -> $0 end)",
  [">i"] = "|> IO.inspect()",
  [">m"] = "|> Enum.map(fn $1 -> $0 end)",
  --
  -- IO
  --
  ["put"] = "IO.puts($1)",
  ["ins"] = "IO.inspect($1)",
  --
  -- Documentation
  --
  ["doc"] = utils.match_indentation [[
@doc """
$0
"""
]],
  iex = utils.comment_and_indent [[
    iex> $0]]
}

snips.go = {
  err = utils.match_indentation [[
if err != nil {
  return ${1:err}
}]]
}

snips.lua = {
  req = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = require '$1']],
  lambda = utils.match_indentation [[function () $0 end]],
  ["if"] = utils.match_indentation [[
if $1 then
  $0
end]]
}

local snippets = require "snippets"

snippets.snippets = snips
snippets.set_ux(require "snippets.inserters.select")
-- snippets.set_ux(require "snippets.inserters.vim_input")
-- snippets.use_suggested_mappings()

vim.g.completion_enable_snippet = "snippets.nvim"

local function insert_leave()
  snippets.abort_snippet()
end

vim.api.nvim_command("au InsertLeave * lua require('baba.snippets').insert_leave()")

return {
  expand_or_key = function(key)
    if snippets.advance_snippet(1) then
      return
    end
    if snippets.expand_at_cursor() then
      return
    end
    vim.fn.feedkeys(key, "n")
  end,
  insert_leave = insert_leave
}