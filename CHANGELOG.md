# Changelog

All notable changes to **PhoenixKitReferrals** are documented here. The format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this
project adheres to [Semantic Versioning](https://semver.org/).

## [0.2.0] - 2026-06-27

### Added

- Internationalization for the admin UI. A module-owned Gettext backend
  (`PhoenixKitReferrals.Gettext`) with its own `priv/gettext` catalogs; every
  admin-facing string in the list, form, and settings LiveViews — plus the
  `permission_metadata/0` label and description — now resolves through
  `gettext/1`. Ships full **Russian** and **Estonian** translations alongside
  the English source. The `priv` directory is now included in the Hex package so
  the catalogs travel with the build.

### Fixed

- Delete-confirmation on the referrals list now uses LiveView's native
  `data-confirm` instead of an inline `onclick="return confirm(...)"`. The
  previous handler did not reliably stop the `phx-click` delete when the user
  cancelled, and interpolating a translated string into a JS literal would break
  on any translation containing an apostrophe.

## [0.1.0]

### Added

- Initial release. Extracted the referral-codes feature out of PhoenixKit core
  into a standalone, auto-discovered module:
  - `PhoenixKitReferrals` context — code CRUD, validation, usage tracking, and
    system settings (enabled / required / per-code + per-user limits).
  - Admin UI — referral-code list/form and a settings page, contributed via the
    `PhoenixKit.Module` tab callbacks.
  - Signup integration via runtime dispatch from core (registration, OAuth, and
    magic-link), so core carries no compile-time dependency on this module.
  - The referral tables remain owned by PhoenixKit core migrations; this package
    ships only schemas, logic, and UI.
