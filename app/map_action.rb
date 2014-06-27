require 'matrix'

class Matrix
 	def []=(i, j, x)
    return -1 if (i >= self.row_count  || j >= self.column_count)
   	@rows[i][j] = x
  end
end

module MapAction
	DEFAULT_CELL_VALUE = :O

	def self.create_map params
		x, y = params[:x], params[:y]
		value = (params.has_key? :c1) ? params[:c1] : DEFAULT_CELL_VALUE
		Matrix.build(y, x) {value}
	end 

	def self.position params
    return params[:grid] if(params[:exec])
    params[:exec] = true
		x, y = params[:x1], params[:y1]
		value = (params.has_key? :c1) ? params[:c1] : DEFAULT_CELL_VALUE
    if(params[:grid].[]=(y, x, value) == -1)
      params[:lost]=true
    end
		params[:grid]
  end

  def self.rotate params
    return params[:grid] if(params[:exec])
    params[:exec] = true
    x, y = params[:x], params[:y]
    value = params[:grid][y,x]
    case value.to_sym
      when :N
        value = params[:key] == :R ? :E : :W
      when :S
        value = params[:key] == :R ? :W : :E
      when :W
        value = params[:key] == :R ? :N : :S
      when :E
        value = params[:key] == :R ? :S : :N
    end
    params[:grid].[]= y, x, value
    params[:grid]
  end

  def self.inc params, step=1
    return params[:grid] if(params[:exec])
    params[:exec] = true
    x, y = params[:x], params[:y]
    value = params[:grid][y,x]


    case value.to_sym
      when :N
        params[:x1] = x
        params[:y1] = y + step
      when :S
        params[:x1] = x
        params[:y1] = y - step
      when :W
        params[:y1] = y
        params[:x1] = x + step
      when :E
        params[:y1] = y
        params[:x1] = x - step
    end

    result =params[:grid].[]=(params[:y1], params[:x1], value)
    if(result) == -1
      params[:lost] = true
    end

    params[:grid]
  end

	def self.show_map params
		params
  end
end