require_relative '../../../2019/09/part1.rb'

RSpec.describe '2019/09/Part1' do
    xit 'it works on the first input' do
        program = 109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99
        result = process_program091(program, [])
        expect(result).to eq program
    end
end
