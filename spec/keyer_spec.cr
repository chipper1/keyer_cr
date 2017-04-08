require "./spec_helper"

describe Keyer do
  describe "Successful contexts" do
    it "can turn a string key value pair an hash-like object" do
      v = Keyer::Parser.new("asdf=1234")
      v["asdf"]?.should eq("1234")
    end

    it "can get nested values" do
      v = Keyer::Parser.new("asdf[qwer]=1234")
      v["asdf"]["qwer"].should eq("1234")
    end

    it "can handle multiple parameters of mixed depth" do
      v = Keyer::Parser.new("a=7&asdf[qwer][poiu]=1234&cat=meow")
      v["asdf"]["qwer"]["poiu"].should eq("1234")
      v["a"].should eq("7")
      v["cat"].should eq("meow")
    end
  end

  describe "nil contexts" do
    it "returns nil for invalid key" do
      v = Keyer::Parser.new("asdf=1234")
      v["asadf"]?.should eq(nil)
    end

    it "returns nil for invalid nested key" do
      v = Keyer::Parser.new("a[s][d][f]=1234")
      v["a"]["d"]?.should eq(nil)
    end

    it "returns nil for malformed nested key" do
      v = Keyer::Parser.new("a[s][d]f=1234")
      v["a"]["s"]["d"]["f"]?.should eq(nil)
    end
  end

  describe "Failing contexts" do
    it "raises for invalid key" do
      v = Keyer::Parser.new("asdf=1234")
      expect_raises(Exception) { v["asadf"] }
    end

    it "raises for invalid nested key" do
      v = Keyer::Parser.new("a[s][d][f]=1234")
      expect_raises(Exception) { v["a"]["d"] }
    end

    it "raises for malformed nested key" do
      v = Keyer::Parser.new("a[s][d]f=1234")
      expect_raises(Exception) { v["a"]["s"]["d"]["f"] }
    end

    it "raises for over-reaching nested key" do
      v = Keyer::Parser.new("a[s][d][f]=1234")
      expect_raises(Exception) { v["a"]["s"]["d"]["f"]["g"] }
    end
  end
end
