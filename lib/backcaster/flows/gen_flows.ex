defmodule GenFlows do
  def build_all do
    file_path = get_file_path()
    IO.inspect(file_path)

    {:ok, files} = File.ls(file_path)

    files
    |> Enum.map(
         fn file ->
           String.trim_trailing(file, ".json")
           |> build_mod(file_path)
         end
       )
  end

  def build_mod(module_name, file_path) do
    case get_json("#{file_path}#{module_name}.json") do
      {:ok, json} -> Module.create(String.to_atom(module_name), mod_contents(gen_params(json)), Macro.Env.location(__ENV__))
      _ -> nil
    end
  end

  def mod_contents(%{states: states, transitions: transitions, state_qns: state_qns, start_state: start_state, end_states: end_states}) do
    quote do
      use Machinery,
          states: unquote(states),
          transitions: unquote(transitions)

      @state_qns unquote(state_qns)

      @first_state unquote(start_state)
      @last_states unquote(end_states)

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
        |> Enum.map(fn {qn, end_state} -> qn end)
      end

      def first_state do
        %{state: @first_state}
      end

      def last_states do
        @last_states
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
        Enum.any?(last_states(), fn st -> st == state.state end)
      end

      def flow_chart do
        @state_qns
        |> Enum.reduce("flowchart TD\n", fn({_key, paths}, acc) -> acc <> gen_paths(paths.label, paths.values) end)
      end

      defp gen_paths(label, paths) do
        paths
        |> Enum.reduce("", fn({qn, to_state}, acc) -> acc <> gen_path_string(HtmlSanitizeEx.strip_tags(label), qn, HtmlSanitizeEx.strip_tags(to_state)) end)
      end
      
    defp gen_path_string(label, qn, to_state) do
        "#{replace_space(label)}[\"#{label}\"] --> |#{qn}| #{replace_space(to_state)}[\"#{to_state}\"]\n"
    end

      defp replace_space(label) do
        label
        |> String.replace(" ", "_")
        |> String.replace("’", "")
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
      |> Enum.flat_map(fn {_key, ste} -> Enum.map(ste.values, fn({_qn, end_state}) -> end_state end) ++ [ste.label] end)
      |> MapSet.new()
      |> MapSet.to_list()

    transitions =
      state_qns
      |> Enum.flat_map(fn {_key, ste} -> %{ste.label => get_transition_map(ste.values)} end)
      |> Map.new()

    end_states =
      gen_states
      |> Enum.filter(fn state -> Enum.count(Map.keys(transitions), fn key -> key == state end) == 0 end)

    %{
      states: gen_states,
      transitions: Macro.escape(transitions),
      state_qns: Macro.escape(state_qns),
      start_state: Map.get(state_qns, 0).label,
      end_states: end_states
    }
  end

  defp get_transition_map(vals) do
    Enum.map(vals, fn({_qn, end_state}) -> end_state end)
  end

  def get_file_path do
#    Debug info
    IO.inspect("CWD:")
    IO.inspect(File.cwd())
    IO.inspect(System.get_env("MIX_ENV"))


    {:ok, path} = File.cwd()

    case System.get_env("MIX_ENV") do
      "prod" -> "#{path}/lib/backcaster-0.1.0/priv/static/flows/"
      _ -> "#{path}/priv/static/flows/"
    end
  end

  def get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Jason.decode(body, %{objects: :ordered_objects})
      do
        {:ok, json}
      else
        err -> nil
      end
  end

end