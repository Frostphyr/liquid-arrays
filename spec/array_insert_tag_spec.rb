require 'spec_helper'

describe Arrays::ArrayInsertTag do
  context 'when inserting a string' do
    let(:values_1) { {'values' => ['value1']} }
    let(:values_2) { {'values' => ['value1', 'value2']} }
    let(:index_0) { '{%- array_insert array:values index:0 value:"value0" -%}' }
    let(:index_1) { '{%- array_insert array:values index:1 value:"value0" -%}' }
    let(:index_2) { '{%- array_insert array:values index:2 value:"value0" -%}' }

    context 'when the array is undefined' do
      it 'does nothing' do
        expect(render(index_0)).to be_nil
      end
    end

    context 'when the array is defined' do
      context 'when the index is in bounds' do
        context 'when the index is at the start of the array' do
          it 'inserts the value at the index' do
            expect(render(index_0, values_2))
              .to eq(['value0', 'value1', 'value2'])
          end
        end

        context 'when the index is in the middle of the array' do
          it 'inserts the value at the index' do
            expect(render(index_1, values_2))
              .to eq(['value1', 'value0', 'value2'])
          end
        end

        context 'when the index is at the end of the array' do
          it 'inserts the value at the index' do
            expect(render(index_2, values_2))
              .to eq(['value1', 'value2', 'value0'])
          end
        end

        context 'when the index is not specified' do
          let(:no_index) { '{%- array_insert array:values value:"value0" -%}' }

          it 'raises ArgumentError' do
            expect { render(no_index) }.to raise_error(Liquid::ArgumentError)
          end
        end

        context 'when the value is not specified' do
          let(:no_value) { '{%- array_insert array:values index:0 -%}' }

          it 'raises ArgumentError' do
            expect { render(no_value) }.to raise_error(Liquid::ArgumentError)
          end
        end
      end

      context 'when the index is out of bounds' do
        it 'does nothing' do
          expect(render(index_2, values_1)).to eq(['value1'])
        end
      end
    end

    context 'when the array is not specified' do
      context 'when outside of an array block' do
        let(:no_array) { '{%- array_insert index:0 value:"value0" -%}' }

        it 'does nothing' do
          expect(render(no_array)).to be_nil
        end
      end

      context 'when inside of an array block' do
        let(:array_block) {
          '{%- array values -%}'\
            '{%- array_insert index:0 value:"value0" -%}'\
          '{%- endarray -%}'
        }

        it 'inserts the value at the index' do
          expect(render(array_block)).to eq(['value0'])
        end
      end
    end
  end
end