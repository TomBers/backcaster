defmodule Generate do

  def run do
    mods = [%{
      module_name: :hello,
      states: ["A", "B", "C"],
      transitions: %{
        "A" => ["B", "C"],
      },
      state_qns: %{
        "A" => %{
          "Yes" => "B",
          "No" => "C"
        }
      }
    }]

    mods
    |> Enum.map(fn params -> Module.create(params.module_name, mod_contents(params), Macro.Env.location(__ENV__)) end)


    :hello.get_state_options(%{state: "A"})

  end

  def mod_contents(%{states: states, transitions: transitions, state_qns: state_qns}) do
    quote do
      use Machinery,
          states: unquote(states),
          transitions: %{}

      @state_qns %{}

      def get_state_options(%{state: state}) do
        @state_qns |> Map.get(state) |> Map.keys() |> Enum.reverse
      end
    end
  end



#  def run do
#    mods = [:hello, :world]
#
#    contents =
#      quote do
#        def world, do: true
#      end
#
#    mods
#    |> Enum.map(fn nme -> Module.create(nme, contents, Macro.Env.location(__ENV__)) end)
#
#
#    IO.inspect(:hello.world())
#    IO.inspect(:world.world())
#  end


#  def run do
#    contents =
#      quote do
#        def world, do: true
#      end
#
#    Module.create(:hello, contents, Macro.Env.location(__ENV__))
#
#    :hello.world()
#  end

end