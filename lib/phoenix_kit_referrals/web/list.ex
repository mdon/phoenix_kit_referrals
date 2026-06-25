defmodule PhoenixKitReferrals.Web.List do
  @moduledoc """
  User referral codes management LiveView for PhoenixKit admin panel.

  Displays and manages referral codes associated with users.
  """
  use PhoenixKitWeb, :live_view

  alias PhoenixKit.Settings
  alias PhoenixKitReferrals, as: Referrals

  def mount(_params, _session, socket) do
    # Get project title from settings
    project_title = Settings.get_project_title()

    # Load referral codes and stats
    codes = Referrals.list_codes()
    system_stats = Referrals.get_system_stats()
    config = Referrals.get_config()

    socket =
      socket
      |> assign(:page_title, "Referrals")
      |> assign(:page_subtitle, "Issue and track referrals for user registration")
      |> assign(:project_title, project_title)
      |> assign(:codes, codes)
      |> assign(:system_stats, system_stats)
      |> assign(:config, config)

    {:ok, socket}
  end

  def handle_params(_params, uri, socket) do
    {:noreply, assign(socket, :url_path, URI.parse(uri).path)}
  end

  def handle_event("delete_code", %{"uuid" => uuid}, socket) do
    code = Referrals.get_code!(uuid)

    case Referrals.delete_code(code) do
      {:ok, _code} ->
        socket =
          socket
          |> put_flash(:info, "Referral deleted successfully")
          |> assign(:codes, Referrals.list_codes())
          |> assign(:system_stats, Referrals.get_system_stats())

        {:noreply, socket}

      {:error, _changeset} ->
        socket = put_flash(socket, :error, "Failed to delete referral")
        {:noreply, socket}
    end
  end

  def handle_event("toggle_code_status", %{"uuid" => uuid}, socket) do
    code = Referrals.get_code!(uuid)
    new_status = !code.status

    case Referrals.update_code(code, %{status: new_status}) do
      {:ok, _code} ->
        status_text = if new_status, do: "activated", else: "deactivated"

        socket =
          socket
          |> put_flash(:info, "Referral #{status_text}")
          |> assign(:codes, Referrals.list_codes())
          |> assign(:system_stats, Referrals.get_system_stats())

        {:noreply, socket}

      {:error, _changeset} ->
        socket = put_flash(socket, :error, "Failed to update referral status")
        {:noreply, socket}
    end
  end

  # Key/value pairs shown on each mobile card (the desktop table renders the
  # same data column-by-column). Plain strings keep parity with the core admin
  # tables' card view.
  defp code_card_fields(code) do
    [
      %{label: "Description", value: code.description},
      %{label: "Usage", value: "#{code.number_of_uses} / #{code.max_uses}"},
      %{label: "Expiration", value: expiration_text(code.expiration_date)},
      %{label: "Status", value: if(code.status, do: "Active", else: "Inactive")},
      %{label: "Created By", value: creator_email(code)},
      %{label: "Beneficiary", value: beneficiary_email(code)}
    ]
  end

  defp expiration_text(nil), do: "Never"
  defp expiration_text(date), do: Calendar.strftime(date, "%b %d, %Y")

  defp creator_email(%{creator: %{email: email}}) when is_binary(email), do: email
  defp creator_email(_), do: "Unknown"

  defp beneficiary_email(%{beneficiary_user: %{email: email}}) when is_binary(email), do: email
  defp beneficiary_email(_), do: "None"

  # Row actions, shared between the desktop table cell and the mobile card
  # footer so both stay in sync.
  attr(:code, :map, required: true)

  defp code_actions(assigns) do
    ~H"""
    <div class="flex gap-2">
      <.link
        navigate={PhoenixKit.Utils.Routes.path("/admin/users/referral-codes/edit/#{@code.uuid}")}
        class="btn btn-sm btn-outline"
      >
        <.icon name="hero-pencil" class="w-4 h-4" />
      </.link>

      <button
        class={"btn btn-sm #{if @code.status, do: "btn-warning", else: "btn-success"}"}
        phx-click="toggle_code_status"
        phx-value-uuid={@code.uuid}
      >
        {if @code.status, do: "Deactivate", else: "Activate"}
      </button>

      <button
        class="btn btn-sm btn-error"
        phx-click="delete_code"
        phx-value-uuid={@code.uuid}
        onclick="return confirm('Are you sure you want to delete this referral?')"
      >
        <.icon name="hero-trash" class="w-4 h-4" />
      </button>
    </div>
    """
  end
end
