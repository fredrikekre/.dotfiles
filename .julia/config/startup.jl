if Base.isinteractive() &&
   (local REPL = get(Base.loaded_modules, Base.PkgId(Base.UUID("3fa0cd96-eef1-5676-8a61-b3b8758bbffb"), "REPL"), nothing); REPL !== nothing)

    # Exit Julia with :q
    pushfirst!(REPL.repl_ast_transforms, function(ast::Union{Expr,Nothing})
        if Meta.isexpr(ast, :toplevel, 2) && ast.args[2] === QuoteNode(:q)
            exit()
        end
        return ast
    end)

    # Automatically load Debugger.jl when encountering @enter
    pushfirst!(REPL.repl_ast_transforms, function(ast::Union{Expr,Nothing})
        contains_enter(x) = false
        contains_enter(x::Expr) = (Meta.isexpr(x, :macrocall) && x.args[1] === Symbol("@enter")) ||
                                  any(contains_enter, x.args)
        if Meta.isexpr(ast, :toplevel, 2) && contains_enter(ast) && !isdefined(Main, Symbol("@enter"))
           @info "Loading Debugger..."
           Core.eval(Main, :(using Debugger))
        end
        return ast
    end)
end
