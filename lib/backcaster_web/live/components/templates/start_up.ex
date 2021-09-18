defmodule Startup do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string


  def get_card_or_tbc(cards, key) do
    card = Map.get(cards, key, %{"content" => ""})
    card["content"]
  end

  def quote_author do
    names = [
    "Tomos Pearson",
    "Kaila Phan",
    "Alivia Huffman",
    "Misty Roman",
    "Kasim Woodard",
    "Zephaniah Roberson",
    "Leyla Flynn",
    "Lucia Bellamy",
    "Lukas Espinoza",
    "Haaris Berg",
    "Hussain Wilks",
    "Kristi Milne",
    "Talha Atherton",
    "Izaac Fellows",
    "Lily-Mai Lyon",
    "Horace Dillard",
    "Elli Werner",
    "Hamzah Woodcock",
    "Minahil Larson",
    "Shane Higgs",
    "Eliana Boyd",
    "Laibah Legge",
    "Sherry Gale",
    "Mirza Odling",
    "King Delaney",
    "Wilf Thomson",
    "Greg Bassett",
    "Rosina Levy",
    "Olaf Conroy",
    "Jevan Beech",
    "Romana Villa",
    "Delilah Ross",
    "Arisha Gibson",
    "Grant Davison",
    "Jeevan Glass",
    "Avi Workman",
    "Wallace Lloyd",
    "Shaquille Lucas",
    "Enzo Lyons",
    "Dominic Yu",
    "Mila-Rose Goodman",
    "Sonya Haworth",
    "Raya Salinas",
    "Elina Hickman",
    "Nikkita Perkins",
    "Melisa Gallagher",
    "Harley Austin",
    "Dilara Hampton",
    "T-Jay Vega",
    "Elle Robin",
    "Kristen Frye",
    "Keeva Giles",
    "Dougie Mcconnell",
    "Kristopher Osborn",
    "Raja Kline",
    "Lizzie Peel",
    "Elana Edmonds",
    "Yasmeen Riddle",
    "Shaurya Foley",
    "Keira Haley",
    "Javan Knight",
    "Astrid Nixon",
    "Abigail Herring",
    "Blessing Goldsmith",
    "Alexander Xiong",
    "Pharrell Mcneill",
    "Milly Curtis",
    "Ellis Gardiner",
    "Safah Hussain",
    "Finbar Schneider",
    "Madina Sheridan",
    "Liana Weeks",
    "Emanuel Fraser",
    "Zeynep Ingram",
    "Chloe Langley",
    "Azeem Whyte",
    "Kadeem Watt",
    "Marlon Sexton",
    "Sadia Lindsey",
    "Safiyah Mcfadden",
    "Krzysztof Lennon",
    "Mac Mcarthur",
    "Tevin Reyes",
    "Beverley Edge",
    "Leen Chapman",
    "Andreea Solis",
    "Ember Sykes",
    "Dominick Ventura",
    "Fleur Parry",
    "Jaylen Wooten",
    "Faiza Lake",
    "Rahima Maxwell",
    "Khaleesi Wu",
    "Evalyn Stout",
    "Faheem Hook",
    "Callum Paul",
    "Mollie Colon",
    "Debbie Francis",
    "Amanpreet Browne",
    "Jaidon Childs"
    ]
    Enum.random(names)
  end

  def a_or_an(nil) do "a" end

  def a_or_an(type) do
    if String.starts_with?(type, ["a", "A"]) do
      "an"
      else
      "a"
    end
  end

  def render(assigns) do
    ~F"""
    <p><InlineEdit backcast={@backcast} category="Project Name" parent_pid={@parent_pid} id="project_name" /> is {a_or_an(get_card_or_tbc(@backcast["cards"], "Project Type"))} <InlineEdit backcast={@backcast} category="Project Type" parent_pid={@parent_pid} id="type" /> for <InlineEdit backcast={@backcast} category="Intended Audience" parent_pid={@parent_pid} id="audience" />.</p>
    <br>

    <p class="">Solving the problem of <InlineEdit backcast={@backcast} category="The Problem it solves" parent_pid={@parent_pid} id="problem_solves" />, leading to <InlineEdit backcast={@backcast} category="Benefits" parent_pid={@parent_pid} id="benefits" />.</p>

    <div class="card shadow-2xl lg:card-side bg-secondary my-6">
      <div class="card-body">
        <h1 class="card-title">What people are saying</h1>
        <q><InlineEdit backcast={@backcast} category="Inspirational Quote" parent_pid={@parent_pid} id="quote" /></q>
        - {quote_author()}
      </div>
    </div>

    <div>Example Advert</div>
    <div class="example-ad">
      Ad <span style="padding:0 5px">·</span> <a href="#">https://{get_card_or_tbc(@backcast["cards"], "Project Name")}.com</a><br>
      <a href="#" class="example-link">{get_card_or_tbc(@backcast["cards"], "Project Name")} | {get_card_or_tbc(@backcast["cards"], "The Problem it solves")} for {get_card_or_tbc(@backcast["cards"], "Intended Audience")} solved!</a><br>
      {get_card_or_tbc(@backcast["cards"], "Call to Action")}
    </div>
    """
    end

end