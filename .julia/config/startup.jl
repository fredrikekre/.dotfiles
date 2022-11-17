if Base.isinteractive() &&
   (local REPL = get(Base.loaded_modules, Base.PkgId(Base.UUID("3fa0cd96-eef1-5676-8a61-b3b8758bbffb"), "REPL"), nothing); REPL !== nothing)

    # Exit Julia with :q
    pushfirst!(REPL.repl_ast_transforms, function(ast::Union{Expr,Nothing})
        if Meta.isexpr(ast, :toplevel, 2) && ast.args[2] === QuoteNode(:q)
            exit()
        end
        return ast
    end)

    # Automatically load Debugger.jl when encountering @enter or @run and BenchmarkTools.jl
    # when encountering @btime or @benchmark.
    pushfirst!(REPL.repl_ast_transforms, function(ast::Union{Expr,Nothing})
        contains_macro(_, _) = false
        function contains_macro(x::Expr, s::Symbol)
            (Meta.isexpr(x, :macrocall) && x.args[1] === s) ||
            any(y -> contains_macro(y, s), x.args)
        end
        if Meta.isexpr(ast, :toplevel, 2) &&
           !isdefined(Main, :Debugger)    &&
           (contains_macro(ast, Symbol("@enter")) || contains_macro(ast, Symbol("@run")))
            @info "Loading Debugger ..."
            try
                Core.eval(Main, :(using Debugger))
            catch
            end
        elseif Meta.isexpr(ast, :toplevel, 2) &&
           !isdefined(Main, :BenchmarkTools)  &&
           (contains_macro(ast, Symbol("@btime")) || contains_macro(ast, Symbol("@benchmark")))
            @info "Loading BenchmarkTools ..."
            try
                Core.eval(Main, :(using BenchmarkTools))
            catch
            end
        end
        return ast
    end)
end
