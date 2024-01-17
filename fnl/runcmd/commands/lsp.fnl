[
 {
  :name "Definition"
  :cmd #(vim.lsp.buf.definition)
  :description "Go to definition"
  }

 {
  :name "Hover"
  :cmd #(vim.lsp.buf.hover)
  :description "Displays hover information about the symbol under the cursor"
  }

 {
  :name "Implementation"
  :cmd #(vim.lsp.buf.implementation)
  :description "Lists all the implementations for the symbol under the cursor"
  }

 {
  :name "Signature Help"
  :cmd #(vim.lsp.buf.signature_help)
  :description "Displays signature information about the symbol under the cursor"
  }

 {
  :name "Add Workspace Folder"
  :cmd #(vim.lsp.buf.add_workspace_folder)
  :description "Add workspace folder"
  }

 {
  :name "Remove Workspace Folder"
  :cmd #(vim.lsp.buf.remove_workspace_folder)
  :description "Remove workspace folder"
  }

 {
  :name "Type Definition"
  :cmd #(vim.lsp.buf.type_definition)
  :description "Jumps to the definition of the type of the symbol under the cursor"
  }

 {
  :name "Rename"
  :cmd #(vim.lsp.buf.rename)
  :description "Rename symbol"
  }

 {
  :name "CodeAction"
  :cmd #(vim.lsp.buf.code_action)
  :description "Selects a code action available at the current cursor position."
  }

 {
  :name "References"
  :cmd #(vim.lsp.buf.references)
  :description "Lists all the references to the symbol under the cursor"
  }

 {
  :name "Show Line Diagnostics"
  :cmd #(vim.lsp.diagnostic.show_line_diagnostics)
  :description "Show line diagnostics"
  }

 {
  :name "GotoPrevDiagnostic"
  :cmd #(vim.diagnostic.goto_prev)
  :description "Go to previous diagnostic"
  }

 {
  :name "GotoNextDiagnostic"
  :cmd #(vim.diagnostic.goto_next)
  :description "Go to next diagnostic"
  }

 {
  :name "SetLoclist"
  :cmd #(vim.lsp.diagnostic.set_loclist)
  :description "Set diagnostic location list"
  }

 {
  :name "Format"
  :cmd #(vim.lsp.buf.format { :async true })
  :description "Format code (async)"
  }
 {
  :name "Outgoing Calls"
  :cmd #(vim.lsp.buf.outgoing_calls)
  :description "Lists all the outgoing calls for the symbol under the cursor"
  }
 {
  :name "Document Symbols"
  :cmd #(vim.lsp.buf.document_symbol)
  :description "Lists all the symbols of the current file"
  }
{
 :name "Document Highlight"
 :cmd #(vim.lsp.buf.document_highlight)
 :description "Highlights all the symbols of the current file"
 }
]
