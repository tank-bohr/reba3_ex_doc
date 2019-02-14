rebar3_ex_doc
=====

A rebar plugin

Build
-----

    $ rebar3 compile

Use
---

Add the plugin to your rebar config:

    {plugins, [
        {rebar3_ex_doc, {git, "https://host/user/rebar3_ex_doc.git", {tag, "0.1.0"}}}
    ]}.

Then just call your plugin directly in an existing application:


    $ rebar3 rebar3_ex_doc
    ===> Fetching rebar3_ex_doc
    ===> Compiling rebar3_ex_doc
    <Plugin Output>
