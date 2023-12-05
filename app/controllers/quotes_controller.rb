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
      respond_to do |format|
        format.html { redirect_to quotes_path, notice: "Quote was successfully updated." }
        format.turbo_stream
      end

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
    outcome = Quotes::FindAuthor.run(quote: @quote)

    if outcome.valid?
      @ai_response = outcome.result

      respond_to do |format|
        format.html do
          render "quotes/find_author", formats: [:turbo_stream]
        end
      end
    else
      render :edit, status: :unprocessable_entity
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
