if Base.isinteractive() &&
   (REPL = get(Base.loaded_modules, Base.PkgId(Base.UUID("3fa0cd96-eef1-5676-8a61-b3b8758bbffb"), "REPL"), nothing); REPL !== nothing)

   # Exit Julia with :q
    pushfirst!(REPL.repl_ast_transforms, function(ast::Expr)
        if Meta.isexpr(ast, :toplevel, 2) && ast.args[2] === QuoteNode(:q)
            exit()
        end
        return ast
    end)

    # Automatically load Debugger.jl when encountering @enter
    pushfirst!(REPL.repl_ast_transforms, function(ast::Expr)
        if Meta.isexpr(ast, :toplevel, 2) && Meta.isexpr(ast.args[2], :macrocall) &&
           ast.args[2].args[1] === Symbol("@enter") && !isdefined(Main, Symbol("@enter"))
           @info "Loading Debugger..."
           Core.eval(Main, :(using Debugger))
        end
        return ast
    end)
end
