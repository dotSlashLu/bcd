#!/usr/bin/env escript

main(P) ->
  [For|L] = P,
  {ok, Cwd} = file:get_cwd(),
  Matches = flatten(lists:map(fun(Dir) ->
    Absdir = case Dir of
      "" -> Cwd;
      [$/|_] -> Dir;
      _ -> Cwd ++ [$/] ++ Dir
    end,
    {ok, Files} = file:list_dir(Absdir),
    Matched = lists:filter(fun(Name) ->
                            case re:run(Name, For, [caseless]) of
                              {match, _} -> true;
                              _ -> false
                            end
                          end, Files),
    [Absdir ++ [$/] ++ File || File <- Matched]
  end,
  L)),
  case Matches of
    [] ->
      io:fwrite(standard_error, "No pattern ~s match in ~p~n", [For, L]);
    _ ->
      MatchedLen = length(Matches),
      case MatchedLen of
        1 ->
          io:format("~s~n", [lists:nth(1, Matches)]);
        _ ->
          [io:fwrite(standard_error, "~p. ~s~n", [I, lists:nth(I, Matches)]) || I <- lists:seq(1, MatchedLen)],
          {ok, [Selected]} = io:fread("", "~d"),
          io:format("~s~n", [lists:nth(Selected, Matches)])
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
