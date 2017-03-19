require 'rails_helper'

RSpec.describe Subsection, type: :model do
  it "is saved with correct title" do
    subsection = Subsection.create title:"cake"

    expect(subsection).to be_valid
    expect(subsection.title).to eq("cake")
  end
end
