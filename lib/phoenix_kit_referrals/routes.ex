defmodule PhoenixKitReferrals.Routes do
  @moduledoc """
  Referral codes module routes.

  Provides route definitions for referral code settings and management.
  """

  @doc """
  Returns quoted admin LiveView route declarations for the shared admin live_session (localized).
  """
  def admin_locale_routes do
    quote do
      live(
        "/admin/settings/referral-codes",
        PhoenixKitReferrals.Web.Settings,
        :index,
        as: :referral_codes_settings_localized
      )

      live(
        "/admin/referral-codes/overview",
        PhoenixKitReferrals.Web.Overview,
        :index,
        as: :referral_codes_overview_localized
      )

      live("/admin/referral-codes/codes", PhoenixKitReferrals.Web.List, :index,
        as: :referral_codes_list_localized
      )

      live("/admin/referral-codes/codes/new", PhoenixKitReferrals.Web.Form, :new,
        as: :referral_codes_new_localized
      )

      live(
        "/admin/referral-codes/codes/edit/:code_uuid",
        PhoenixKitReferrals.Web.Form,
        :edit,
        as: :referral_codes_edit_localized
      )
    end
  end

  @doc """
  Returns quoted admin LiveView route declarations for the shared admin live_session (non-localized).
  """
  def admin_routes do
    quote do
      live(
        "/admin/settings/referral-codes",
        PhoenixKitReferrals.Web.Settings,
        :index,
        as: :referral_codes_settings
      )

      live(
        "/admin/referral-codes/overview",
        PhoenixKitReferrals.Web.Overview,
        :index,
        as: :referral_codes_overview
      )

      live("/admin/referral-codes/codes", PhoenixKitReferrals.Web.List, :index,
        as: :referral_codes_list
      )

      live("/admin/referral-codes/codes/new", PhoenixKitReferrals.Web.Form, :new,
        as: :referral_codes_new
      )

      live(
        "/admin/referral-codes/codes/edit/:code_uuid",
        PhoenixKitReferrals.Web.Form,
        :edit,
        as: :referral_codes_edit
      )
    end
  end
end
