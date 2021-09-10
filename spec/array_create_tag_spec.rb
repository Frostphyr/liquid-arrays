require 'spec_helper'

describe Arrays::ArrayCreateTag do
  let(:values) { {'values' => 'value0'} }

  context 'when creating an array without items' do
    let(:no_items) { '{%- array_create values -%}' }

    context 'when the variable is defined' do
      it 'creates a new empty array' do
        expect(render(no_items, values)).to eq([])
      end
    end

    context 'when the variable is undefined' do
      it 'creates a new empty array' do
        expect(render(no_items)).to eq([])
      end
    end
  end

  context 'when creating an array with items' do
    let(:with_items) do
      '{%- array_create array:values items:"value1","value2" -%}'
    end

    context 'when the variable is defined' do
      it 'creates a new array with the items' do
        expect(render(with_items, values)).to eq(['value1', 'value2'])
      end
    end

    context 'when the variable is undefined' do
      it 'creates a new array with the items' do
        expect(render(with_items)).to eq(['value1', 'value2'])
      end
    end
  end

  context 'when creating an array without an array specified' do
    context 'when items are not specified' do
      let(:no_array_no_items) { '{%- array_create -%}' }

      it 'raises SyntaxError' do
        expect {
          render(no_array_no_items)
        }.to raise_error(Liquid::SyntaxError)
      end
    end

    context 'when items are specified' do
      let(:no_array_with_items) do
        '{%- array_create items:"value1","value2" -%}'
      end

      it 'raises SyntaxError' do
        expect {
          render(no_array_with_items)
        }.to raise_error(Liquid::SyntaxError)
      end
    end
  end
end