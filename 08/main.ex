defmodule Debug do
  def pprint(data) do
    IO.puts(inspect(data, pretty: true, limit: :infinity))
  end
end

defmodule Parser do
  def parse(file) do
    {:ok, body} = File.read(file)

    Enum.map(String.split(String.trim(body)), fn line ->
      String.trim(line)
      |> String.split("", trim: true)
      |> Enum.map(fn n -> Integer.parse(n)
        |> elem(0)
      end) end)
  end
end
defmodule Elf do
  def is_tree_on_the_edge(data, top, left) do
    data_height = length(data)
    data_width = length(Enum.at(data, 0))
    cond do
      top == 0 -> true
      left == 0 -> true
      top == data_height - 1 -> true
      left == data_width - 1 -> true
      true -> false
    end
  end

  def is_smaller(neighbour, me) do
    Debug.pprint("is smaller #{neighbour} #{me}")
    neighbour < me
  end

  def get_tree(data, top, left) do
    Enum.at(Enum.at(data, top), left)
  end

  def get_trees_around(data, top, left) do
    row = Enum.at(data, top)
    to_left = Enum.slice(row, 0..(left - 1))
    to_right = Enum.slice(row, (left + 1)..(length(data) - 1))
    # to_top = Enum.map(data, fn row -> Enum.at(top) end)
    to_top = Enum.map(Enum.slice(data, 0..(top - 1)), fn row -> Enum.at(row, left) end)
    to_bottom = Enum.map(Enum.slice(data, (top + 1)..(length(data) - 1)), fn row -> Enum.at(row, left) end)

    [to_left, to_right, to_top, to_bottom]
  end

  def is_tree_visible(data, top, left) do
    if is_tree_on_the_edge(data, top, left) do
      true
    else

      trees_around = Elf.get_trees_around(data, top, left)
      me = get_tree(data, top, left)

      Enum.any?(trees_around, fn group -> Enum.all?(group, fn tree -> me > tree end) end)
    end
  end

  def add_if_higher(data, top, left) do
    cond do
      is_tree_visible(data, top, left) -> 1
      true -> 0
    end
  end

  def count_visible_trees(data) do
    rows = 0..(length(data)- 1)
    cols = 0..(length(Enum.at(data, 0)) - 1)

    Enum.reduce(rows, 0, fn row, acc -> Enum.reduce(cols, 0, fn col, acc2 -> add_if_higher(data, row, col) + acc2 end) + acc end)
  end
end

parsed_data = Parser.parse("input")
# Debug.pprint(parsed_data)

Debug.pprint("count visible trees")
Debug.pprint("count #{Elf.count_visible_trees(parsed_data)}")
# Debug.pprint(Elf.get_trees_around(parsed_data, 1, 3))
# Debug.pprint("should be visible 1 1 true: #{Elf.is_tree_visible(parsed_data, 1, 1)}")
# Debug.pprint("should be visible 1 2 true: #{Elf.is_tree_visible(parsed_data, 1, 2)}")
# Debug.pprint("should be covered 1 3 false: #{Elf.is_tree_visible(parsed_data, 1, 3)}")
# Debug.pprint("should be visible 2 1 true: #{Elf.is_tree_visible(parsed_data, 2, 1)}")
# Debug.pprint("should be covered 2 2 false: #{Elf.is_tree_visible(parsed_data, 2, 2)}")
# Debug.pprint("should be visible 2 3 true: #{Elf.is_tree_visible(parsed_data, 2, 3)}")
# Debug.pprint("should be covered 3 1 false: #{Elf.is_tree_visible(parsed_data, 3, 1)}")
# Debug.pprint("should be visible 3 2 true: #{Elf.is_tree_visible(parsed_data, 3, 2)}")
# Debug.pprint("should be covered 3 3 false: #{Elf.is_tree_visible(parsed_data, 3, 3)}")
