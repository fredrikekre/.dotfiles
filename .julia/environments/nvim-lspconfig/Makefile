JULIA=$(shell which julia)
JULIA_PROJECT=
SRCDIR:=$(shell dirname $(abspath $(firstword $(MAKEFILE_LIST))))
ifeq ($(shell uname -s),Linux)
	SYSIMAGE=languageserver.so
else
	SYSIMAGE=languageserver.dylib
endif

default: $(SYSIMAGE)

$(SYSIMAGE): Manifest.toml packagecompiler/Manifest.toml packagecompiler/precompile_statements.jl
	JULIA_LOAD_PATH=${PWD}:${PWD}/packagecompiler:@stdlib ${JULIA} -e 'using PackageCompiler; PackageCompiler.create_sysimage(:LanguageServer, sysimage_path="$(SYSIMAGE)", precompile_statements_file="packagecompiler/precompile_statements.jl")'

Manifest.toml: Project.toml
	JULIA_LOAD_PATH=${PWD}/Project.toml:@stdlib ${JULIA} -e 'using Pkg; Pkg.instantiate()'

Project.toml:
	JULIA_LOAD_PATH=${PWD}/Project.toml:@stdlib ${JULIA} -e 'using Pkg; Pkg.add("LanguageServer")'

packagecompiler/Manifest.toml: packagecompiler/Project.toml
	JULIA_LOAD_PATH=${PWD}/packagecompiler/Project.toml:@stdlib ${JULIA} -e 'using Pkg; Pkg.instantiate()'

packagecompiler/Project.toml:
	mkdir -p packagecompiler
	JULIA_LOAD_PATH=${PWD}/packagecompiler/Project.toml:@stdlib ${JULIA} -e 'using Pkg; Pkg.add("PackageCompiler")'

packagecompiler/precompile_statements.jl: Manifest.toml bin/julia
	TMPDIR=$(shell mktemp -d) && \
	cd $${TMPDIR} && \
	JULIA_LOAD_PATH=: ${JULIA} -e 'using Pkg; Pkg.generate("Example")' 2> /dev/null && \
	cd Example && \
	JULIA_LOAD_PATH=$${PWD}:@stdlib ${JULIA} -e 'using Pkg; Pkg.add(["JSON", "fzf_jll", "Random", "Zlib_jll"])' 2> /dev/null && \
	JULIA_LOAD_PATH=$${PWD}:@stdlib ${JULIA} -e 'using Pkg; Pkg.precompile()' 2> /dev/null && \
	echo "$$PACKAGE_CONTENT" > src/Example.jl && \
	JULIA_TRACE_COMPILE=1 nvim src/Example.jl && \
	rm -rf $${TMPDIR}

bin/julia:
	mkdir -p bin
	echo "$$JULIA_SHIM" > $@
	chmod +x $@

clean:
	rm -rf $(SYSIMAGE) packagecompiler bin

.PHONY: clean default

export JULIA_SHIM
define JULIA_SHIM
#!/bin/bash
JULIA=${JULIA}
if [[ $${JULIA_TRACE_COMPILE} = "1" ]]; then
    exec $${JULIA} --trace-compile=${PWD}/packagecompiler/precompile_statements.jl "$$@"
elif [[ -f ${PWD}/$(SYSIMAGE) ]]; then
    exec $${JULIA} --sysimage=${PWD}/$(SYSIMAGE) "$$@"
else
    exec $${JULIA} "$$@"
fi
endef

export PACKAGE_CONTENT
define PACKAGE_CONTENT
# This file is opened in neovim with a LanguageServer.jl process that records Julia
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
    x = [1, 2, 3]
    for i in 1:length(x)
        println(x[i])
    end
end

end # module
endef
