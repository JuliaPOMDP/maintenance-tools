using DocumenterTools

packages = [
# "POMDPs",
# "POMDPModelTools",
# "BeliefUpdaters",
# "POMDPPolicies",
# "POMDPSimulators",
# "POMDPModels",
# "POMDPTesting",
# "ParticleFilters",
# "DiscreteValueIteration",
# "LocalApproximationValueIteration",
# "GlobalApproximationValueIteration",
# "MCTS",
# "QMDP",
# "FIB",
# "BeliefGridValueIteration",
# "SARSOP",
# "BasicPOMCP",
# "ARDESPOT",
# "MCVI",
# "POMDPSolve",
# "IncrementalPruning",
# "POMCPOW",
# "AEMS",
# "PointBasedValueIteration",
"POMDPFiles",
"POMDPXFiles"
]

base_url(p) = "https://github.com/JuliaPOMDP/"*p*".jl"
newkey_url(p) = base_url(p)*"/settings/keys/new"
newsecret_url(p) = base_url(p)*"/settings/secrets/actions/new"

for p in packages
    DocumenterTools.genkeys()
    run(`google-chrome --new-window $(newkey_url(p)) $(newsecret_url(p))`)
    try
        readline()
    catch ex
        if ex isa InterruptException
            @warn("Preventing Accidental Interrupt")
            sleep(0.2)
        else
            rethrow(ex)
        end
    end
end
