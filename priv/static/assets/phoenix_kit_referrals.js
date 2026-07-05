// Prebuilt LiveView hooks/scripts for phoenix_kit_referrals. Declared via
// `js_sources/0`; core's `:phoenix_kit_js_sources` compiler concatenates this
// (IIFE-wrapped) into the host's `phoenix_kit_modules.js` and folds
// `window.PhoenixKitReferralsHooks` into `window.PhoenixKitHooks`.
window.PhoenixKitReferralsHooks = window.PhoenixKitReferralsHooks || {};

// Referral link capture.
//
// Referral links point at ANY page of the host site (e.g. `/?ref=CODE`), not
// just the auth pages this module doesn't own the markup for. So this can't
// be a `phx-hook` (no element to attach one to) — it's plain script that runs
// on every page load, since app.js is loaded everywhere.
//
// Flow: capture `?ref=` into localStorage with a TTL, then on whatever page
// the user eventually registers from, fill the existing `#referral_code`
// field (already read server-side by phoenix_kit core) and append
// `?referral_code=` to the OAuth provider links (core's OAuth controller
// already reads that param and threads it through the session — see
// PhoenixKitWeb.Users.OAuth). No core changes needed.
(function () {
  var STORAGE_KEY = "phoenix_kit_referral_code";
  // `ref` is the primary, portable param name (the de facto standard across
  // referral/affiliate links); `referral` is accepted as an alias.
  var URL_PARAMS = ["ref", "referral"];
  var TTL_DAYS =
    (window.PhoenixKitReferralsConfig && window.PhoenixKitReferralsConfig.ttlDays) || 30;
  var TTL_MS = TTL_DAYS * 24 * 60 * 60 * 1000;

  function readStored() {
    try {
      var raw = window.localStorage.getItem(STORAGE_KEY);
      if (!raw) return null;

      var data = JSON.parse(raw);
      if (!data || !data.code || !data.capturedAt) return null;

      if (Date.now() - data.capturedAt > TTL_MS) {
        window.localStorage.removeItem(STORAGE_KEY);
        return null;
      }

      return data.code;
    } catch (e) {
      return null;
    }
  }

  function storeCode(code) {
    try {
      window.localStorage.setItem(
        STORAGE_KEY,
        JSON.stringify({ code: code, capturedAt: Date.now() })
      );
    } catch (e) {
      // localStorage unavailable (private mode / disabled) - nothing to persist to.
    }
  }

  // First-touch attribution: a still-valid stored code is kept as-is, so a
  // later referral link can't steal credit from whoever originally sent the
  // visitor. An expired (or absent) code is replaced.
  function captureFromUrl() {
    var url;
    try {
      url = new URL(window.location.href);
    } catch (e) {
      return;
    }

    var code = null;
    var present = false;
    URL_PARAMS.forEach(function (param) {
      if (url.searchParams.has(param)) {
        present = true;
        if (!code) code = url.searchParams.get(param);
        url.searchParams.delete(param);
      }
    });
    if (!present || !code) return;

    if (!readStored()) storeCode(code);

    // Strip the tracking param(s) so the address bar stays clean/shareable.
    window.history.replaceState(window.history.state, "", url.toString());
  }

  function syncReferralField() {
    var code = readStored();
    if (!code) return;

    var input = document.getElementById("referral_code");
    if (!input || input.value) return;

    input.value = code;
    input.dispatchEvent(new Event("input", { bubbles: true }));
  }

  function syncOAuthLinks() {
    var code = readStored();
    if (!code) return;

    document.querySelectorAll('a[href*="/users/auth/"]').forEach(function (a) {
      try {
        var url = new URL(a.href, window.location.origin);
        if (url.searchParams.get("referral_code")) return;

        url.searchParams.set("referral_code", code);
        a.href = url.pathname + url.search + url.hash;
      } catch (e) {
        // Malformed href - leave the link untouched.
      }
    });
  }

  function sync() {
    captureFromUrl();
    syncReferralField();
    syncOAuthLinks();
  }

  sync();
  document.addEventListener("DOMContentLoaded", sync);
  // Fires after every LiveView navigation (initial connect + subsequent live
  // navigations), so the auth-page sync also runs when the register/login
  // page is reached via an in-app `navigate` rather than a full page load.
  window.addEventListener("phx:page-loading-stop", sync);
})();
