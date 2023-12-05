require "active_interaction"

class Quotes::FindAuthor < ActiveInteraction::Base
  object :quote, class: "Quote"

  attr_reader :quote

  def execute
    # TODO: rescue Faraday::TimeoutError, or Net::ReadTimeout when API fails
    begin
      response =
        client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [
              {
                role: "user",
                content: quote.name
              },
              {
                role: "system",
                content: "You will be directly given a quote by the user. The
                  quote may be exactly worded correctly, or it may be paraphrased
                  incorrectly. Do your best to guess who is the author of the quote.
                  You should start off by saying 'It sounds like you may be quoting'.
                  Then, give a fun fact about the author of the quote, no more than
                  20 words. If the author of the quote is a character, then give a
                  fun fact about the character itself, not the author who created
                  the character."
               }
             ],
            temperature: 0.7
          }
        )

      response.dig("choices", 0, "message", "content")
    rescue Faraday::TimeoutError => e
      # In an ideal world, I would log this somewhere like in Datadog,
      # but as this is a local app for now, I'll just print something
      # in the console
      puts "Took too long! #{e}"

      raise e
    end
  end

  private

  def client
    OpenAI::Client.new
  end
end
