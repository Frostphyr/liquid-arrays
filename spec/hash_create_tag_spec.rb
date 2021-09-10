require 'spec_helper'

describe Arrays::HashCreateTag do
  let(:values) { {'values' => 'value0'} }

  context 'when creating a hash without entries' do
    let(:no_entries) { '{%- hash_create values -%}' }

    context 'when the variable is defined' do
      it 'creates a new empty hash' do
        expect(render(no_entries, values)).to eq({})
      end
    end

    context 'when the variable is undefined' do
      it 'creates a new empty hash' do
        expect(render(no_entries)).to eq({})
      end
    end
  end

  context 'when creating a hash with entries' do
    let(:with_entries) do
      '{%- hash_create hash:values entries:"key1">"value1" -%}'
    end

    context 'when the variable is defined' do
      it 'creates a new hash with the entries' do
        expect(render(with_entries, values)).to eq({'key1' => 'value1'})
      end
    end

    context 'when the variable is undefined' do
      it 'creates a new hash with the entries' do
        expect(render(with_entries)).to eq({'key1' => 'value1'})
      end
    end
  end

  context 'when creating a hash without a hash specified' do
    context 'when entries are not specified' do
      let(:no_hash_no_entries) { '{%- hash_create -%}' }

      it 'raises SyntaxError' do
        expect {
          render(no_hash_no_entries)
        }.to raise_error(Liquid::SyntaxError)
      end
    end

    context 'when entries are specified' do
      let(:no_hash_with_entries) do
        '{%- hash_create entries:"value1","value2" -%}'
      end

      it 'raises SyntaxError' do
        expect {
          render(no_hash_with_entries)
        }.to raise_error(Liquid::SyntaxError)
      end
    end
  end
end