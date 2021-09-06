require 'spec_helper'

describe Arrays::ArrayAddTag do
  context 'when adding a string' do
    let(:values) { {'values' => ['value1']} }
    let(:string) { '{%- array_add array:values value:"value0" -%}' }

    context 'when the array is undefined' do
      it 'creates and adds the value to the array' do
        expect(render(string)).to eq(['value0'])
      end
    end

    context 'when the array is defined' do
      context 'when the array is an array' do
        it 'adds the value to the array' do
          expect(render(string, values)).to eq(['value1', 'value0'])
        end
      end

      context 'when the array is not an array' do
        let(:values_string) { {'values' => 'value1'} }

        it 'does nothing' do
          expect(render(string, values_string)).to eq('value1')
        end
      end
    end

    context 'when the array is not specified' do
      context 'when outside of an array block' do
        let(:no_array) { '{%- array_add value:"value0" -%}' }

        it 'does nothing' do
          expect(render(no_array)).to be_nil
        end
      end

      context 'when inside of an array block' do
        let(:array_block) {
          '{%- array values -%}'\
            '{%- array_add value:"value0" -%}'\
          '{%- endarray -%}'
        }
    
        it 'adds the value to the array' do
          expect(render(array_block, values)).to eq(['value1', 'value0'])
        end
      end
    end
  end

  context 'when adding an array' do
    let(:array) { '{%- array_add array:values value:"value1","value2" -%}' }

    it 'creates and adds the array as en element to the main array' do
      expect(render(array)).to eq([['value1', 'value2']])
    end
  end

  context 'when adding a hash' do
    let(:hash) { '{%- array_add array:values value:"key1">"value1","key2">"value2" -%}' }

    it 'creates and adds the hash as en element to the array' do
      expect(render(hash)).to eq([{'key1' => 'value1', 'key2' => 'value2'}])
    end
  end

  context 'when adding without a value' do
    let(:no_value) { '{%- array_add array:values -%}' }

    it 'raises SyntaxError' do
      expect { render(no_value) }.to raise_error(Liquid::SyntaxError)
    end
  end
end