defmodule Generate do
  def build_all do
    {:ok, files} = File.ls("lib/backcaster/flows/files/")

    files
    |> Enum.map(
         fn file ->
           String.trim_trailing(file, ".json")
           |> String.to_atom()
           |> build_mod()
         end
       )
  end

  def build_mod(module_name) do
    {:ok, json} = get_json("lib/backcaster/flows/files/#{Atom.to_string(module_name)}.json")
    params = gen_params(json)
    Module.create(module_name, mod_contents(params), Macro.Env.location(__ENV__))
  end

  def run_module(module_name_str) do
    module_name = String.to_existing_atom(module_name_str)
    initial_state = %{state: "A"}
    IO.inspect(module_name.get_state_option(initial_state))
    IO.inspect(module_name.first_state)
    IO.inspect(module_name.last_state)

    initial_state
    |> module_name.get_next_state_from_selected_option("No")
    |> module_name.transition()

  end

  def mod_contents(%{states: states, transitions: transitions, state_qns: state_qns, start_state: start_state, end_state: end_state}) do
    quote do
      use Machinery,
          states: unquote(states),
          transitions: unquote(transitions)

      @state_qns unquote(state_qns)

      @first_state unquote(start_state)
      @last_state unquote(end_state)

      def get_state_options(%{state: state}) do
        @state_qns
        |> Map.get(state, %{})
        |> Map.keys()
        |> Enum.reverse
      end

      def first_state do
        %{state: @first_state}
      end

      def last_state do
        @last_state
      end

      def get_next_state_from_selected_option(%{state: state} = state_struct, selected_option) do
        next_state =
          @state_qns
          |> Map.get(state)
          |> Map.get(selected_option)

        {state_struct, next_state}
      end

      def transition({current_state, new_state_label}) do
        Machinery.transition_to(current_state, __MODULE__, new_state_label)
      end

      def is_finished?(state) do
        state.state == last_state()
      end

      def flow_chart do
        @state_qns
        |> Enum.reduce("flowchart TD\n", fn({key, paths}, acc) -> acc <> gen_paths(key, paths) end)
      end

      defp gen_paths(key, paths) do
        paths
        |> Enum.reduce("", fn({qn, to_state}, acc) -> acc <> "#{key}[#{key}] --> |#{qn}| #{to_state}[#{to_state}]\n" end)
      end

    end
  end

  def gen_params(state_qns) do
    gen_states =
      state_qns
      |> Enum.flat_map(fn {key, ste} -> Map.keys(ste) ++ [key] end)
      |> Enum.reverse
      |> Enum.reduce([], fn(ele, acc) -> add_state?(ele, acc) end)
      |> IO.inspect

    transitions =
      state_qns
      |> Enum.flat_map(fn {key, ste} -> %{key => Map.values(ste)} end)
      |> Map.new()

    %{
      states: gen_states,
      transitions: Macro.escape(transitions),
      state_qns: Macro.escape(state_qns),
      start_state: List.first(gen_states),
      end_state: List.last(gen_states)
    }
  end

  defp add_state?(ele, acc) do
    if Enum.any?(acc, fn x -> x == ele end) do
      acc
      else
      acc ++ [ele]
    end
  end

  def get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Jason.decode(body), do: {:ok, json}
  end

end