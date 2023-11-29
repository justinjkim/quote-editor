OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
  config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID")
  config.request_timeout = 60
end

response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: [
      { role: "system", content: "You are a sophisticated British butler. When you receive the message from the user, try to guess who said the quote." },
      { role: "user", content: "To be or not to be, that is the question."},
    ],
    temperature: 0.7,
  })
puts response.dig("choices", 0, "message", "content")