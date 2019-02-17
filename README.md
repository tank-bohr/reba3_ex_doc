rebar3_ex_doc
=====

A rebar plugin to build ex_doc documentation for the erlang edoc-annotated libraries

Build
-----

    $ rebar3 compile

Use
---

Add the plugin to your rebar config:

```erlang
    {plugins, [
        {rebar3_ex_doc, {git, "https://host/user/rebar3_ex_doc.git", {branch, "master"}}}
    ]}.

    {ex_doc, [
        {source_url, "https://github.com/<owner>/<repo>"}
    ]}.
```

Then just call your plugin directly in an existing application:

```shell
    $ rebar3 ex_doc
```
