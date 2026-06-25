# Changelog

All notable changes to **PhoenixKitReferrals** are documented here. The format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this
project adheres to [Semantic Versioning](https://semver.org/).

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
