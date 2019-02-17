-module(rebar3_ex_doc_prv).

-export([init/1, do/1, format_error/1]).

-define(PROVIDER, ex_doc).
-define(DEPS, [eep48]).

%% ===================================================================
%% Public API
%% ===================================================================
-spec init(rebar_state:t()) -> {ok, rebar_state:t()}.
init(State) ->
    Provider = providers:create([
            {name, ?PROVIDER},            % The 'user friendly' name of the task
            {module, ?MODULE},            % The module implementation of the task
            {bare, true},                 % The task can be run by the user, always true
            {deps, ?DEPS},                % The list of dependencies
            {example, "rebar3 ex_doc"},   % How to use the plugin
            {opts, []},                   % list of options understood by the plugin
            {short_desc, "Build ex_doc documentation"},
            {desc, "A rebar plugin to build ex_doc documentation
                for the erlang edoc-annotated libraries"},
            {profiles, [eep48]}
    ]),
    {ok, rebar_state:add_provider(State, Provider)}.


-spec do(rebar_state:t()) -> {ok, rebar_state:t()} | {error, string()}.
do(State) ->
    [AppInfo|_] = rebar_state:project_apps(State),
    Config = rebar_state:get(State, ex_doc),
    SourceUrl = proplists:get_value(source_url, Config),
    {ok, MixExs} = mix_exs_dtl:render([
        {app_name, rebar_app_info:name(AppInfo)},
        {app_version, vsn(AppInfo, State)},
        {source_url, SourceUrl},
        {homepage_url, proplists:get_value(homepage_url, Config, SourceUrl)},
        {main, proplists:get_value(main, Config, <<"readme">>)},
        {output, proplists:get_value(output, Config, <<"docs">>)},
        {source_beam, rebar_app_info:ebin_dir(AppInfo)},
        {lib_path, rebar_app_info:out_dir(AppInfo)}

    ]),
    ok = file:write_file("mix.exs", MixExs),
    rebar_utils:sh("mix deps.get", []),
    rebar_utils:sh("mix docs", []),
    {ok, State}.

-spec format_error(any()) ->  iolist().
format_error(Reason) ->
    io_lib:format("~p", [Reason]).

vsn(AppInfo, State) ->
    Version = rebar_app_info:original_vsn(AppInfo),
    rebar_utils:vcs_vsn(
        Version,
        rebar_app_info:dir(AppInfo),
        rebar_state:resources(State)
    ).
