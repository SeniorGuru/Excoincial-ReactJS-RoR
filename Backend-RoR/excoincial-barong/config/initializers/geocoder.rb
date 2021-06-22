# encoding: UTF-8
# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# To avoid calls to a remote API configure Geocoder to use GeoLite2 City maxminb.
Geocoder.configure(
  ip_lookup: :geoip2,
  geoip2: {
    file: Rails.root.join("lib", "GeoLite2-City.mmdb")
  }
)
