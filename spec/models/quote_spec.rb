require "rails_helper"

RSpec.describe Quote do
  subject { described_class }

  let(:company1) { Company.create!(name: "Basecamp") }

  context "instance" do
    subject do
      described_class.create!(name: "quote", company_id: company1.id)
    end

    it "knows its properties" do
      subject

      expect(subject.name).to eq("quote")
      expect(subject.company).to eq(company1)
    end
  end
end
