defmodule SummaryWord do
  def check(word) do
    values = String.downcase(word) |> String.to_char_list |> Enum.map(&(&1 - 96))
    [first | rest] = values
    {beginning, last} = {Enum.take(values, length(values) - 1), List.last(values)}
    first_sums = first == Enum.sum(rest)
    last_sums = last == Enum.sum(beginning)
    case {first_sums, last_sums} do
      {true, true}  -> :both
      {true, false} -> :first
      {false, true} -> :last
      _             -> :neither
    end
  end
end

File.stream!('/usr/share/dict/words')
|> Enum.map(&String.strip/1)
|> Enum.group_by(&SummaryWord.check/1)
|> Map.take([:both, :first, :last])
|> Enum.each(fn({label, words}) ->
  IO.puts "#{label}: #{length(words)}"
  IO.puts Enum.join(Enum.sort(words), ",")
  IO.puts ""
end)
