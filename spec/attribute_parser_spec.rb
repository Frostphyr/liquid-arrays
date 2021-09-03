require 'spec_helper'

describe Arrays::AttributeParser do
  let (:context) { Liquid::Context.new }
  let (:parse_context) { Liquid::ParseContext.new }

  describe '#initialize' do
    context 'when parsing nothing' do
      it 'initializes successfully' do
        expect {
          Arrays::AttributeParser.new(parse_context, 'default', '')
        }.to_not raise_error
      end
    end

    context 'when parsing one value' do
      context 'when the value is valid' do
        it 'initializes successfully' do
          expect {
            Arrays::AttributeParser.new(parse_context, 'default', 'value1')
          }.to_not raise_error
        end
      end

      context 'when the value is invalid' do
        context 'when the value is a symbol' do
          it 'raises SyntaxError' do
            expect {
              Arrays::AttributeParser.new(parse_context, 'default', '<')
            }.to raise_error(Liquid::SyntaxError)
          end
        end
      end
    end

    context 'when parsing more than one value' do
      it 'raises SyntaxError' do
        expect {
          Arrays::AttributeParser.new(parse_context, 'default',
            'value1 value2')
        }.to raise_error(Liquid::SyntaxError)
      end
    end

    context 'when parsing pairs' do
      context 'when the pair is valid' do
        it 'initializes successfully' do
          expect {
            Arrays::AttributeParser.new(parse_context, 'default',
              'key1:value1 key2:value2')
          }.to_not raise_error
        end
      end

      context 'when the key is invalid' do
        context 'when the key is a symbol' do
          it 'raises SyntaxError' do
            expect {
              Arrays::AttributeParser.new(parse_context, '-:value1')
            }.to raise_error(Liquid::SyntaxError)
          end
        end
      end

      context 'when the value is invalid' do
        context 'when the value is a symbol' do
          it 'raises SyntaxError' do
            expect {
              Arrays::AttributeParser.new(parse_context, 'key1:-')
            }.to raise_error(Liquid::SyntaxError)
          end
        end

        context 'when the value is an invalid array' do
          context 'when the array is missing an element at the start' do
            it 'raises SyntaxError' do
              expect {
                Arrays::AttributeParser.new(parse_context, 'array:,"value2"')
              }.to raise_error(Liquid::SyntaxError)
            end
          end

          context 'when the array is missing an element in the middle' do
            it 'raises SyntaxError' do
              expect {
                Arrays::AttributeParser.new(parse_context, 'array:"value1",,"value3"')
              }.to raise_error(Liquid::SyntaxError)
            end
          end

          context 'when the array is missing an element at the end' do
            it 'raises SyntaxError' do
              expect {
                Arrays::AttributeParser.new(parse_context, 'array:"value1",')
              }.to raise_error(Liquid::SyntaxError)
            end
          end
        end

        context 'when the value is an invalid hash' do
          context 'when pairs are missing values' do
            it 'raises SyntaxError' do
              expect {
                Arrays::AttributeParser.new(parse_context, 'hash:"key1"-"value1","key2","key3"')
              }.to raise_error(Liquid::SyntaxError)
            end
          end
        end
      end
    end

    context 'when parsing pair with string key' do
      it 'raises SyntaxError' do
        expect {
          Arrays::AttributeParser.new(parse_context, 'default', '"key":value1')
        }.to raise_error(Liquid::SyntaxError)
      end
    end
  end

  describe '#consume_attribute' do
    context 'when consuming an existent attribute with any type' do
      let(:parser) do
        Arrays::AttributeParser.new(parse_context, 'default',
          'key1:value1 key2:"value2" key3:3 key4:4.4 key5:true key6:"value6",3'\
          'key7:"hash_key7">"value7","hash_key7_2">"value7-2"')
      end

      it 'returns the id value' do
        expect(parser.consume_attribute('key1').render(context)).to be_nil
      end

      it 'returns the string value' do
        expect(parser.consume_attribute('key2').render(context)).to eq('value2')
      end

      it 'returns the integer value' do
        expect(parser.consume_attribute('key3').render(context)).to eq(3)
      end

      it 'returns the float value' do
        expect(parser.consume_attribute('key4').render(context)).to eq(4.4)
      end

      it 'returns the boolean value' do
        expect(parser.consume_attribute('key5').render(context)).to eq(true)
      end

      it 'returns the array value' do
        expect(parser.consume_attribute('key6').render(context))
          .to eq(['value6', 3])
      end

      it 'returns the hash value' do
        expect(parser.consume_attribute('key7').render(context))
          .to eq({'hash_key7' => 'value7', 'hash_key7_2' => 'value7-2'})
      end
    end

    context 'when consuming a nonexistent attribute' do
      let(:parser) { Arrays::AttributeParser.new(parse_context, 'default', '') }

      it 'returns nil' do
        expect(parser.consume_attribute('default')).to be_nil
      end
    end

    context 'when consuming an existent attribute with the valid type' do
      context 'when the attribute is an id' do
        let(:parser) do
          Arrays::AttributeParser.new(parse_context, 'default', 'key1:value1')
        end

        context 'when the type is an id' do
          it 'returns the id value' do
            expect(parser.consume_attribute('key1', :id)).to eq('value1')
          end
        end

        context 'when the type is an array' do
          it 'returns the array value' do
            expect(parser.consume_attribute('key1', :array).render(context))
              .to eq([nil])
          end
        end

        context 'when the type is a string' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :string).render(context))
              .to be_nil
          end
        end

        context 'when the type is an integer' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :integer).render(context))
              .to be_nil
          end
        end

        context 'when the type is a float' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :float).render(context))
              .to be_nil
          end
        end

        context 'when the type is a boolean' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :boolean).render(context))
              .to be_nil
          end
        end

        context 'when the type is a hash' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :hash).render(context))
              .to be_nil
          end
        end
      end

      context 'when the attribute is a string' do
        let(:parser) do
          Arrays::AttributeParser.new(parse_context, 'default', 'key1:"value1"')
        end

        context 'when the type is a string' do
          it 'returns the string value' do
            expect(parser.consume_attribute('key1', :string).render(context))
              .to eq('value1')
          end
        end

        context 'when the type is an array' do
          it 'returns the array value' do
            expect(parser.consume_attribute('key1', :array).render(context))
              .to eq(['value1'])
          end
        end

        context 'when the type is an id' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :id)).to be_nil
          end
        end

        context 'when the type is an integer' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :integer)).to be_nil
          end
        end

        context 'when the type is a float' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :float)).to be_nil
          end
        end

        context 'when the type is a boolean' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :boolean)).to be_nil
          end
        end

        context 'when the type is a hash' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :hash)).to be_nil
          end
        end
      end

      context 'when the attribute is an integer' do
        let(:parser) do
          Arrays::AttributeParser.new(parse_context, 'default', 'key1:1 key2:-2')
        end

        context 'when the type is an integer' do
          it 'returns the integer value' do
            expect(parser.consume_attribute('key1', :integer).render(context))
              .to eq(1)
            expect(parser.consume_attribute('key2', :integer).render(context))
              .to eq(-2)
          end
        end

        context 'when the type is an array' do
          it 'returns the array value' do
            expect(parser.consume_attribute('key1', :array).render(context))
              .to eq([1])
          end
        end

        context 'when the type is an id' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :id)).to be_nil
          end
        end

        context 'when the type is a string' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :string)).to be_nil
          end
        end

        context 'when the type is a float' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :float)).to be_nil
          end
        end

        context 'when the type is a boolean' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :boolean)).to be_nil
          end
        end

        context 'when the type is a hash' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :hash)).to be_nil
          end
        end
      end

      context 'when the attribute is a float' do
        let(:parser) do
          Arrays::AttributeParser.new(parse_context, 'default', 'key1:1.2 key2:-2.3')
        end

        context 'when the type is a float' do
          it 'returns the float value' do
            expect(parser.consume_attribute('key1', :float).render(context))
              .to eq(1.2)
            expect(parser.consume_attribute('key2', :float).render(context))
              .to eq(-2.3)
          end
        end

        context 'when the type is an array' do
          it 'returns the array value' do
            expect(parser.consume_attribute('key1', :array).render(context))
              .to eq([1.2])
          end
        end

        context 'when the type is an id' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :id)).to be_nil
          end
        end

        context 'when the type is a string' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :string)).to be_nil
          end
        end

        context 'when the type is an integer' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :integer)).to be_nil
          end
        end

        context 'when the type is a boolean' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :boolean)).to be_nil
          end
        end

        context 'when the type is a hash' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :hash)).to be_nil
          end
        end
      end

      context 'when the attribute is a boolean' do
        let(:parser) do
          Arrays::AttributeParser.new(parse_context, 'default', 'key1:true key2:false')
        end

        context 'when the type is a boolean' do
          it 'returns the boolean value' do
            expect(parser.consume_attribute('key1', :boolean).render(context))
              .to eq(true)
            expect(parser.consume_attribute('key2', :boolean).render(context))
              .to eq(false)
          end
        end

        context 'when the type is an array' do
          it 'returns the array value' do
            expect(parser.consume_attribute('key1', :array).render(context))
              .to eq([true])
          end
        end

        context 'when the type is an id' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :id)).to be_nil
          end
        end

        context 'when the type is a string' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :string)).to be_nil
          end
        end

        context 'when the type is an integer' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :integer)).to be_nil
          end
        end

        context 'when the type is a float' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :float)).to be_nil
          end
        end

        context 'when the type is a hash' do
          it 'returns nil' do
            expect(parser.consume_attribute('key1', :hash)).to be_nil
          end
        end
      end

      context 'when the attribute is an array' do
        let(:parser) do
          Arrays::AttributeParser.new(parse_context, 'default', 
            'array:"value1",-2,value3')
        end

        context 'when the type is an array' do
          it 'returns the array' do
            expect(parser.consume_attribute('array', :array).render(context))
              .to eq(['value1', -2, nil])
          end
        end

        context 'when the type is an id' do
          it 'returns nil' do
            expect(parser.consume_attribute('array', :id)).to be_nil
          end
        end

        context 'when the type is a string' do
          it 'returns nil' do
            expect(parser.consume_attribute('array', :string)).to be_nil
          end
        end

        context 'when the type is an integer' do
          it 'returns nil' do
            expect(parser.consume_attribute('array', :integer)).to be_nil
          end
        end

        context 'when the type is a float' do
          it 'returns nil' do
            expect(parser.consume_attribute('array', :float)).to be_nil
          end
        end

        context 'when the type is a boolean' do
          it 'returns nil' do
            expect(parser.consume_attribute('array', :boolean)).to be_nil
          end
        end

        context 'when the type is a hash' do
          it 'returns nil' do
            expect(parser.consume_attribute('array', :hash)).to be_nil
          end
        end
      end

      context 'when the attribute is a hash' do
        let(:parser) do
          Arrays::AttributeParser.new(parse_context, 'default', 
            'hash:"key1">"value1","key2">-2,"key3">value3')
        end

        context 'when the type is a hash' do
          it 'returns the hash' do
            expect(parser.consume_attribute('hash', :hash).render(context))
              .to eq({'key1' => 'value1', 'key2' => -2, 'key3' => nil})
          end
        end

        context 'when the type is an array' do
          it 'returns the array value' do
            expect(parser.consume_attribute('hash', :array).render(context))
              .to eq([{'key1' => 'value1', 'key2' => -2, 'key3' => nil}])
          end
        end

        context 'when the type is an id' do
          it 'returns nil' do
            expect(parser.consume_attribute('hash', :id)).to be_nil
          end
        end

        context 'when the type is a string' do
          it 'returns nil' do
            expect(parser.consume_attribute('hash', :string)).to be_nil
          end
        end

        context 'when the type is an integer' do
          it 'returns nil' do
            expect(parser.consume_attribute('hash', :integer)).to be_nil
          end
        end

        context 'when the type is a float' do
          it 'returns nil' do
            expect(parser.consume_attribute('hash', :float)).to be_nil
          end
        end

        context 'when the type is a boolean' do
          it 'returns nil' do
            expect(parser.consume_attribute('hash', :boolean)).to be_nil
          end
        end
      end
    end
  end

  describe '#consume_required_attribute' do
    let (:parser) { Arrays::AttributeParser.new(parse_context, 'default', '"value"') }

    context 'when consuming existent required attributes' do
      it 'returns the the value' do
        expect(parser.consume_required_attribute('default').render(context))
          .to eq('value')
      end
    end

    context 'when consuming nonexistent required attributes' do
      it 'raises ArgumentError' do
        expect {
          parser.consume_required_attribute('key1')
        }.to raise_error(Liquid::ArgumentError)
      end
    end
  end

  describe '#finish' do
    let (:parser) { Arrays::AttributeParser.new(parse_context, 'default', 'value') }

    context 'when finishing empty parser' do
      it 'finishes successfully' do
        parser.consume_attribute('default')
        expect { parser.finish }.to_not raise_error
      end
    end

    context 'when finishing not empty parser' do
      it 'raises ArgumentError' do
        expect { parser.finish }.to raise_error(Liquid::ArgumentError)
      end
    end
  end
end