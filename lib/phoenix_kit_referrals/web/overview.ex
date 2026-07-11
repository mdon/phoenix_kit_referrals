defmodule PhoenixKitReferrals.Web.Overview do
  @moduledoc """
  Referral program overview LiveView for the PhoenixKit admin panel.

  Surfaces system-wide stats, a top-codes leaderboard, and a recent-activity
  feed — a read-only landing page alongside the existing list/settings pages.
  """
  use PhoenixKitWeb, :live_view
  # Rebind gettext macros to the referrals module's own catalogs (priv/gettext).
  use Gettext, backend: PhoenixKitReferrals.Gettext

  alias PhoenixKit.Settings
  alias PhoenixKitReferrals, as: Referrals
  alias PhoenixKitReferrals.Paths

  @top_codes_limit 5
  @recent_usage_limit 10

  def mount(_params, _session, socket) do
    # Get project title from settings
    project_title = Settings.get_project_title()
    config = Referrals.get_config()

    socket =
      socket
      |> assign(:page_title, gettext("Referrals"))
      |> assign(:page_subtitle, gettext("Program overview and recent activity"))
      |> assign(:project_title, project_title)
      |> assign(:config, config)
      |> assign(:system_stats, Referrals.get_system_stats())
      |> assign(:top_codes, Referrals.top_codes(@top_codes_limit))
      |> assign(:recent_usage, Referrals.list_recent_usage(@recent_usage_limit))

    {:ok, socket}
  end

  def handle_params(_params, uri, socket) do
    {:noreply, assign(socket, :url_path, URI.parse(uri).path)}
  end

  defp beneficiary_email(%{beneficiary_user: %{email: email}}) when is_binary(email), do: email
  defp beneficiary_email(_), do: gettext("None")

  defp usage_code_string(%{referral_code: %{code: code}}) when is_binary(code), do: code
  defp usage_code_string(_), do: gettext("Deleted code")

  defp usage_user_email(%{user: %{email: email}}) when is_binary(email), do: email
  defp usage_user_email(_), do: gettext("Unknown")
end
