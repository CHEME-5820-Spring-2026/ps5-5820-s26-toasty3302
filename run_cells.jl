using JSON

function run_all()
    nb_path = joinpath(@__DIR__, "PS5-CHEME-5820-Student-AE-S2025.ipynb")
    nb = JSON.parsefile(nb_path)

    cells = nb["cells"]
    n_code = 0
    n_err = 0
    for (i, cell) in enumerate(cells)
        if cell["cell_type"] == "code"
            n_code += 1
            src = join(cell["source"], "")
            cid = get(cell, "id", "cell_$i")
            println("\n===== CELL $n_code id=$cid (index $i) =====")
            flush(stdout)
            try
                Base.include_string(Main, src)
                println("[OK] cell $cid")
                flush(stdout)
            catch e
                n_err += 1
                println("[ERR] cell $cid: ", sprint(showerror, e))
                for (k, frame) in enumerate(stacktrace(catch_backtrace())[1:min(end, 10)])
                    println("   ", frame)
                end
                flush(stdout)
            end
        end
    end
    println("\nDONE. Total code cells executed: $n_code, errors: $n_err")
end

run_all()

println("\n===== DQ CHECK =====")
for name in (:did_I_answer_DQ1, :did_I_answer_DQ2, :did_I_answer_DQ3)
    if isdefined(Main, name)
        println("  $name = ", getfield(Main, name))
    else
        println("  $name = UNDEFINED")
    end
end
