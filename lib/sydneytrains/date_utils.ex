defmodule Sydneytrains.DateUtils do
  def current_date do
    {{y, m, d}, _} = :calendar.local_time
    {:ok, date} = Date.new(y, m, d)
    date
  end

  def current_time do
    {{y, m, d}, {h, mi, s}} = :calendar.local_time
    {:ok, datetime} = NaiveDateTime.new(y, m, d, h, mi, s)
    datetime
  end

  def from_timestamp(timestamp) do
    {:ok, datetime} = DateTime.from_unix(timestamp)
    DateTime.to_iso8601(datetime)
  end
end

