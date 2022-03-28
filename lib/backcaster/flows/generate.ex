defmodule Generate do

#  iex(1)> so = %{state: "A"}
  #%{state: "A"}
  #iex(2)> Machinery.transition_to(so, SalesFlow, "B")
  #"Log transition"
  #{:ok, %{state: "B"}}

# Machinery.transition_to(so, SalesFlow, SalesFlow.get_next_state("Y"))


  def run(module_name) do
    {:ok, json} = get_json("lib/backcaster/flows/files/#{Atom.to_string(module_name)}.json")
    params = gen_params(json)

    Module.create(module_name, mod_contents(params), Macro.Env.location(__ENV__))


    module_name.get_state_options(%{state: "A"})

  end

  def mod_contents(%{states: states, transitions: transitions, state_qns: state_qns}) do
    quote do
      use Machinery,
          states: unquote(states),
          transitions: unquote(transitions)

      @state_qns unquote(state_qns)

      def get_state_options(%{state: state}) do
        @state_qns
        |> Map.get(state)
        |> Map.keys()
        |> Enum.reverse
      end
    end
  end

  def gen_params(%{"states" => states, "transitions" => transitions, "state_qns" => state_qns}) do
    %{
      states: states,
      transitions: Macro.escape(transitions),
      state_qns: Macro.escape(state_qns)
    }
  end

  def get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Jason.decode(body), do: {:ok, json}
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