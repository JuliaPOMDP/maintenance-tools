using MassInstallAction
using GitHub

auth = GitHub.authenticate(error("You need an authorization token"))

orgrepos, page_data = GitHub.repos("JuliaPOMDP")
# display([r.name for r in orgrepos])

# wf = MassInstallAction.tag_bot()
wfs = []
push!(wfs, MassInstallAction.compat_helper())
push!(wfs, MassInstallAction.Workflow("CI","CI.yml"=>read("CI.yml", String)))

skip = ["RLInterface.jl", "POMDPToolbox.jl", "POMDPReinforce.jl", "GenerativeModels.jl", "POMDPBounds.jl", "POMDPDistributions.jl", "POMCP.jl", "DESPOT.jl", "FactoredValueMCTS.jl", "DroneSurveillance.jl"]
repos = filter(orgrepos) do r
    return endswith(r.name, ".jl") && !endswith(r.name, "_jll.jl") && !in(r.name, skip)
end

display([r.name for r in orgrepos])

unsuccessful = []
for r in repos
    open_browser = false
    for wf in wfs
        try
            MassInstallAction.install(wf, r; auth=auth)
            println("""
                    ===========
                    $(r.name) Successful!
                    ===========
                    """)
            open_browser = true
            sleep(2.0)
        catch ex
            successful = false
            if ex isa ProcessFailedException
                @warn(r.name*": "*sprint(showerror, ex))
            elseif ex isa ErrorException && startswith(ex.msg, "Error found in GitHub reponse:\n\tStatus Code: 422")
                @warn(r.name*": "*sprint(showerror, ex))
            else
                push!(unsuccessful, r)
                @error sprint(showerror, ex)
            end
        end
    end

    if open_browser
        run(`google-chrome $("$(r.html_url)"*"/pulls")`)
    end
end

display([r.name for r in unsuccessful])
