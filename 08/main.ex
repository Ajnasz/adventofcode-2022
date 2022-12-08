defmodule Debug do
  def pprint(data) do
    IO.puts(inspect(data, pretty: true, limit: :infinity))
  end
end

defmodule Parser do
  def parse(file) do
    {:ok, body} = File.read(file)

    Enum.map(body |> String.trim |> String.split, fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(fn n -> Integer.parse(n) end) end)
  end
end

defmodule Elf do
  def is_tree_on_the_edge(data, [top, left]) do
    data_height = length(data)
    data_width = Enum.at(data, 0) |> length
    cond do
      top == 0 -> true
      left == 0 -> true
      top == data_height - 1 -> true
      left == data_width - 1 -> true
      true -> false
    end
  end

  def is_smaller(neighbour, me) do
    neighbour < me
  end

  def is_covering(neighbour, me) do
    not is_smaller(neighbour, me)
  end

  def get_tree(data, [top, left]) do
    data
    |> Enum.at(top)
    |> Enum.at(left)
  end

  def get_trees_around(data, [top, left]) do
    row = Enum.at(data, top)
    to_left = Enum.slice(row, 0..(left - 1))
    to_right = case left do
      0 -> []
      _ -> Enum.slice(row, (left + 1)..(length(data) - 1))
    end
    to_top = data |>
      Enum.slice(0..(top - 1)) |>
      Enum.map(&(Enum.at(&1, left)))
    to_bottom = case top do
      0 -> []
      _ -> data |>
        Enum.slice((top + 1)..(length(data) -1 )) |>
        Enum.map(&(Enum.at(&1, left)))
    end

    [to_left, to_top, to_right, to_bottom]
  end

  def is_tree_visible(data, tree) do
    if is_tree_on_the_edge(data, tree) do
      true
    else
      trees_around = get_trees_around(data, tree)
      me = get_tree(data, tree)

      Enum.any?(trees_around, fn group -> Enum.all?(group, &(me > &1)) end)
    end
  end

  def get_view_score(trees_around, me) do
    if length(trees_around) == 0 do
      0
    else
      index = Enum.find_index(trees_around, &(is_covering(&1, me)))

      case index do
        nil -> length(trees_around)
        _ -> index + 1
      end
    end
  end

  def calc_scenic_score(data, tree) do
    trees_around = get_trees_around(data, tree)
    me = get_tree(data, tree)

    left_score = trees_around
      |> Enum.at(0)
      |> Enum.reverse()
      |> get_view_score(me)

    top_score = trees_around
      |> Enum.at(1)
      |> Enum.reverse()
      |> get_view_score(me)

    right_score = trees_around
      |> Enum.at(2)
      |> get_view_score(me)

    bottom_score = trees_around
      |> Enum.at(3)
      |> get_view_score(me)

    left_score * top_score * right_score * bottom_score
  end

  def get_visible_trees(data) do
    rows = 0..(length(data)- 1)
    cols = 0..(length(Enum.at(data, 0)) - 1)

    Enum.flat_map(rows, fn row -> cols
      |> Enum.filter(fn col -> is_tree_visible(data, [row, col]) end)
      |> Enum.map(fn col -> [row, col] end) end)
  end

  def count_visible_trees(data) do
    length(get_visible_trees(data))
  end

  def get_best_scenic_tree(data) do
    get_visible_trees(data)
    |> Enum.map(fn tree -> calc_scenic_score(data, tree) end)
    |> Enum.reduce(0, &(max &1, &2))
  end
end

parsed_data = Parser.parse("input")
# Debug.pprint(parsed_data)

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


# Debug.pprint(Elf.calc_scenic_score(parsed_data, 3, 2))
# Debug.pprint(Elf.calc_scenic_score(parsed_data, 1, 2))
# Debug.pprint(Elf.calc_scenic_score(parsed_data, 0, 0))
# Debug.pprint(Elf.calc_scenic_score(parsed_data, 2, 0))
Debug.pprint("best score: #{Elf.get_best_scenic_tree(parsed_data)}")
