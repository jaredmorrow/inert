%%% Copyright (c) 2013-2015, Michael Santos <michael.santos@gmail.com>
%%%
%%% Permission to use, copy, modify, and/or distribute this software for any
%%% purpose with or without fee is hereby granted, provided that the above
%%% copyright notice and this permission notice appear in all copies.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
%%% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
%%% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
%%% ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
%%% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
%%% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
%%% OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-module(inert).

%% API
-export([start/0, stop/0]).
-export([
        fdset/1, fdset/2,
        fdclr/1, fdclr/2,
        poll/1, poll/2,
        pollid/0
    ]).

start() ->
    Port = prim_inert:start(),
    try register(inert, Port)
    catch
        error:badarg -> ok
    end,
    unlink(Port),
    ok.

stop() ->
    prim_inert:stop(inert).

-spec pollid() -> 'undefined' | port().
pollid() ->
    whereis(inert).

-spec fdset(integer()) -> 'ok' | inert_drv:errno().
fdset(FD) ->
    fdset(FD, []).

-spec fdset(integer(), proplists:proplist()) -> 'ok' | inert_drv:errno().
fdset(FD, Options) ->
    prim_inert:fdset(inert, FD, Options).

-spec fdclr(integer()) -> 'ok' | inert_drv:errno().
fdclr(FD) ->
    fdclr(FD, []).

-spec fdclr(integer(), proplists:proplist()) -> 'ok' | inert_drv:errno().
fdclr(FD, Options) ->
    prim_inert:fdclr(inert, FD, Options).

-spec poll(integer()) ->
    {'ok','read'} | {'error','timeout'} | inert_drv:errno().
poll(FD) ->
    poll(FD, []).

-spec poll(integer(), proplists:proplist()) ->
    {'ok','read' | 'write'} | {'error','timeout'} | inert_drv:errno().
poll(FD, Options) ->
    prim_inert:poll(inert, FD, Options).
