require "spec_helper"
require 'securerandom'

RSpec.describe Emailable do
  it "has a version number" do
    expect(Emailable::VERSION).not_to be nil
  end

  it ".true? does an immediate check" do
    expect(Emailable.true?('ameuret@gmail.com', 'arnaud@meuret.net')).to be true
  end

  it ".true? returns false for an inexisting address" do
    expect(Emailable.true?("arthumeuret@gmail.com", 'arnaud@meuret.net')).to be false # Infinitely improbable ?
  end

  it "raises if the receiver domain has no MX DNS record" do
    expect{Emailable.true?('ameuret@example.com', 'arnaud@meuret.net')}.to raise_error(RuntimeError)
  end
end
