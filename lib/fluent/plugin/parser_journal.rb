# fluent-plugin-journal-parser
# Copyright 2016 One.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

begin # fluentd >= 0.14
  require 'fluent/plugin/parser'

  module Fluent
    module Plugin
      class JournalParser < Parser
        Plugin.register_parser('journal', self)

        def parse(text)
          ret = []
          length = text.length
          n = 0
          while n < length
            record = {}
            while (m = text.index(/[=\n]/, n)) != n
              raise ParserError if m.nil?
              key = text.slice(n, m-n)
              n = m+1 # continue parsing after newline/equal sign
              if text[m] == '=' # simple field
                m = text.index("\n", n)
                value = text.slice(n, m-n)
              else # text[m] == "\n" # binary safe field
                m = text.slice(n, 8).unpack('Q<')[0]
                n += 8
                value = text.slice(n, m)
                m = n+m
              end
              record[key] = value
              n = m+1 # continue parsing after ending newline
            end
            # set timestamp from __REALTIME_TIMESTAMP field
            ns = record['__REALTIME_TIMESTAMP']
            if ns
              ns = ns.to_i
              record['time'] = EventTime.new(ns / 1000000, ns % 1000000)
            end
            ret.push(record)
            n = m+1 # continue parsing after empty line
          end
          yield nil, ret
        end

      end
    end
  end
rescue LoadError # fluentd < 0.14
  require 'fluent/parser'

  module Fluent
    class JournalParser < Parser
      Fluent::Plugin.register_parser('journal', self)

      def parse(text)
        ret = []
        length = text.length
        n = 0
        while n < length
          record = {}
          while (m = text.index(/[=\n]/, n)) != n
            raise ParserError if m.nil?
            key = text.slice(n, m-n)
            n = m+1 # continue parsing after newline/equal sign
            if text[m] == '=' # simple field
              m = text.index("\n", n)
              value = text.slice(n, m-n)
            else # text[m] == "\n" # binary safe field
              m = text.slice(n, 8).unpack('Q<')[0]
              n += 8
              value = text.slice(n, m)
              m = n+m
            end
            record[key] = value
            n = m+1 # continue parsing after ending newline
          end
          # set timestamp from __REALTIME_TIMESTAMP field
          ns = record['__REALTIME_TIMESTAMP']
          if ns
            record['time'] = ns.to_i / 1000000
          end
          ret.push(record)
          n = m+1 # continue parsing after empty line
        end
        yield nil, ret
      end

    end
  end
end

# vim: set ts=2 sw=2 et:
