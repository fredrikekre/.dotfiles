if Base.isinteractive() &&
   (local REPL = get(Base.loaded_modules, Base.PkgId(Base.UUID("3fa0cd96-eef1-5676-8a61-b3b8758bbffb"), "REPL"), nothing); REPL !== nothing)

    # Exit Julia with :q, restart with :r
    pushfirst!(REPL.repl_ast_transforms, function(ast::Union{Expr,Nothing})
        function toplevel_quotenode(ast, s)
            return (Meta.isexpr(ast, :toplevel, 2) && ast.args[2] === QuoteNode(s)) ||
                   (Meta.isexpr(ast, :toplevel) && any(x -> toplevel_quotenode(x, s), ast.args))
        end
        if toplevel_quotenode(ast, :q)
            exit()
        elseif toplevel_quotenode(ast, :r)
            argv = Base.julia_cmd().exec
            opts = Base.JLOptions()
            if opts.project != C_NULL
                push!(argv, "--project=$(unsafe_string(opts.project))")
            end
            if opts.nthreads != 0
                push!(argv, "--threads=$(opts.nthreads)")
            end
            @ccall execv(argv[1]::Cstring, argv::Ref{Cstring})::Cint
        end
        return ast
    end)

    # Automatically load tooling on demand:
    # - Debugger.jl when encountering @enter or @run
    # - BenchmarkTools.jl when encountering @btime or @benchmark
    pushfirst!(REPL.repl_ast_transforms, function(ast::Union{Expr,Nothing})
        function contains_macro(ast, m)
            return ast isa Expr && (
                (Meta.isexpr(ast, :macrocall) && ast.args[1] === m) ||
                any(x -> contains_macro(x, m), ast.args)
            )
        end
        if !isdefined(Main, :Debugger) && (
            contains_macro(ast, Symbol("@enter")) || contains_macro(ast, Symbol("@run"))
        )
            @info "Loading Debugger ..."
            try
                Core.eval(Main, :(using Debugger))
            catch
            end
        elseif !isdefined(Main, :BenchmarkTools) && (
            contains_macro(ast, Symbol("@btime")) || contains_macro(ast, Symbol("@benchmark"))
        )
            @info "Loading BenchmarkTools ..."
            try
                Core.eval(Main, :(using BenchmarkTools))
            catch
            end
        end
        return ast
    end)

end
