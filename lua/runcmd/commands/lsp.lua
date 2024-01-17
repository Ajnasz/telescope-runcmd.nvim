local function _1_()
  return vim.lsp.buf.definition()
end
local function _2_()
  return vim.lsp.buf.hover()
end
local function _3_()
  return vim.lsp.buf.implementation()
end
local function _4_()
  return vim.lsp.buf.signature_help()
end
local function _5_()
  return vim.lsp.buf.add_workspace_folder()
end
local function _6_()
  return vim.lsp.buf.remove_workspace_folder()
end
local function _7_()
  return vim.lsp.buf.type_definition()
end
local function _8_()
  return vim.lsp.buf.rename()
end
local function _9_()
  return vim.lsp.buf.code_action()
end
local function _10_()
  return vim.lsp.buf.references()
end
local function _11_()
  return vim.lsp.diagnostic.show_line_diagnostics()
end
local function _12_()
  return vim.diagnostic.goto_prev()
end
local function _13_()
  return vim.diagnostic.goto_next()
end
local function _14_()
  return vim.lsp.diagnostic.set_loclist()
end
local function _15_()
  return vim.lsp.buf.format({async = true})
end
local function _16_()
  return vim.lsp.buf.outgoing_calls()
end
local function _17_()
  return vim.lsp.buf.document_symbol()
end
local function _18_()
  return vim.lsp.buf.document_highlight()
end
return {{name = "Definition", cmd = _1_, description = "Go to definition"}, {name = "Hover", cmd = _2_, description = "Displays hover information about the symbol under the cursor"}, {name = "Implementation", cmd = _3_, description = "Lists all the implementations for the symbol under the cursor"}, {name = "Signature Help", cmd = _4_, description = "Displays signature information about the symbol under the cursor"}, {name = "Add Workspace Folder", cmd = _5_, description = "Add workspace folder"}, {name = "Remove Workspace Folder", cmd = _6_, description = "Remove workspace folder"}, {name = "Type Definition", cmd = _7_, description = "Jumps to the definition of the type of the symbol under the cursor"}, {name = "Rename", cmd = _8_, description = "Rename symbol"}, {name = "CodeAction", cmd = _9_, description = "Selects a code action available at the current cursor position."}, {name = "References", cmd = _10_, description = "Lists all the references to the symbol under the cursor"}, {name = "Show Line Diagnostics", cmd = _11_, description = "Show line diagnostics"}, {name = "GotoPrevDiagnostic", cmd = _12_, description = "Go to previous diagnostic"}, {name = "GotoNextDiagnostic", cmd = _13_, description = "Go to next diagnostic"}, {name = "SetLoclist", cmd = _14_, description = "Set diagnostic location list"}, {name = "Format", cmd = _15_, description = "Format code (async)"}, {name = "Outgoing Calls", cmd = _16_, description = "Lists all the outgoing calls for the symbol under the cursor"}, {name = "Document Symbols", cmd = _17_, description = "Lists all the symbols of the current file"}, {name = "Document Highlight", cmd = _18_, description = "Highlights all the symbols of the current file"}}
