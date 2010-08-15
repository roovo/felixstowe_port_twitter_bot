require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

describe Visit, "validations" do
  
  it "should be VALID with valid attributes" do
    visit = Visit.new(:vessel_name  => "plop")
    visit.should be_valid
  end
  
  it "should NOT be valid if the vessel_name is blank" do
    visit = Visit.new(:vessel_name  => "")
    visit.should_not be_valid
  end
end

describe Visit, "handle_arrival" do
  
  it "should add a new visit to the db if NO visit exists with the same vessel_name and the vessel has arrived" do
    lambda { Visit.handle_arrival(:vessel_name  => "plop") }.should change(Visit, :count).by(1)
  end
  
  it "should NOT add a new visit to the db if NO visit exists with the same vessel_name but the vessel has NOT arrived" do
    lambda { Visit.handle_arrival(:vessel_name  => "plop") }.should change(Visit, :count).by(1)
  end
  
  it "should NOT add a new visit to the db if a visit exists with the same vessel_name and the vessel has already arrived" do
    Visit.handle_arrival(:vessel_name  => "plop")
    lambda { Visit.handle_arrival(:vessel_name  => "plop") }.should_not change(Visit, :count)
  end
  
  it "should update the exisitng visit with the new attributes if an arrived visit exists for the same vessel_name is arrived again" do
    Visit.handle_arrival(:vessel_name  => "plop", :last_port => 'plop')
    Visit.handle_arrival(:vessel_name  => "plop", :last_port => 'plop_new')
    Visit.first(:vessel_name  => "plop").last_port.should == "plop_new"
  end
end

describe Visit, "handle_departure" do
  
  it "should remove a visit from the db if a visit exists with the same vessel_name, last_port, and next_port" do
    Visit.handle_arrival(:vessel_name  => "plop")
    lambda { Visit.handle_departure(:vessel_name  => "plop") }.should change(Visit, :count).by(-1)
  end
  
  it "should NOT remove a visit from the db if NO visit exists with the same vessel_name, last_port, and next_port" do
    lambda { Visit.handle_departure(:vessel_name  => "plop") }.should_not change(Visit, :count)
  end
end