require "./spec_helper"

describe Keyer do
  it "can turn a string key value pair an hash-like object" do
    v = Keyer::Parser.new("asdf=1234")
    v["asdf"]?.should eq("1234")
  end

  it "can get nested values" do
    v = Keyer::Parser.new("asdf[qwer]=1234")
    v["asdf"]["qwer"].should eq("1234")
  end
end
