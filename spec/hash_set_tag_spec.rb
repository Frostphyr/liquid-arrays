require 'spec_helper'

describe Arrays::HashSetTag do
  context 'when mapping a key-value pair' do
    let(:values) { {'values' => {'key1' => 'value1'}} }
    let(:key_0) { '{%- hash_set hash:values key:"key0" value:"value0" -%}' }
    let(:key_1) { '{%- hash_set hash:values key:"key1" value:"value0" -%}' }

    context 'when the hash is undefined' do
      it 'creates the hash and maps the pair' do
        expect(render(key_0)).to eq({'key0' => 'value0'})
      end
    end

    context 'when the hash is defined' do
      context 'when the key does not exist' do
        it 'adds the pair' do
          expect(render(key_0, values))
            .to eq({'key1' => 'value1', 'key0' => 'value0'})
        end
      end

      context 'when the key exists' do
        it 'replaces the key\'s value' do
          expect(render(key_1, values)).to eq({'key1' => 'value0'})
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
        let(:no_hash) { '{%- hash_set key:"key0" value:"value0" -%}' }

        it 'does nothing' do
          expect(render(no_hash)).to be_nil
        end
      end

      context 'when inside of a hash block' do
        let(:hash_block) {
          '{%- hash values -%}'\
            '{%- hash_set key:"key0" value:"value0" -%}'\
          '{%- endhash -%}'
        }
    
        it 'maps the pair' do
          expect(render(hash_block, values))
            .to eq({'key0' => 'value0', 'key1' => 'value1'})
        end
      end
    end
  end

  context 'when mapping without a key' do
    let(:no_key) { '{%- hash_set hash:values value:"value0" -%}' }

    it 'raises SyntaxError' do
      expect { render(no_key) }.to raise_error(Liquid::SyntaxError)
    end
  end

  context 'when mapping without a value' do
    let(:no_value) { '{%- hash_set hash:values key:"key0" -%}' }

    it 'raises SyntaxError' do
      expect { render(no_value) }.to raise_error(Liquid::SyntaxError)
    end
  end

end