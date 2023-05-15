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
            # @ccall execv(argv[1]::Cstring, argv::Ref{Cstring})::Cint
            ccall(:execv, Cint, (Cstring, Ref{Cstring}), argv[1], argv)
        end
        return ast
    end)

    # Automatically load tooling on demand:
    # - BenchmarkTools.jl when encountering @btime or @benchmark
    # - Cthulhu.jl when encountering @descend(_code_(typed|warntype))
    # - Debugger.jl when encountering @enter or @run
    # - Profile.jl when encountering @profile
    # - ProfileView.jl when encountering @profview
    # - Test.jl when encountering @test, @testset, @test_xxx, ...
    local tooling_dict = Dict{Symbol,Vector{Symbol}}(
        :BenchmarkTools => Symbol.(["@btime", "@benchmark"]),
        :Cthulhu        => Symbol.(["@descend", "@descend_code_typed", "@descend_code_warntype"]),
        :Debugger       => Symbol.(["@enter", "@run"]),
        :Profile        => Symbol.(["@profile"]),
        :ProfileView    => Symbol.(["@profview"]),
        :Test           => Symbol.([
                               "@test", "@testset", "@test_broken", "@test_deprecated",
                               "@test_logs", "@test_nowarn", "@test_skip",
                               "@test_throws", "@test_warn",
                           ]),
    )
    pushfirst!(REPL.repl_ast_transforms, function(ast::Union{Expr,Nothing})
        function contains_macro(ast, m)
            return ast isa Expr && (
                (Meta.isexpr(ast, :macrocall) && ast.args[1] === m) ||
                any(x -> contains_macro(x, m), ast.args)
            )
        end
        for (mod, macros) in tooling_dict
            if any(contains_macro(ast, s) for s in macros) && !isdefined(Main, mod)
                @info "Loading $mod ..."
                try
                    Core.eval(Main, :(using $mod))
                catch err
                    @info "Failed to automatically load $mod" exception=err
                end
            end
        end
        return ast
    end)

end
