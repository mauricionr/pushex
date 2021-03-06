defmodule PushEx do
  @moduledoc """
  PushEx context exposes public API functions.
  """

  alias PushEx.{Instrumentation, Push}
  alias Push.ItemProducer

  @doc """
  Returns the number of sockets (transports) connected to this node.
  """
  @spec connected_socket_count() :: non_neg_integer()
  defdelegate connected_socket_count(), to: Instrumentation.Tracker

  @doc """
  Returns the number of channels connected to this node.
  """
  @spec connected_channel_count() :: non_neg_integer()
  defdelegate connected_channel_count(), to: Instrumentation.Tracker

  @doc """
  Triggers a Push to be instrumented/enqueued into the system.
  """
  @spec push(%Push{}) :: true
  def push(item = %Push{}) do
    Instrumentation.Push.requested(item)
    ItemProducer.push(item)
    true
  end

  @doc false
  def unix_ms_now(), do: (:erlang.system_time() / 1_000_000) |> round()
end
