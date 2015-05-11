# coding: utf-8
lib = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "yml_builder/version"

module YmlBuilder # :nodoc:
  require "yml_builder/stats"
  require "yml_builder/common"
  require "yml_builder/shop"
  require "yml_builder/currencies"
  require "yml_builder/categories"
  require "yml_builder/common_offer"
  require "yml_builder/offer_simple"
  require "yml_builder/offer_vendor_model"
  require "yml_builder/offers"
  require "yml_builder/offer"
  require "yml_builder/yml"
end
