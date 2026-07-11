defmodule PhoenixKitReferrals.Paths do
  @moduledoc """
  Centralized path helpers for the Referrals module.

  Every path goes through `PhoenixKit.Utils.Routes.path/1`, which applies the
  parent app's configurable URL prefix (e.g. `/phoenix_kit`) and locale prefix
  (e.g. `/ja`) automatically.

  Use these helpers in templates and `push_navigate/2` calls instead of
  hardcoding URLs. If the admin mount point ever changes, this is the single
  file to update and every navigation follows.
  """

  alias PhoenixKit.Utils.Routes

  # Own top-level admin section (`/admin/referral-codes`), not nested under
  # Users — deliberate, see the "Referrals" top-level tab in admin_tabs/0.
  # Overview and Codes are siblings under this base, neither a prefix of the
  # other, so viewing one doesn't also prefix-match the other's nav tab.
  @base "/admin/referral-codes"

  @doc "Referral program overview / stats dashboard."
  @spec overview() :: String.t()
  def overview, do: Routes.path("#{@base}/overview")

  @doc "Referral codes list / management page."
  @spec index() :: String.t()
  def index, do: Routes.path("#{@base}/codes")

  @doc "New-referral form."
  @spec new() :: String.t()
  def new, do: Routes.path("#{@base}/codes/new")

  @doc "Edit form for the referral addressed by `code_uuid`."
  @spec edit(String.t()) :: String.t()
  def edit(code_uuid), do: Routes.path("#{@base}/codes/edit/#{code_uuid}")

  @doc "Referrals settings page (under admin Settings)."
  @spec settings() :: String.t()
  def settings, do: Routes.path("/admin/settings/referral-codes")
end
