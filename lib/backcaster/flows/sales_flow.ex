defmodule SalesFlow do
  use Machinery,
      states: ["A", "B", "C"],
      transitions: %{
        "A" => ["B", "C"],
      }

  @state_qns %{
    "A" => %{
      "Yes" => "B",
      "No" => "C"
    }
  }

  def get_state_options(%{state: state}) do
    @state_qns |> Map.get(state) |> Map.keys() |> Enum.reverse
  end

  def get_next_state(%{state: state}, inp) do
    @state_qns |> Map.get(state) |> Map.get(inp)
  end

#  def log_transition(struct, _next_state) do
#    IO.inspect("Log transition")
#    # Log transition here, save on the DB or whatever.
#    # ...
#    # Return the struct.
#    struct
#  end

  #  def guard_function(cart, "filled") do
  #    # Check if there is enough of this item in stock
  #    # it returns a boolean, if true it will move on with
  #    # the transition, if false, it'll block it and keep
  #    # the previous state
  #    Item.has_stock?(cart.item)
  #  end
  #
  #  def guard_function(cart, "payed") do
  #    # Check if payment is received and return boolean
  #    # if it returns true the transition will be allowed
  #    # to happen
  #    Payment.status(cart) == :confirmed
  #  end
  #
  #  def before_transition(cart, "filled") do
  #    # A transition callback that will perform an action,
  #    # in this case right before the transition occurs,
  #    # locking the items on a cart to prevent another
  #    # customer from adding it if there is not enough stock.
  #    Item.lock_form_cart(cart)
  #    cart
  #  end
  #
  #  def after_transition(cart, "abadonned") do
  #    # An after transition callback, it's used to perform
  #    # an action after a transition.
  #    # In this case Unlocking the items on the cart just
  #    # moved to the abandoned state.
  #    Item.unlock_form_cart(cart)
  #    cart
  #  end

end