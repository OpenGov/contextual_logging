module ContextualLogging
  class LogstashMessageFormatter
    def format(severity, message, extra_context)
      max_length = 2000

      if severity == 'INFO'
        message = message[0...max_length]
        limited_extra_context = HashWithIndifferentAccess.new()
        extra_context.each do |key,value|
          if value.class == HashWithIndifferentAccess
            limited_extra_context[key] = HashWithIndifferentAccess.new()
            value.each do |k,v|
              limited_extra_context[key][k] = v.inspect[0...max_length]
            end
          else
            limited_extra_context[key] = value
          end
        end
      end

      msg_hash = HashWithIndifferentAccess.new('message' => message, 'log_level' => severity)
      logstash_data = (severity == 'INFO') ? limited_extra_context.merge(msg_hash) : extra_context.merge(msg_hash)
      logstash_event = LogStash::Event.new(logstash_data)
      logstash_event.to_json
    end
  end
end
