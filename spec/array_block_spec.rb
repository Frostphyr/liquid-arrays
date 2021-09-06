require 'spec_helper'

describe Arrays::ArrayBlock do
  context 'when the array is undefined' do
    let(:empty) { '{%- array values -%}{%- endarray -%}' }

    it 'creates an empty array' do
      expect(render(empty)).to eq([])
    end
  end

  context 'when the array is not an array' do
    let(:values_string) {
      '{%- assign values = "value1" -%}'\
      '{%- array values -%}'\
        '{%- array_add "value2" -%}'\
      '{%- endarray -%}'
    }

    it 'does nothing' do
      expect(render(values_string)).to eq('value1')
    end
  end

  context 'when no array is specified' do
    let(:no_array) { '{%- array -%}{%- endarray -%}' }

    it 'raises SyntaxError' do
      expect{ render(no_array) }.to raise_error(Liquid::SyntaxError)
    end
  end

  context 'when two blocks are nested' do
    let(:nested) {
      '{%- array values -%}'\
        '{%- array values2 -%}'\
          '{%- array_add 1 -%}'\
          '{%- array_add 2 -%}'\
        '{%- endarray -%}'\
        '{%- array_add "value1" -%}'\
        '{%- array_add values2 -%}'\
      '{%- endarray -%}'
    }
    
    it 'modifies most outer array' do
      expect(render(nested)).to eq(['value1', [1, 2]])
    end
  end
end