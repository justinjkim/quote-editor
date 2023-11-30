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
      company.quotes.ordered
    end
  end
end
