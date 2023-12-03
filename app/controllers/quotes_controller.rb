class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy, :find_author]

  def index
    @quotes = current_company.quotes.ordered
  end

  def show
  end

  def new
    @quote = Quote.new
  end

  def create
    @quote = current_company.quotes.build(quote_params)

    if @quote.save
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "Quote was successfully created." }
        format.html { redirect_to quotes_path, notice: "Quote was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    render partial: "form", locals: { quote: @quote }
  end

  def update
    if @quote.update(quote_params)
      redirect_to quotes_path, notice: "Quote was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quote.destroy

    respond_to do |format|
      format.html { redirect_to quotes_path, notice: "Quote was successfully destroyed." }
      format.turbo_stream
    end
  end

  def find_author
    response =
      client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
                   {
                     role: "user",
                     content: @quote.name
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

    @ai_response = response.dig("choices", 0, "message", "content")

    respond_to do |format|
      # format.html { render turbo_stream: turbo_stream.replace("ai_response_for_#{@quote.id}", @ai_response) }
      format.html
      format.turbo_stream
    end
  end

  private

  def set_quote
    @quote = current_company.quotes.find(params[:id])
  end

  def quote_params
    params.require(:quote).permit(:name)
  end

  def client
    OpenAI::Client.new
  end
end
