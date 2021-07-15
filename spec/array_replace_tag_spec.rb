require 'spec_helper'

describe Arrays::ArrayReplaceTag do
  context 'when replacing an element at an index' do
    let(:values_1) { {'values' => ['value1']} }
    let(:index_0) { '{%- array_replace array:values index:0 value:"value0" -%}' }
    let(:index_1) { '{%- array_replace array:values index:1 value:"value0" -%}' }

    context 'when the array is undefined' do
      it 'does nothing' do
        expect(render(index_0)).to be_nil
      end
    end

    context 'when the array is defined' do
      context 'when the index is in bounds' do
        it 'replaces the element at the index' do
          expect(render(index_0, values_1)).to eq(['value0'])
        end
      end

      context 'when the index is out of bounds' do
        it 'does nothing' do
          expect(render(index_1, values_1)).to eq(['value1'])
        end
      end
    end

    context 'when the array is not specified' do
      context 'when outside of an array block' do
        let(:no_array) { '{%- array_replace index:0 value:"value0" -%}' }

        it 'does nothing' do
          expect(render(no_array)).to be_nil
        end
      end

      context 'when inside of an array block' do
        let(:array_block) {
          '{%- array values -%}'\
            '{%- array_replace index:0 value:"value0" -%}'\
          '{%- endarray -%}'
        }

        it 'replaces the value at the index' do
          expect(render(array_block, values_1)).to eq(['value0'])
        end
      end
    end
  end

  context 'when replacing an element without an index' do
    let(:no_index) { '{%- array_replace array:values values:"value0" -%}' }

    it 'raises ArgumentError' do
      expect { render(no_index) }.to raise_error(Liquid::ArgumentError)
    end
  end

  context 'when replacing an element without a value' do
    let(:no_value) { '{%- array_replace array:values index:0 -%}' }

    it 'raises ArgumentError' do
      expect { render(no_value) }.to raise_error(Liquid::ArgumentError)
    end
  end
end