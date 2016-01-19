module ContextualLogging
  class LogstashMessageFormatter
    MAX_MESSAGE_LENGTH = 2000

    def format(severity, message, extra_context)
      if severity == 'INFO'
        truncated_message = message[0...MAX_MESSAGE_LENGTH]
        limited_extra_context = HashWithIndifferentAccess.new
        extra_context.each do |key,value|
          if value.is_a?(Hash)
            limited_extra_context[key] = HashWithIndifferentAccess.new
            value.each do |k,v|
              if v.is_a?(String)
                limited_extra_context[key][k] = v[0...MAX_MESSAGE_LENGTH]
              else
                limited_extra_context[key][k] = v.inspect[0...MAX_MESSAGE_LENGTH]
              end
            end
          else
            limited_extra_context[key] = value
          end
        end
      end

      if severity == 'INFO'
        msg_hash = HashWithIndifferentAccess.new('message' => truncated_message, 'log_level' => severity)
        logstash_data = limited_extra_context.merge(msg_hash)
      else
        msg_hash = HashWithIndifferentAccess.new('message' => message, 'log_level' => severity)
        logstash_data = extra_context.merge(msg_hash)
      end

      logstash_event = LogStash::Event.new(logstash_data)
      logstash_event.to_json
    end
  end
end
