require 'spec_helper'

describe ContextualLogging::LogstashMessageFormatter do
  message_formatter = ContextualLogging::LogstashMessageFormatter.new
    it 'should limit message size to 2000 characters when severity level is INFO' do
      message = (0...3000).map { ('a'..'z').to_a[rand(26)] }.join
      log_message = message_formatter.format('INFO', message, {})
      expect(eval(log_message)[:message].length).to equal 2000
    end
end
