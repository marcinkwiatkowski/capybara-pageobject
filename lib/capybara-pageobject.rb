require "capybara-pageobject/version"
require "monkey-patch/string"
require "monkey-patch/object"

module Capybara
  module PageObject
    autoload :Page, 'capybara-pageobject/page'
    autoload :CapybaraHelper, 'capybara-pageobject/capybara_helper'
    autoload :Element, 'capybara-pageobject/element'
    autoload :Attribute, 'capybara-pageobject/attribute'
    autoload :Action, 'capybara-pageobject/action'
    autoload :Website, 'capybara-pageobject/website'
  end
end
