defmodule AdventOfCode.Y2019.Six do
  alias AdventOfCode.Tools
  alias AdventOfCode.Matrix

  # The file containing the input data
  @filename "#{Path.dirname(__ENV__.file)}/six_input.txt"

  #
  # Part #1
  #

  def entry2list(entry) do
    entry
    |> String.trim()
    |> String.split(")")
  end

  def decode_input() do
    File.stream!(@filename) 
    |> Stream.map(&entry2list(&1))
    |> Enum.to_list() 
    |> Enum.reduce(%{}, fn(item, map) -> 
      key = Enum.at(item, 0)
      value =
      case map[key] do
        nil -> []
        other -> other
      end
      map |> Map.put(key, [Enum.at(item, 1)] ++  value)
    end)
  end


  def build_orbit_for(planet, source, hops) do
    value =
    case source[planet] do
      nil -> []
      planets ->
        planets
        |> Enum.map(fn(a_planet) -> build_orbit_for(a_planet, source, hops + 1) end)
    end
    {planet, {value, hops + 1}}
  end

  def build_orbit_map(source) do
    build_orbit_for("COM", source, -1)
  end

  def count_hops({_planet, {orbits, hops}}) do
    orbits
    |> Enum.reduce(hops, fn(planet, acc) -> 
      acc + count_hops(planet) 
    end)
  end

  def run() do
    decode_input()
    |> build_orbit_map()
    |> count_hops()
  end

  #
  # Part #2
  #

  def crumbs_4_planet({source, {_planets, _hops}}, target, crumbs) when source == target do
    crumbs
  end
  def crumbs_4_planet({_source, {[], _hops}}, _target, crumbs), do: []
  def crumbs_4_planet({source, {planets, _hops}}, target, crumbs) do
    planets
    |> Enum.reduce([], fn(planet, more_crumbs) -> 
      more_crumbs ++ crumbs_4_planet(planet, target, crumbs ++ [source])
    end)
  end

  def remove_root({[h1|t1], [h2|t2]}) when h1 == h2, do: remove_root({t1, t2})
  def remove_root({orbit1, orbit2}), do: {orbit1, orbit2}

  def compute_hops({orbit1, orbit2}), do: length(orbit1) + length(orbit2)

  def run_2() do
    orbits =
    decode_input()
    |> build_orbit_map()
    
    orbit1 =
    orbits
    |> crumbs_4_planet("YOU", [])

    orbit2 =
    orbits
    |> crumbs_4_planet("SAN", [])

    {orbit1, orbit2}
    |> remove_root()
    |> compute_hops()
  end
end
