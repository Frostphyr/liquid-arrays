require 'spec_helper'

describe Arrays::ArrayDeleteTag do
  let(:values_1) { {'values' => ['value1']} }
  let(:values_2) { {'values' => ['value1', 'value2']} }

  context 'when deleting an element at an index' do
    let(:index_1) { '{%- array_delete array:values index:1 -%}' }

    context 'when the array is undefined' do
      it 'does nothing' do
        expect(render(index_1)).to be_nil
      end
    end

    context 'when the array is defined' do
      context 'when the index is in bounds' do
        it 'deletes the element at the index' do
          expect(render(index_1, values_2)).to eq(['value1'])
        end
      end

      context 'when the index is out of bounds' do
        it 'does nothing' do
          expect(render(index_1, values_1)).to eq(['value1'])
        end
      end

      context 'when the array is not an array' do
        let(:values_string) { {'values' => 'value1'} }

        it 'does nothing' do
          expect(render(index_1, values_string)).to eq('value1')
        end
      end
    end

    context 'when the array is not specified' do
      context 'when outside of an array block' do
        let(:no_array) { '{%- array_delete index:1 -%}' }

        it 'does nothing' do
          expect(render(no_array)).to be_nil
        end
      end

      context 'when inside of an array block' do
        let(:array_block) {
          '{%- array values -%}'\
            '{%- array_delete index:1 -%}'\
          '{%- endarray -%}'
        }
    
        it 'deletes the element at the index' do
          expect(render(array_block, values_2)).to eq(['value1'])
        end
      end
    end
  end

  context 'when deleting a value' do
    let(:value_2) { '{%- array_delete array:values value:"value2" -%}' }

    context 'when the array is undefined' do
      it 'does nothing' do
        expect(render(value_2)).to be_nil
      end
    end

    context 'when the array is defined' do
      context 'when the value exists' do
        it 'deletes the value' do
          expect(render(value_2, values_2)).to eq(['value1'])
        end
      end

      context 'when multiples of the value exist' do
        it 'deletes every occurance of the value' do
          expect(render(value_2, {'values' => ['value2', 'value1', 'value2']}))
            .to eq(['value1'])
        end
      end

      context 'when the value does not exist' do
        it 'does nothing' do
          expect(render(value_2, values_1)).to eq(['value1'])
        end
      end
    end

    context 'when the array is not specified' do
      context 'when outside of an array block' do
        let(:no_array) { '{%- array_delete index:1 -%}' }

        it 'does nothing' do
          expect(render(no_array)).to be_nil
        end
      end

      context 'when inside of an array block' do
        let(:array_block) {
          '{%- array values -%}'\
            '{%- array_delete index:1 -%}'\
          '{%- endarray -%}'
        }
    
        it 'deletes the element at the index' do
          expect(render(array_block, values_2)).to eq(['value1'])
        end
      end
    end
  end

  context 'when deleting with an index and a value' do
    let(:index_and_value) { '{%- array_delete array:values index:0 value:"value1" -%}' }

    it 'raises SyntaxError' do
      expect {
        render(index_and_value, values_1)
      }.to raise_error(Liquid::SyntaxError)
    end
  end

  context 'when deleting without index or value' do
    let(:no_index_or_value) { '{%- array_delete array:values -%}' }

    it 'raises SyntaxError' do
      expect {
        render(no_index_or_value, values_1)
      }.to raise_error(Liquid::SyntaxError)
    end
  end
end