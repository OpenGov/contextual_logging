require 'spec_helper'

describe ContextualLogging::LogstashMessageFormatter do
  message_formatter = ContextualLogging::LogstashMessageFormatter.new
    it 'should limit message size to 2000 characters when severity level is INFO' do
      message = (0...3000).map { ('a'..'z').to_a[rand(26)] }.join
      log_message = message_formatter.format('INFO', message, {})
      expect(JSON[log_message]['message'].length).to equal 2000
    end

    it 'should limit extra context values that are two levels deep to 2000 characters when severity level is INFO' do
      message = (0...3000).map { ('a'..'z').to_a[rand(26)] }.join
      extra_context = HashWithIndifferentAccess.new()
      extra_context['params'] = HashWithIndifferentAccess.new(nodes: {})
      extra_context['text'] = (0...3000).map { ('a'..'z').to_a[rand(26)] }.join
      extra_context['params']['nodes']['a'] = (0...3000).map { ('a'..'z').to_a[rand(26)] }.join

      log_message = message_formatter.format('INFO', message, extra_context)
      expect(JSON[log_message]['params']['nodes'].length).to equal 2000
      expect(JSON[log_message]['text'].length).to equal 3000
    end

end
