module ProgramTestTests.SimulatedEffects.NavigationTest exposing (all)

import Expect
import Html
import ProgramTest
import SimulatedEffect.Cmd
import SimulatedEffect.Navigation
import Test exposing (..)
import TestingProgram exposing (Msg(..))


all : Test
all =
    describe "simulating browser navigation"
        [ test "can simulate a route change" <|
            \() ->
                TestingProgram.application SimulatedEffect.Cmd.none
                    |> ProgramTest.routeChange "https://example.com/new"
                    |> ProgramTest.expectModel (Expect.equal [ "https://example.com/new" ])
        , test "can simulate a route change with a relative URL" <|
            \() ->
                TestingProgram.application SimulatedEffect.Cmd.none
                    |> ProgramTest.routeChange "/new"
                    |> ProgramTest.expectModel (Expect.equal [ "https://example.com/new" ])
        , test "simulating a pushUrl triggers an onUrlChange" <|
            \() ->
                TestingProgram.application SimulatedEffect.Cmd.none
                    |> ProgramTest.update (ProduceEffects (SimulatedEffect.Navigation.pushUrl "new"))
                    |> ProgramTest.expectModel (Expect.equal [ "https://example.com/new" ])
        , test "simulating a pushUrl changes the browser URL" <|
            \() ->
                TestingProgram.application SimulatedEffect.Cmd.none
                    |> ProgramTest.update (ProduceEffects (SimulatedEffect.Navigation.pushUrl "new"))
                    |> ProgramTest.expectBrowserUrl (Expect.equal "https://example.com/new")
        , test "simulating a replaceUrl triggers an onUrlChange" <|
            \() ->
                TestingProgram.application SimulatedEffect.Cmd.none
                    |> ProgramTest.update (ProduceEffects (SimulatedEffect.Navigation.replaceUrl "/new"))
                    |> ProgramTest.expectModel (Expect.equal [ "https://example.com/new" ])
        , test "with a base url, expectUrl returns the base url" <|
            \() ->
                ProgramTest.createElement
                    { init = \() -> ( (), () )
                    , update = \msg () -> ( (), () )
                    , view = \_ -> Html.text ""
                    }
                    |> ProgramTest.withBaseUrl "https://example.com/start"
                    |> ProgramTest.start ()
                    |> ProgramTest.expectBrowserUrl (Expect.equal "https://example.com/start")
        , test "with no base url, simulating a pushUrl with an absolute path changes the browser URL" <|
            \() ->
                TestingProgram.startEffects (SimulatedEffect.Navigation.pushUrl "https://example.com/new")
                    |> ProgramTest.expectBrowserUrl (Expect.equal "https://example.com/new")
        , test "routeChange changes browser URL" <|
            \() ->
                TestingProgram.application SimulatedEffect.Cmd.none
                    |> ProgramTest.routeChange "https://example.com/new"
                    |> ProgramTest.expectBrowserUrl (Expect.equal "https://example.com/new")
        ]
