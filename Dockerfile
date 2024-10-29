# Dockerfile
FROM ruby:3.1.3

# Set environment variables
ENV RAILS_ENV=development
ENV BUNDLE_PATH=/gems

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libsqlite3-dev

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the server
CMD ["rails", "server", "-b", "0.0.0.0"]
