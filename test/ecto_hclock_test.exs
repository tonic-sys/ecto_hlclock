defmodule EctoHLClockTest do
  use ExUnit.Case

  alias EctoHLClock
  alias HLClock.Timestamp

  describe "EctoHLClock" do
    test "cast/1" do
      t0 = Timestamp.new(System.os_time(:millisecond), 0, 0)
      {:ok, t1} = EctoHLClock.cast(t0)
      assert t0 == t1

      {:ok, t2} = t0 |> Timestamp.encode() |> EctoHLClock.cast()
      assert t0 == t2
    end

    test "load/1 and dump/1 are symmetric" do
      t0 = Timestamp.new(System.os_time(:millisecond), 0, 0)
      {:ok, bin} = EctoHLClock.dump(t0)
      {:ok, t1} = EctoHLClock.load(bin)
      assert Timestamp.compare(t0, t1) == :eq
    end

    test "equal?/2" do
      assert EctoHLClock.equal?(nil, nil)

      t0 = Timestamp.new(System.os_time(:millisecond), 0, 0)

      assert EctoHLClock.equal?(t0, t0)

      t1 = %{t0 | time: t0.time + 1}

      refute EctoHLClock.equal?(t0, t1)

      t2 = %{t0 | counter: 1}

      refute EctoHLClock.equal?(t0, t2)

      t3 = %{t0 | node_id: 1}

      refute EctoHLClock.equal?(t0, t3)

      [t4, t5] = Enum.shuffle([t0, nil])

      refute EctoHLClock.equal?(t4, t5)
    end
  end
end
