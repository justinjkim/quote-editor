require "active_interaction"

class Quotes::Index < ActiveInteraction::Base
  object :company, class: "Company"
  
  attr_reader :quotes
  
  def execute
    # No-op, since we're not executing any complex logic on this view
  end
  
  def view
    View.new(company: company)
  end
  
  class View
    attr_reader :company
    
    def initialize(company:)
      @company = company
    end
    
    def quotes
      company.quotes.ordered.map do |quote|
        QuoteItem.new(quote: quote)
      end
    end
  end
  
  class QuoteItem
    def initialize(quote:)
      @quote = quote
    end
    
    def turbo_frame_tag_id
      quote.persisted? ? "quote_#{quote.id}" : "new_quote"
    end
    
    def name
      quote.name
    end
    
    def quote_path
      Rails.application.routes.url_helpers.quote_path(quote)
    end
    
    def edit_quote_path
      Rails.application.routes.url_helpers.edit_quote_path(quote)
    end
    
    def find_author
      response =
        client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [
                     {
                       role: "user",
                       content: name
                     },
                     {
                       role: "system",
                       content: "You are a sophisticated English butler. You will
                  be directly given a quote by the user. The quote may be exactly
                  worded correctly, or it may be paraphrased incorrectly. Do your
                  best to guess who is the author of the quote. Then, give a fun
                  fact about the author of the quote, no more than 20 words. If
                  the author of the quote is a character, then give a fun fact
                  about the character itself, not the author who created the
                  character."
                     }
                   ],
            temperature: 0.7
          }
        )
      
      puts response.dig("choices", 0, "message", "content")
    end
    
    private
    
    attr_reader :quote
    
    def client
      @client ||= OpenAI::Client.new
    end
  end
end
