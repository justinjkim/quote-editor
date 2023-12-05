# README

## Introduction
I created this Rails 7 app in the hopes of familiarizing myself with Hotwire, as I am very interested in creating interactive and seamless pages without having to use too much client-side Javascript. If the server is capable of not only housing the logic but also rendering the HTML, then why not use an interactive tool like Hotwire?

I am using the excellent [hotrails.dev](https://www.hotrails.dev/turbo-rails) tutorial to build a simple quote editor.AI technology. However, I stopped following the tutorial around the half-way point because I wanted to change things up and incorporate API calls to [openAI's endpoints](https://platform.openai.com/docs/overview). Essentially, I want a user to input a quote they may have heard, and the openAI endpoint will return a response, guessing the author of the quote, as well as giving a fun fact about the author.

![quote-author](https://github.com/justinjkim/quote-editor/assets/15473295/9e1dfb5a-0230-4848-bfd1-8dec48140e9d)



## Setup

| Dependencies | Version     |
|--------------|-------------|
| Ruby         | 3.1.2       |
| Rails        | 7.0.8       |
| Bundler      | 2.3.7       |
| turbo-rails  | 1.5.0       |
| dotenv-rails | 2.8.1       |

### OpenAI Client
I have set up the `config/initializers/openai.rb` initializer, which uses my personal openAI access token and organization ID values from my `.env` file. To play with the editor on your own localhost, create your own `.env` file at the root directly and input your access token there, like so:
```
OPENAI_ACCESS_TOKEN=<openai_access_token>
OPENAI_ORGANIZATION_ID=<openai_organization_id>
```
**Note:** The `openai_organization_id` is optional.

I am a little confused on how the "free tier" in openAI works, because it seemed like no matter what I did, my API calls would fail because of a quota issue, even though I made sure not to hit the rate throttling. I settled for just paying $5 and that did seem to work, so perhaps I misunderstood the docs. If you're able to get the app working without paying a dime, that's awesome! Otherwise, if you're having issues, then I suggest checking your account's tier usage or rate limits, and making a small payment to see if that works.

### First steps
There are 2 scripts that should get you up and running. In the root directory, run these two files:
```
bin/setup
bin/dev
```

`bin/setup` gets the overall environment ready and prepares the database. `bin/dev` will install the `foreman` gem if it hasn't been installed yet, and run 3 separate process at the same time:
```
web: env RUBY_DEBUG_OPEN=true bin/rails server
js: yarn build --watch
css: yarn build:css --watch
```

Open the page to `localhost:3000/`, and you'll find a very ugly and unstyled login page. Here are the credentials you can use:
```
email: joe@basecamp.com
password: password
```
Why did I choose `@basecamp.com` for this test? Simply put, I've been growing in my admiration for the folks at [37signals](https://37signals.com) for their history of excellent products, customer service, and insights about the software industry.


**Note:** I thought the `bin/setup` file would prepare and seed the database, but turns out it doesn't. So, if you're having trouble logging in as `joe@basecamp.com`, run `bin/rails db:seed` and then try logging back in.


## Running the test suite
Coming soon...


## Learnings
As I created this project primarily for the purpose of learning Hotwire, I definitely ran into some obstacles in understanding how certain things worked. For example, even though on the tutorial I read that Rails 7 processes form submissions via turbo_streams, I forgot about that fact as I was furiously trying to figure out why I couldn't get my custom action in the `QuotesController` to process the request as a turbo_stream. Turns out that my custom action triggers a standard HTML request. I could've used a different gem such as `rails-ujs` to turn my GET request into an AJAX GET request, but that would've rendered the whole point of learning Hotwire useless.

Another big learning for me is that when calling a `render` block for a particular request format, the server wil look for the template with that format type. For example, my custom action could only understand HTML requests, and my `render` block to call the turbo_stream template kept failing. I finally figured out that I need to use the `formats: [:turbo_stream]` option to explicitly set the template type.



## Future Plans



## Contact
Have any questions or feedback on how I can improve my code? Send me an email at justinjkim@hey.com!
