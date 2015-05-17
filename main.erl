#!/usr/bin/env escript

main(P) ->
  [For|L] = P,
  {ok, Cwd} = file:get_cwd(),
  Matches = flatten(
    lists:map(
      fun(Dir) ->
        Absdir = case Dir of
          "" -> Cwd;
          [$/|_] -> Dir;
          _ -> Cwd ++ "/" ++ Dir
        end,
        case file:list_dir(Absdir) of
          {error, Why} ->
            if
              Why == enoent ->
                io:fwrite(standard_error, "Error: target dir ~s doesn't exist~n", [Dir]);
              true -> void
            end,
            error(Why);

          {ok, Files} ->
            Matched = lists:filter(
              fun(Name) ->
                case re:run(Name, For, [caseless]) of
                  {match, _} -> filelib:is_dir(Absdir ++ "/" ++ Name);
                  _ -> false
                end
              end, Files),
            [Absdir ++ "/" ++ File || File <- Matched]
        end
      end,
  L)),
  UniqMatches = sets:to_list(sets:from_list(Matches)),
  case UniqMatches of
    [] ->
      io:fwrite(standard_error, "No pattern ~s matched in ~p~n", [For, L]);
    _ ->
      MatchedLen = length(UniqMatches),
      case MatchedLen of
        1 ->
          io:format("~s~n", [lists:nth(1, UniqMatches)]);
        _ ->
          [io:fwrite(standard_error, "~p. ~s~n", [I, lists:nth(I, UniqMatches)]) ||
            I <- lists:seq(1, MatchedLen)],
          {ok, [Selected]} = io:fread("", "~d"),
          io:format("~s~n", [lists:nth(Selected, UniqMatches)])
      end
  end.

flatten([]) ->
  [];
flatten([H|T]) ->
  flatten(T, H).

flatten([H|T], Res) ->
  flatten(T, Res ++ H);
flatten([], Res) ->
  Res.
