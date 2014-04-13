require File.dirname(__FILE__) + '/../spec_helper'

describe Document do
  it "should be valid" do
    Document.new.should be_valid
  end
end
