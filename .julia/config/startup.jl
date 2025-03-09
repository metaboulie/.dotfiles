using Pkg
Pkg.activate(".")
Pkg.instantiate()
ENV["JULIA_EDITOR"] = "nvim"

Pkg.precompile(; timing=true)

#=
Revise.jl: Automatically update function definitions in a running Julia session 
- https://timholy.github.io/Revise.jl/stable/config/
=#
try
    using Revise
    using DispatchDoctor: @stable
    using BenchmarkTools
    using TimerOutputs
    using JET
    using Pluto
catch e
    @warn "Startup error" exception = (e, catch_backtrace())
end

#=
Plugin link:
- https://juliaci.github.io/PkgTemplates.jl/stable/user/#Plugins

How to use:
julia> t = Template();
julia> t("PkgName")

* if a plugin is commented with `template`, then it can be customed with a template
- https://juliaci.github.io/PkgTemplates.jl/stable/user/#Custom-Template-Files
=#
function template()
    @eval begin
        using PkgTemplates
        PkgTemplates.Template(;
            dir="~/dev/julia",
            plugins=[
                PkgTemplates.ProjectFile(; version=v"0.1.0-DEV"),
                PkgTemplates.SrcDir(;), # template
                PkgTemplates.Tests(; # template
                    project=true,
                    aqua=true,
                    aqua_kwargs=(ambiguities=false,),
                    jet=true,
                ),
                PkgTemplates.Readme(;), # template
                PkgTemplates.License(; name="MIT"),
                PkgTemplates.Git(;),
                PkgTemplates.GitHubActions(; osx=true, windows=true, x86=true), # template
                PkgTemplates.GitHubActions(;
                    file=joinpath(@__DIR__, "Format.yml"), destination="Format.yml"
                ),
                PkgTemplates.CompatHelper(;), # gh action
                PkgTemplates.TagBot(;), # gh action
                PkgTemplates.Dependabot(;), # gh action
                PkgTemplates.Codecov(;),
                # https://documenter.juliadocs.org/stable/man/hosting/#Hosting-Documentation
                PkgTemplates.Documenter{GitHubActions}(;), # template gh action
                PkgTemplates.BlueStyleBadge(;),
                # PkgTemplates.Develop(),
                PkgTemplates.Citation(; readme=true), # template
                PkgTemplates.Formatter(; style="blue"), # template
            ],
        )
    end
end
