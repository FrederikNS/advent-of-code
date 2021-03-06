def op_mode(opcode)
    [
        (opcode / 100) % 10 == 1,
        (opcode / 1000) % 10 == 1,
        (opcode / 10000) == 1
    ]
end

def process_program052(program, inputs=nil)
    position = 0
    input_position = 0 unless inputs.nil?
    outputs = []
    while true
        op_mode = op_mode program[position]
        op = program[position] % 100
        param_location = [
            op_mode[0] ? position + 1 : program[position + 1],
            op_mode[1] ? position + 2 : program[position + 2],
            op_mode[2] ? position + 3 : program[position + 3],
        ]
#        binding.pry

        case op
        when 1 # add
            program[program[position + 3]] = program[param_location[0]] + program[param_location[1]]
            position += 4
        when 2 # multiply
            program[program[position + 3]] = program[param_location[0]] * program[param_location[1]]
            position += 4
        when 3 # input
            if inputs.nil?
                print "> "
                STDOUT.flush
                program[program[position + 1]] = gets.chomp.to_i
            else
                program[program[position + 1]] = inputs[input_position]
                input_position += 1
            end
            position += 2
        when 4 # output
            #puts program[param_location[0]]
            outputs << program[param_location[0]]
            position += 2
        when 5 # jump-if-true
            if program[param_location[0]] != 0
                position = program[param_location[1]]
            else
                position += 3
            end
        when 6 # jump-if-false
            if program[param_location[0]] == 0
                position = program[param_location[1]]
            else
                position += 3
            end
        when 7 # less than
            program[program[position + 3]] = (program[param_location[0]] < program[param_location[1]]) ? 1 : 0
            position += 4
        when 8 # equals
            program[program[position + 3]] = (program[param_location[0]] == program[param_location[1]]) ? 1 : 0
            position += 4
        when 99 # exit
            break
        else
            raise Exception.new("Invalid instruction at position #{position}, found instruction #{program[position]}.\n#{program}")
        end
    end
    return outputs
end

#if __FILE__ == $0
#    input = File.read('2019/02/puzzle-input.txt')
#
#    puts program.inspect
#    program[1] = 12
#    program[2] = 2
#    result = process_program program
#    puts result[0]
#end


if __FILE__ == $0
    input = File.read('2019/05/puzzle-input.txt')
    program = input.chomp.split(',').map { |string_ops| string_ops.to_i }

    result = process_program052(program, [5])
    puts result
end
