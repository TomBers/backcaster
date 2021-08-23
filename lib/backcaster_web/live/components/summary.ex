defmodule Summary do
  use Surface.LiveComponent

  prop board, :map
  prop backcast, :map


  def count_milestones(milestones, cond) do
    milestones
    |> Enum.filter(fn {k, m} -> m["active"] == cond end)
    |> length()
  end

  def get_card_or_tbc(nil) do
    "??"
  end

  def get_card_or_tbc(card) do
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
    <div class="grid grid-cols-2 gap-2 p-6 lg:bg-base-200 rounded-box my-2">
        <h1 class="title">Due date : {@board.goal_date}</h1>
        <h1 class="title">Time remaining : {Date.diff(@board.goal_date, Date.utc_today())} days</h1>
        <h1 class="title">{count_milestones(@backcast["milestones"], true)} Active milestones</h1>
        <h1 class="title">{count_milestones(@backcast["milestones"], false)} Complete milestones</h1>
        </div>
        <div class="card shadow-lglg:p-10 xl:grid-cols-2 lg:bg-base-200 rounded-box p-8 text-xl">
          <p><span class="emphasis">{get_card_or_tbc(@backcast["cards"]["Project Name"])}</span> is {a_or_an(@backcast["cards"]["Project Type"]["content"])} <span class="emphasis">{get_card_or_tbc(@backcast["cards"]["Project Type"])}</span> for <span class="emphasis">{get_card_or_tbc(@backcast["cards"]["Intended Audience"])}</span>.</p>
          <br>

          {#if !is_nil(@backcast["cards"]["The Problem it solves"]) and !is_nil(@backcast["cards"]["Benefits"])}
            <p class="">Solving the problem of <span class="emphasis">{get_card_or_tbc(@backcast["cards"]["The Problem it solves"])}</span>, leading to <span class="emphasis">{get_card_or_tbc(@backcast["cards"]["Benefits"])}</span>.</p>
          {#else}
            <p class="blur">Solving the problem of <span class="emphasis">{get_card_or_tbc(@backcast["cards"]["The Problem it solves"])}</span>, leading to <span class="emphasis">{get_card_or_tbc(@backcast["cards"]["Benefits"])}</span>.</p>
          {/if}


          {#if !is_nil(@backcast["cards"]["Inspirational Quote"])}
            <div class="card shadow-2xl lg:card-side bg-secondary text-secondary-content my-6">
              <div class="card-body">
              <q>{get_card_or_tbc(@backcast["cards"]["Inspirational Quote"])}</q> - {quote_author()}
              </div>
            </div>
        {#else}
            <div class="card shadow-2xl lg:card-side bg-secondary text-secondary-content my-6 blur">
                <div class="card-body">
                <q>{get_card_or_tbc(@backcast["cards"]["Inspirational Quote"])}</q> - Anon
                </div>
            </div>
        {/if}

    {#if !is_nil(@backcast["cards"]["Call to Action"])}
          <div class="example-ad">
            Ad <span style="padding:0 5px">·</span> <a href="#">https://{get_card_or_tbc(@backcast["cards"]["Project Name"])}.com</a><br>
            <a href="#" class="example-link">{get_card_or_tbc(@backcast["cards"]["Project Name"])} | {get_card_or_tbc(@backcast["cards"]["The Problem it solves"])} solved!</a><br>
            {get_card_or_tbc(@backcast["cards"]["Call to Action"])}
          </div>
        {#else}
        <div class="example-ad blur">
          Ad <span style="padding:0 5px">·</span> <a href="#">https://{get_card_or_tbc(@backcast["cards"]["Project Name"])}.com</a><br>
          <a href="#" class="example-link">{get_card_or_tbc(@backcast["cards"]["Project Name"])} | {get_card_or_tbc(@backcast["cards"]["The Problem it solves"])} solved!</a><br>
          {get_card_or_tbc(@backcast["cards"]["Call to Action"])}
        </div>
        {/if}

        </div>
      """
    end

end