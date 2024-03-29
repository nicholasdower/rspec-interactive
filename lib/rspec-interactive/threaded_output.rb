module RSpec
  module Interactive
    class ThreadedOutput
      attr_reader :string

      def initialize(thread_map:, default:)
        @thread_map = thread_map
        @default = default
        @string = ''
      end

      def write(name, str = "")
        (@thread_map[Thread.current] || @default).write(name, str)
      end

      def puts(str = "")
        (@thread_map[Thread.current] || @default).puts(str)
      end

      def print(str = "")
        (@thread_map[Thread.current] || @default).puts(str)
      end

      def flush
        (@thread_map[Thread.current] || @default).flush
      end

      def closed?
        (@thread_map[Thread.current] || @default).closed?
      end

      def sync=(sync)
        (@thread_map[Thread.current] || @default).sync = sync
      end

      def sync
        (@thread_map[Thread.current] || @default).sync
      end

      def close
        (@thread_map[Thread.current] || @default).close
      end
    end
  end
end
