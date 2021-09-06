require 'spec_helper'

describe Arrays::HashDeleteTag do
  let(:values) { {'values' => {'key1' => 'value1'}} }

  context 'when deleting a key' do
    let(:key_0) { '{%- hash_delete hash:values key:"key0" -%}' }
    let(:key_1) { '{%- hash_delete hash:values key:"key1" -%}' }

    context 'when the hash is undefined' do
      it 'does nothing' do
        expect(render(key_0)).to be_nil
      end
    end

    context 'when the hash is defined' do
      context 'when the key exists' do
        it 'deletes the pair' do
          expect(render(key_1, values)).to eq({})
        end
      end

      context 'when the key does not exist' do
        it 'does nothing' do
          expect(render(key_0, values)).to eq({'key1' => 'value1'})
        end
      end

      context 'when the hash is not a hash' do
        let(:values_string) { {'values' => 'value1'} }

        it 'does nothing' do
          expect(render(key_0, values_string)).to eq('value1')
        end
      end
    end

    context 'when the hash is not specified' do
      context 'when outside of a hash block' do
        let(:no_hash) { '{%- hash_delete key:"key0" -%}' }

        it 'does nothing' do
          expect(render(no_hash)).to be_nil
        end
      end

      context 'when inside of a hash block' do
        let(:hash_block) {
          '{%- hash values -%}'\
            '{%- hash_delete "key1" -%}'\
          '{%- endhash -%}'
        }
    
        it 'deletes the pair' do
          expect(render(hash_block, values)).to eq({})
        end
      end
    end
  end

  context 'when deleting without a key' do
    let(:no_key) { '{%- hash_delete hash:values -%}' }

    it 'raises SyntaxError' do
      expect { render(no_key, values) }.to raise_error(Liquid::SyntaxError)
    end
  end
end