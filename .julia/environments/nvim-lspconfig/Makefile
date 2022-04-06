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
	cat ${SRCDIR}/Example.jl > src/Example.jl && \
	JULIA_TRACE_COMPILE=1 nvim src/Example.jl && \
	rm -rf $${TMPDIR}

bin/julia:
	mkdir -p bin
	rm -f bin/julia
	echo "#!/bin/bash" > bin/julia
	echo "JULIA=${JULIA}" >> bin/julia
	echo "if [[ \$${JULIA_TRACE_COMPILE} = \"1\" ]]; then" >> bin/julia
	echo "    exec \$${JULIA} --trace-compile=${PWD}/packagecompiler/precompile_statements.jl \"\$$@\"" >> bin/julia
	echo "elif [[ -f ${PWD}/$(SYSIMAGE) ]]; then" >> bin/julia
	echo "    exec \$${JULIA} --sysimage=${PWD}/$(SYSIMAGE) \"\$$@\"" >> bin/julia
	echo "else" >> bin/julia
	echo "    exec \$${JULIA} \"\$$@\"" >> bin/julia
	echo "fi" >> bin/julia
	chmod +x bin/julia

clean:
	rm -rf $(SYSIMAGE) packagecompiler bin

.PHONY: clean default
