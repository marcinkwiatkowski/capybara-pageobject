require 'spec_helper'

describe "Page" do
  def page_object(page_data)
    Capybara::PageObject::Page.new capybara_page, page_data
  end

  describe "on form page" do
    let(:page_data) { {
        "url" => "/form",
        "attributes" => {
            "attr1" => "#attr1",
            "attr2" => "#hidden_attr",
            "field1" => "#field1",
            "field2" => "#hidden_field"
        },
        "actions" => {
            "action1" => "#register_submit",
            "action2" => "#disabled_button",
        }
    } }

    before { capybara_page.visit("/form") }
    let(:page) { page_object(page_data) }
    subject { page }

    describe "attributes" do
      its(:attr1) { should == "led zeppelin" }
      its(:attr2) { should == "the doors" }

      it "should be able to use getter to also set attribute value" do
        page.field1 "some_value"
        page.field1.should == "some_value"
      end
    end

    describe "actions" do
      its(:action1) { should be_visible }
      its(:action2) { should be_disabled }
    end

    describe "responds_to" do
      it { should respond_to(:attr1) }
      it { should respond_to(:field1) }
      it { should respond_to(:action1) }
      it { should respond_to(:action2) }
    end

    describe "method_missing" do
      it "should delegate to capybara_page if it has method" do
        page_object({}).find_by_id("attr1")
      end

      it "should raise method missing if both capybar_page and itself don't have method'" do
        expect { page_object({}).does_not_exist }.to raise_error(NoMethodError, /undefined method `does_not_exist'/)
      end
    end
  end

  describe "visit" do
    it "should go to page mentioned in url" do
      page_object({"url" => "/form_with_rails_validation_errors"}).visit
      capybara_page.should have_content "Email Address"
    end

    it "should visit pages with dynamic urls" do
      page_object({"url" => "/users/:user_id/comments/:id"}).visit(user_id: 3, id: 2)
      capybara_page.should have_content "User data"
    end
  end

  describe "visible?" do
    it "should return true if id element is visible" do
      page = page_object({"url" => "/form_with_rails_validation_errors", "id" => "#registration-form"})
      page.visit
      page.should be_visible
    end

    it "should return false if id element is not present" do
      page = page_object({"url" => "/form_with_rails_validation_errors", "id" => "#does-not-exist"})
      page.visit
      page.should_not be_visible
    end

    it "should fail if id is not specified" do
      expect { page_object({}).visible? }.to raise_error(Exception, "id not defined for page")
    end
  end

  describe "has_content?" do
    before(:each) do
      @page = page_object({"url" => "/form"})
      @page.visit
    end
    it "should return true if content is present" do
      @page.should have_content "led zeppelin"
    end

    it "should handle dates" do
      @page.should have_content Date.parse("1983-01-01")
    end
  end

  describe "page_title" do
    it "should return page title if page has title in head" do
      page = page_object({"url" => "/form"})
      page.visit
      page.page_title.should == "Classic Rock"
    end

    it "should return empty if title is not defined" do
      page = page_object({"url" => "/div"})
      page.visit
      page.page_title.should be_empty
    end
  end

  describe "include rspec matchers" do
    it { page_object({}).be_visible }
    it { page_object({}).be_present }
  end

  it { page_object({"name" => "page"}).to_s.should == "'page: page'" }
end