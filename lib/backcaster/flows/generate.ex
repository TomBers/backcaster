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
        state = @state_qns
        |> Enum.find(%{}, fn {k, val} -> val.label == state end)

        return_state_options(state)
      end

      defp return_state_options(%{}) do
        []
      end

      defp return_state_options({_key, options}) do
        options.values
        |> Enum.map(fn {qn, end_state} -> end_state end)
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
          |> Enum.find(%{}, fn {k, val} -> val.label == state end)
          |> Kernel.then(fn {key, vals} -> Enum.find(vals.values, {nil, nil}, fn {key, val} -> key == selected_option end) end)
          |> Kernel.then(fn {_k, val} -> val end)

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
        |> Enum.reduce("flowchart TD\n", fn({_key, paths}, acc) -> acc <> gen_paths(paths.label, paths.values) end)
      end

      defp gen_paths(key, paths) do
        paths
        |> Enum.reduce("", fn({qn, to_state}, acc) -> acc <> "#{key}[#{key}] --> |#{qn}| #{to_state}[#{to_state}]\n" end)
      end

    end
  end

  def gen_params(json) do
    state_qns =
      json
      |> Enum.with_index()
      |> Enum.map(fn({{key, vals}, indx}) -> {indx, Map.put(vals, :label, key)} end)
      |> Map.new()

    gen_states =
      state_qns
      |> Enum.flat_map(fn {key, ste} -> Enum.map(ste.values, fn({qn, end_state}) -> end_state end) ++ [ste.label] end)
      |> MapSet.new()
      |> MapSet.to_list()

    transitions =
      state_qns
      |> Enum.flat_map(fn {key, ste} -> %{ste.label => get_transition_map(ste.values)} end)
      |> Map.new()

      end_index = length(Map.keys(state_qns)) - 1
      end_state =
        Map.get(state_qns, end_index)
        |> Kernel.then(fn ste -> List.last(ste.values) end)
        |> Kernel.then(fn {qn, last_state} -> last_state end)

    %{
      states: gen_states,
      transitions: Macro.escape(transitions),
      state_qns: Macro.escape(state_qns),
      start_state: Map.get(state_qns, 0).label,
      end_state: end_state
    }
  end

  defp get_transition_map(vals) do
    Enum.map(vals, fn({qn, end_state}) -> end_state end)
  end

  def get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Jason.decode(body, %{objects: :ordered_objects}), do: {:ok, json}
  end

end