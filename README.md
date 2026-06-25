# PhoenixKitReferrals

Referral codes module for [PhoenixKit](https://github.com/BeamLabEU/phoenix_kit).

Issue and manage referral codes, enforce per-code and per-user limits, track
usage, and (optionally) require/apply a code at user registration.

This module was extracted from PhoenixKit core. The referral tables
(`phoenix_kit_referral_codes`, `phoenix_kit_referral_code_usage`) are still
created by PhoenixKit's own migrations — this package ships the schemas, the
business logic, and the admin UI that read and write them. Installing the
package is enough; no extra migration step is required.

## Installation

Add it to your PhoenixKit host app's deps:

```elixir
def deps do
  [
    {:phoenix_kit, "~> 1.7"},
    {:phoenix_kit_referrals, "~> 0.1"}
  ]
end
```

It is auto-discovered at compile time (via `extra_applications: [:phoenix_kit]`
and the `PhoenixKit.Module` behaviour) — the admin tabs, settings page, and
routes appear automatically. Enable it from **Admin → Modules**.

## What you get

- **Admin → Users → Referral Codes** — list, create, edit, enable/disable codes.
- **Admin → Settings → Referral Codes** — turn the system on, make a code
  required at signup, and cap uses-per-code / codes-per-user.
- **Signup integration** — when enabled, the registration / OAuth / magic-link
  flows offer (or require) a referral code and record its usage on success.
  PhoenixKit core dispatches to this module at runtime by module key, so core
  has no compile-time dependency on it: with the module absent the field simply
  doesn't appear.

## Public API

`PhoenixKitReferrals` is the context. Highlights:

- Codes: `list_codes/0`, `get_code/1`, `get_code_by_string/1`, `create_code/1`,
  `update_code/2`, `delete_code/1`, `generate_random_code/0`
- Validation: `valid_for_use?/1`, `expired?/1`, `usage_limit_reached?/1`
- Usage: `use_code/2`, `get_usage_stats/1`, `user_used_code?/2`
- System: `enabled?/0`, `required?/0`, `enable_system/0`, `disable_system/0`,
  `get_config/0`

## Local development

To run against a local PhoenixKit checkout (instead of the Hex release):

```bash
PHOENIX_KIT_PATH=../phoenix_kit mix test
```

## License

MIT
