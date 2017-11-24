require "spec_helper"
require 'securerandom'

RSpec.describe Emailable do
  it "has a version number" do
    expect(Emailable::VERSION).not_to be nil
  end

  describe ".true?" do
    it "does an immediate check" do
      expect(Emailable.true?('ameuret@gmail.com', 'arnaud@meuret.net')).to be true
    end

    it "returns false for an inexisting address" do
      expect(Emailable.true?("arthumeuret@gmail.com", 'arnaud@meuret.net')).to be false
    end

    it "raises if the receiver domain has no MX DNS record" do
      expect{Emailable.true?('ameuret@example.com', 'arnaud@meuret.net')}.to raise_error(RuntimeError)
    end
  end
  
  describe '.true!' do
    it 'raises Emailable::Refused if the address does not pass' do
      expect{Emailable.true!("arthumeuret@gmail.com", 'arnaud@meuret.net')}.to raise_error(Emailable::Refused)
    end
  end

  describe 'Checker' do
    it 'is initialized with a sender address' do
      c = Emailable::Checker.new('ameuret@gmail.com')
    end

    describe '#emailable?' do
      it "returns false for an inexisting address" do
        c = Emailable::Checker.new('arnaud@meuret.net')
        expect(c.emailable?("arthumeuret@gmail.com")).to be false
      end
    end

    describe '#emailable!' do
      it 'raises Emailable::Refused if the address does not pass' do
        c = Emailable::Checker.new('ameuret@gmail.com')
        expect{c.emailable!('arthumeuret@gmail.com')}.to raise_error(Emailable::Refused)
    end
    end
  end
end
