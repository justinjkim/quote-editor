require "rails_helper"

RSpec.describe Quotes::FindAuthor do
  subject { described_class }

  let!(:company1) { Company.create!(name: "Google") }
  let!(:quote1) { Quote.create!(name: "test", company: company1) }
  let(:client_response1) { Hash.new }

  context "self" do
    it "knows its properties" do
      expect(subject::OPENAI_MODEL).to eq("gpt-3.5-turbo")
      expect(subject::OPENAI_USER_ROLE).to eq("user")
      expect(subject::OPENAI_SYSTEM_ROLE).to eq("system")
    end
  end

  context "instance" do
    before do
      allow_any_instance_of(OpenAI::Client).to receive(:chat).and_return(client_response1)
      allow(client_response1).to receive(:dig).and_return("something")
    end

    it "knows its properties" do
      outcome = subject.run(quote: quote1)

      expect(outcome.quote).to eq(quote1)
    end

    it "returns a response from the API" do
      outcome = subject.run(quote: quote1)

      expect(outcome.result).to eq("something")
    end

    context "when API response takes too long" do
      before do
        allow_any_instance_of(OpenAI::Client).to receive(:chat).and_raise(Faraday::TimeoutError.new("Timeout"))
      end

      it "raises an exception" do
        expect { subject.run(quote: quote1) }.to raise_error(Faraday::TimeoutError)
      end
    end
  end
end
