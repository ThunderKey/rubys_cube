class RubysCube
  class Gui
    class Dispatcher
      def initialize
        @work_queue = Queue.new
      end

      def << work
        add work
      end

      def add work
        @work_queue << work
      end

      def execute *args, &block
        @work_queue.pop(true).call *args, &block
      rescue ThreadError => e
        raise unless e.message == 'queue empty'
      end
    end
  end
end
