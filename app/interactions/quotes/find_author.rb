require "active_interaction"

class Quotes::FindAuthor < ActiveInteraction::Base
  object :quote, class: "Quote"

  attr_reader :quote

  OPENAI_MODEL = "gpt-3.5-turbo"
  OPENAI_USER_ROLE = "user"
  OPENAI_SYSTEM_ROLE = "system"

  def execute
    begin
      response =
        client.chat(
          parameters: {
            model: OPENAI_MODEL,
            messages: [
              {
                role: OPENAI_USER_ROLE,
                content: quote.name
              },
              {
                role: OPENAI_SYSTEM_ROLE,
                content: system_prompt
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

  def system_prompt
    "You will be directly given a quote by the user. The
    quote may be exactly worded correctly, or it may be paraphrased
    incorrectly. Do your best to guess who is the author of the quote.
    You should start off by saying 'It sounds like you may be quoting'.
    Then, give a fun fact about the author of the quote, no more than
    20 words. If the author of the quote is a character, then give a
    fun fact about the character itself, not the author who created
    the character."
  end
end
