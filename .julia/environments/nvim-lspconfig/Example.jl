# This file is opened in Neovim with a LanguageServer.jl process that records Julia
# compilation statements for creating a custom sysimage.
#
# This file has a bunch of linter errors which will exercise the linter and record
# statements for that. When the diagnostic messages corresponding to those errors show up in
# the buffer the language server should be ready to accept other commands (note: this may
# take a while -- be patient). Here are some suggestions for various LSP functionality that
# can be exercised (your regular keybindings should work):
#
#  - :lua vim.lsp.buf.hover()
#  - :lua vim.lsp.buf.definition()
#  - :lua vim.lsp.buf.references()
#  - :lua vim.lsp.buf.rename()
#  - :lua vim.lsp.buf.formatting()
#  - :lua vim.lsp.buf.formatting_sync()
#  - :lua vim.lsp.buf.code_action()
#  - Tab completion (if you have set this up using LSP)
#  - ...
#
# When you are finished, simply exit neovim and PackageCompiler.jl will use all the recorded
# statements to create a custom sysimage. This sysimage will be used for the language server
# process in the future, and should result in almost instant response.

module Example

import JSON
import fzf_jll
using Random
using Zlib_jll

function hello(who, notused)
    println("hello", who)
    shuffle([1, 2, 3])
   shoffle([1, 2, 3])
    fzzf = fzf_jll.fzzf()
    fzf = fzf_jll.fzf(1)
    JSON.print(stdout, Dict("hello" => [1, 2, 3]), 2, 123)
    JSON.print(stdout, Dict("hello" => [1, 2, 3]))
    hi(who)
    return Zlib_jll.libz
end

function world(s)
    if s == nothing
      hello(s)
  else
      hello(s)
  end
end

end # module
