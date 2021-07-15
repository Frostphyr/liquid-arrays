require 'spec_helper'

describe Arrays::AttributeParser do
  let (:context) { Liquid::Context.new }
  let (:parse_context) { Liquid::ParseContext.new }

  describe '#initialize' do
    context 'when parsing one value' do
      it 'initializes successfully' do
        expect {
          Arrays::AttributeParser.new(parse_context, 'default', 'value1')
        }.to_not raise_error
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
      it 'initializes successfully' do
        expect {
          Arrays::AttributeParser.new(parse_context, 'default',
            'key1:value1 key2:value2')
        }.to_not raise_error
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
    let(:parser) do
      Arrays::AttributeParser.new(parse_context, 'default',
        'key1:value1 key2:"value2" key3:3 key4:4.4 key5:true')
    end

    context 'when consuming an existent attribute with any type' do
      it 'returns id value' do
        expect(parser.consume_attribute('key1').render(context)).to be_nil
      end

      it 'returns string value' do
        expect(parser.consume_attribute('key2').render(context)).to eq('value2')
      end

      it 'returns integer value' do
        expect(parser.consume_attribute('key3').render(context)).to eq(3)
      end

      it 'returns float value' do
        expect(parser.consume_attribute('key4').render(context)).to eq(4.4)
      end

      it 'returns boolean value' do
        expect(parser.consume_attribute('key5').render(context)).to eq(true)
      end
    end

    context 'when consuming a nonexistent attribute' do
      it 'returns nil' do
        expect(parser.consume_attribute('key6')).to be_nil
      end
    end

    context 'when consuming an existent attribute with the valid type' do
      it 'returns id value' do
        expect(parser.consume_attribute('key1', :id)).to eq('value1')
      end

      it 'returns string value' do
        expect(parser.consume_attribute('key2', :string).render(context))
          .to eq('value2')
      end

      it 'returns integer value' do
        expect(parser.consume_attribute('key3', :integer).render(context))
          .to eq(3)
      end

      it 'returns float value' do
        expect(parser.consume_attribute('key4', :float).render(context))
          .to eq(4.4)
      end

      it 'returns boolean value' do
        expect(parser.consume_attribute('key5', :boolean).render(context))
          .to eq(true)
      end
    end

    context 'when consuming an existent attribute with invalid type' do
      it 'returns nil' do
        expect(parser.consume_attribute('key1', :string).render(context))
          .to be_nil
      end

      it 'returns nil' do
        expect(parser.consume_attribute('key2', :id)).to be_nil
      end

      it 'returns nil' do
        expect(parser.consume_attribute('key3', :float)).to be_nil
      end

      it 'returns nil' do
        expect(parser.consume_attribute('key4', :integer)).to be_nil
      end

      it 'returns nil' do
        expect(parser.consume_attribute('key5', :id)).to be_nil
      end
    end
  end

  describe '#consume_required_attribute' do
    let (:parser) { Arrays::AttributeParser.new(parse_context, 'default', '"value"') }

    context 'when consuming existent required attributes' do
      it 'returns the value' do
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