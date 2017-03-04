require 'spec_helper'

RSpec.describe RRPN do
  describe 'RRPN convert and calculate' do
    describe '.calc' do
      let(:test_case01) { [1, 1, :+] }
      let(:test_case02) { [100, 100, :*] }

      it { expect(RRPN.calc(test_case01)).to eq(2) }
      it { expect(RRPN.calc(test_case02)).to eq(10_000) }
    end

    describe 'repeat output' do
      let(:test_case01) { '1 + 1' }

      it 'repeat output' do
        rpn = test_case01.to_rpn

        expect(rpn.calc).to eq(2)
        expect(rpn.calc).to eq(2)
      end
    end

    describe 'Integer' do
      context 'default' do
        let(:test_case01) { '1 + 1' }
        let(:test_case02) { '1 + 2 + 3' }
        let(:test_case03) { '1 + 1 * 2' }
        let(:test_case04) { '2 ** 10' }
        let(:test_case05) { '1 << 4' }
        let(:test_case06) { '10 % 3' }
        let(:test_case07) { '~3 + 4' }
        let(:test_case08) { '-2 ** 4' }
        let(:test_case09) { '64 >> 2' }
        let(:test_case10) { '23 & (1 << 4)' }
        let(:test_case11) { '64 ^ 32' }
        let(:test_case12) { '(1 + 1) * 2' }
        let(:test_case13) { '(((1 + 1)))' }
        let(:test_case14) { '32 | 64' }
        let(:test_case15) { '1_000_000 + 10_000' }

        it { expect(test_case01.to_rpn.to_s).to eq('1 1 +') }
        it { expect(test_case02.to_rpn.to_s).to eq('1 2 + 3 +') }
        it { expect(test_case03.to_rpn.to_s).to eq('1 1 2 * +') }
        it { expect(test_case04.to_rpn.to_s).to eq('2 10 **') }
        it { expect(test_case05.to_rpn.to_s).to eq('1 4 <<') }
        it { expect(test_case06.to_rpn.to_s).to eq('10 3 %') }
        it { expect(test_case07.to_rpn.to_s).to eq('3 ~ 4 +') }
        it { expect(test_case08.to_rpn.to_s).to eq('2 4 ** -@') }
        it { expect(test_case09.to_rpn.to_s).to eq('64 2 >>') }
        it { expect(test_case10.to_rpn.to_s).to eq('23 1 4 << &') }
        it { expect(test_case11.to_rpn.to_s).to eq('64 32 ^') }
        it { expect(test_case12.to_rpn.to_s).to eq('1 1 + 2 *') }
        it { expect(test_case13.to_rpn.to_s).to eq('1 1 +') }
        it { expect(test_case14.to_rpn.to_s).to eq('32 64 |') }
        it { expect(test_case15.to_rpn.to_s).to eq('1000000 10000 +') }

        it { expect(test_case01.to_rpn.calc).to eq(eval(test_case01)) }
        it { expect(test_case02.to_rpn.calc).to eq(eval(test_case02)) }
        it { expect(test_case03.to_rpn.calc).to eq(eval(test_case03)) }
        it { expect(test_case04.to_rpn.calc).to eq(eval(test_case04)) }
        it { expect(test_case05.to_rpn.calc).to eq(eval(test_case05)) }
        it { expect(test_case06.to_rpn.calc).to eq(eval(test_case06)) }
        it { expect(test_case07.to_rpn.calc).to eq(eval(test_case07)) }
        it { expect(test_case08.to_rpn.calc).to eq(eval(test_case08)) }
        it { expect(test_case09.to_rpn.calc).to eq(eval(test_case09)) }
        it { expect(test_case10.to_rpn.calc).to eq(eval(test_case10)) }
        it { expect(test_case11.to_rpn.calc).to eq(eval(test_case11)) }
        it { expect(test_case12.to_rpn.calc).to eq(eval(test_case12)) }
        it { expect(test_case13.to_rpn.calc).to eq(eval(test_case13)) }
        it { expect(test_case14.to_rpn.calc).to eq(eval(test_case14)) }
        it { expect(test_case15.to_rpn.calc).to eq(eval(test_case15)) }
      end
    end

    describe 'Float' do
      let(:test_case01) { '1.0 + 2.0' }
      let(:test_case02) { '(1.0 + 2.0) * 3.0' }
      let(:test_case03) { '1.2 + 3.4 / 1.8' }

      it { expect(test_case01.to_rpn.to_s).to eq('1.0 2.0 +') }
      it { expect(test_case02.to_rpn.to_s).to eq('1.0 2.0 + 3.0 *') }
      it { expect(test_case03.to_rpn.to_s).to eq('1.2 3.4 1.8 / +') }

      it { expect(test_case01.to_rpn.calc).to eq(eval(test_case01)) }
      it { expect(test_case02.to_rpn.calc).to eq(eval(test_case02)) }
      it { expect(test_case03.to_rpn.calc).to eq(eval(test_case03)) }
    end

    describe 'Rational' do
      let(:test_case1) { '1/2r + 1/2r' }
      let(:test_case2) { '2/3r * 4' }
      let(:test_case3) { '(2/3r) ** 2' }

      it { expect(test_case1.to_rpn.to_s).to eq('1 2r / 1 2r / +') }
      it { expect(test_case1.to_rpn.calc).to eq(eval(test_case1)) }
      it { expect(test_case2.to_rpn.to_s).to eq('2 3r / 4 *') }
      it { expect(test_case2.to_rpn.calc).to eq(eval(test_case2)) }
      it { expect(test_case3.to_rpn.to_s).to eq('2 3r / 2 **') }
      it { expect(test_case3.to_rpn.calc).to eq(eval(test_case3)) }
    end

    describe 'Complex' do
      let(:test_case01) { '1 + 2i + 3 + 4i' }
      let(:test_case02) { '2i ** 2' }
      let(:test_case03) { '(1+2i) * 3' }

      it { expect(test_case01.to_rpn.to_s).to eq('1 2i + 3 + 4i +') }
      it { expect(test_case02.to_rpn.to_s).to eq('2i 2 **') }
      it { expect(test_case03.to_rpn.to_s).to eq('1 2i + 3 *') }
      it { expect(test_case01.to_rpn.calc).to eq(eval(test_case01)) }
      it { expect(test_case02.to_rpn.calc).to eq(eval(test_case02)) }
      it { expect(test_case03.to_rpn.calc).to eq(eval(test_case03)) }
    end
  end
end
