defmodule Sydneytrains.Services.ResponseParserTest do
  use ExUnit.Case

  alias Sydneytrains.Services.ResponseParser

  test "it handles a short walk to the destination at the end" do
    response = File.read! Path.expand("../support/fixtures/planner_responses/1.json", __DIR__)
    expected = [
      %{
        legs: [
          %{
            from: %{
              name: "Penshurst Station Platform 1",
              time: 1502087058,
            },
            to: %{
              name: "Bondi Junction Station Platform 2",
              time: 1502089200
            }
          }
        ]
      },
      %{
        legs: [
          %{
            from: %{
              name: "Penshurst Station Platform 1",
              time: 1502087640
            },
            to: %{
              name: "Bondi Junction Station Platform 1",
              time: 1502089800
            }
          }
        ]
      },
      %{
        legs: [
          %{
            from: %{
              name: "Penshurst Station Platform 1",
              time: 1502088660
            },
            to: %{
              name: "Bondi Junction Station Platform 2",
              time: 1502090820
            }
          }
        ]
      },
    ]
    assert ResponseParser.parse(response, ["202291", "202292"]) == expected
  end
end
