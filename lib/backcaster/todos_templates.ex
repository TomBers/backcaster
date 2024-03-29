defmodule Backcaster.TodosTemplates do

  def milestone_templates() do
    [
      "Pick a template",
      "Market Research",
      "Product Validation",
      "Website checklist",
      "SEO checklist",
      "Product Launch",
      "Twitter Checklist"
    ]
  end

#  def labels do
#    ["Immediate", "Long term", "Requires human response"]
#  end

  def requires_response do
    ["Requires response"]
  end

  def needs_thought do
    ["Needs thought"]
  end

  def simple_task do
    ["Simple Task"]
  end

  def needs_feedback do
    ["Needs feedback"]
  end

  def product_validation do
    [
      {"Identify niche - who is this for?", needs_thought()},
      {"Identified the following traits of our ideal customer", needs_thought()},
      {"Compile list of 10 ideal customers", needs_thought()},
      {"Prepare an interview questions, what do they currently use? what are the pain points?", []},
      {"Create a more general survey to share on social media", requires_response() ++ needs_thought()},
      {"Conduct customer interview 1", requires_response()},
      {"Conduct customer interview 2", requires_response()},
      {"Conduct customer interview 3", requires_response()},
      {"Conduct customer interview 4", requires_response()},
      {"Conduct customer interview 5", requires_response()},
      {"Conduct customer interview 6", requires_response()},
      {"Conduct customer interview 7", requires_response()},
      {"Conduct customer interview 8", requires_response()},
      {"Conduct customer interview 9", requires_response()},
      {"Conduct customer interview 10", requires_response()},
      {"Collate responses", []},
      {"Decide if there is enough interest to proceed", needs_thought()}
    ]

  end

  def market_research do
    [
      {"Identify 4 keywords related to your product", needs_thought()},
      {"Identify keywords with the biggest search volumes to learn about audience interest and trends", []},
      {"Find the phrases and words the target audience uses when researching", needs_thought()},
      {"Check SimilarWeb / Google for competitors", simple_task()},
      {"Collate findings about 3-6 competitors and identify strengths and weaknesses", needs_thought()},
      {"From research identify 3 key unique points about your product", needs_thought()}
    ]
  end

  def website_checklist do
    [
      {"Integrate an analytics solution", needs_thought()},
      {"Make sure all pages you need are in place", simple_task()},
      {"Prepare for 404s", simple_task()},
      {"Test your site’s navigation and internal links", simple_task()},
      {"Proof read your content and copy", needs_thought()},
      {"Ensure your website is accessible", []},
      {"Check your website on mobile devices", simple_task()},
      {"Test for problems with different browsers", simple_task()},
      {"Double-check all URLs are correct", simple_task()},
      {"Generate a robots.txt file", simple_task()},
      {"Add metadata to all pages", simple_task()},
      {"Make sure you have relevant CTAs", []}
    ]
  end

  def seo_checklist do
    [
      {"Setup Google Search Console", simple_task()},
      {"Setup Google Analytics", simple_task()},
      {"Connect Google Analytics with the Google Search Console", simple_task()},
      {"Discover long-tail keywords With Google Suggest", needs_thought()},
      {"Setup - Keywordtool.io / Google Keyword Planner", simple_task()},
      {"Identify low competition keywords With KWFinder", needs_thought()},
      {"Include your keyword in your URL", simple_task()},
      {"Make URLs as short as possible", []},
      {"Check your keyword is in your title tag and headings", simple_task()},
      {"Optimize images - add alt-text, and ensure fast loading", []},
      {"Link out to 4-8 (at a minimum) authoritative sites in your copy.", needs_thought()},
      {"Check for crawl errors", simple_task()},
      {"Make sure your site is mobile-friendly", simple_task()},
      {"Check / fix broken links", simple_task()},
      {"Check your site’s loading speed", simple_task()},
      {"Generate backlinks from other blogging platforms and / or friends", requires_response()},
    ]
  end

  def product_launch do
    [
      {"Check the product has been tested, run through QA, and proven capable of holding up", []},
      {"You are comfortable conducting demos, answering common questions and objections, and articulating its key value propositions", needs_thought()},
      {"You are ready to assist new users through common questions, issues, and problems", needs_thought()},
      {"Support documentation has been developed, reviewed, and made easily accessible", needs_thought() ++ needs_feedback()},
      {"Developed your plan for tracking user behavior and key metrics", needs_thought()},
      {"You have stress-tested every customer touch-point", []},
      {"Developed and rehearsed your (5 second) elevator pitch for the product", needs_thought() ++ needs_feedback()},
      {"Have several methods for users to offer direct feedback on the product (that you read)", []},
      {"Set a goal for the launch - how will you know what success looks like?", needs_thought()},
      {"Post about it on Forum(s)", simple_task()},
      {"Post about it on Twitter", simple_task()},
      {"Post about it on LinkedIn", simple_task()},
      {"Post about it on Facebook", simple_task()},
      {"Post about it on Instagram", simple_task()},
      {"Launch on ProductHunt ", needs_thought() ++ needs_feedback()},
    ]

  end


  def twitter_checklist do
    [
      {"Set up a profile - [A unique @handle, profile photo, short bio to show what you’re interested in]", needs_feedback()},
      {"Add your website to your bio", simple_task()},
      {"Follow at least 10 people in your niche", needs_thought()},
      {"Follow at least 3 Topics in your niche", []},
      {"Check out the Explore tab and find what’s trending in your area and around the world", needs_thought()},
      {"Like 10 Tweets", simple_task()},
      {"Engage more than you broadcast - for every 1 promotional tweet, have 5 engaging in conversation, asking / answering questions", []},
      {"Retweet With Comment - always add something to the conversation ", []},
      {"Use Twitter search to find 10 target customers.  Look for issues and pain points", needs_thought()},
      {"Find a hashtag that works", []}
    ]

  end


  #  Ideas: Customer feedback, product validation, website checklist, product launch, setup analytics, security checklist
  # Marketing checklist, Twitter engagement, background reading, blogging, marketing, SEO
  def gen_template(opt) do
    case opt do
      "Product Validation" -> product_validation() |> gen_items()
      "Market Research" -> market_research() |> gen_items()
      "Website checklist" -> website_checklist() |> gen_items()
      "SEO checklist" -> seo_checklist() |> gen_items()
      "Product Launch" -> product_launch() |> gen_items()
      "Twitter Checklist" -> twitter_checklist() |> gen_items()
      _ -> gen_items([])
    end
  end

  defp gen_items(items) do
    todo = BurnListCategory.new_category("TODO")
    items
    |> Enum.map(fn {item, labels} -> BurnListItem.make_item(item, todo, labels) end)
    |> base_template(todo)
  end

  defp base_template(items, todo) do
    doing = BurnListCategory.new_category("Doing")
    done = BurnListCategory.new_category("Done")
    board = %BurnListBoard{
      created_at: Date.utc_today(),
      items: items,
      categories: [todo, doing, done]
    }

    %BurnListHistory{
      current: board,
      past: [board]
    }
  end

end