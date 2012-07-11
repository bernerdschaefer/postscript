module PostScript
  module Support
    module StateMachine
      def self.included(base)
        base.extend ClassMethods
      end

      class Context < Hash
        attr_reader :state

        def initialize(state, initial = {})
          @state = state

          super()
          update initial
        end

        def transition(new_state)
          @state = new_state
        end

        def trigger(event)
          self[:machine].trigger self, event
        end

        def inspect
          Hash[self].except(:machine).inspect
        end
      end

      class Machine
        def initialize
          @states = {}
        end

        def trigger(context, event)
          context[:machine] = self
          assert_state context.state

          state = @states[context.state]
          state.trigger(context, event)
        end

        def state(name, &block)
          @states[name] = State.new(name, block)
        end

        def assert_state(name)
          unless @states.has_key? name
            raise "Undefined state: #{name.inspect}. Known states: #{@states.keys.inspect}"
          end
        end

        class State
          def initialize(name, block)
            @name = name
            @event_handlers = {}

            instance_eval(&block) if block
          end

          def trigger(context, event)
            event_handler = @event_handlers.find do |matcher,|
              if Symbol === event
                matcher == event
              else
                matcher === event
              end
            end

            if event_handler
              if handler = event_handler.last
                handler.call(context, event)
              end
              true
            else
              raise "Unhandled event #{event.inspect} for state: #{@name.inspect}"
            end
          end

          def on(*args, &block)
            handlers = [block]

            while args.last.respond_to?(:call)
              handlers.unshift args.pop
            end

            handlers.compact!

            args.each do |matcher|
              @event_handlers[matcher] = ->(context, event) do
                handlers.each { |handler| handler.call(context, event) }
              end
            end
          end
        end

      end

      module ClassMethods
        def machine
          @machine ||= Machine.new
        end

        def state(name, &block)
          machine.state(name, &block)
        end
      end

      def machine
        self.class.machine
      end

    end
  end
end
