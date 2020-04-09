defmodule KjerSi.UserHelpers do
  alias KjerSi.Accounts

  defp generate_name do
    {:ok, first} = File.read("lib/kjer_si_web/controllers/helpers/first.txt")
    {:ok, second} = File.read("lib/kjer_si_web/controllers/helpers/second.txt")
    first_bag = String.split(first, "\n")
    second_bag = String.split(second, "\n")

    Enum.random(first_bag) <> Enum.random(second_bag)
  end

  def generate_unique_name do
    nickname = generate_name()

    if Accounts.unique_nickname?(nickname) do
      nickname
    else
      generate_unique_name()
    end
  end
end
