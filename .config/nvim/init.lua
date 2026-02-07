-- Space as leader key: <Space-w>, <Space-q> to save and quit
-- Needs to be set before any plugins are loaded
vim.g.mapleader = " "

-- Hacks: Suppress noisy LSP warnings.
local notify_original = vim.notify
vim.notify = function(msg, ...)
  if
    msg
    and (
      msg:match("position_encoding param is required")
      or msg:match("Defaulting to position encoding of the first client")
      or msg:match("multiple different client offset_encodings")
    )
  then
    return
  end
  return notify_original(msg, ...)
end

require("lazy_plugins")
require("settings")
require("mappings")
require("commands")
require("custom")
