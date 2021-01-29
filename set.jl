
mutable struct myBitSet
    elems::Array{Bool}
    size::Integer

    function myBitSet(n)
        myelems = [false for i in 1:n]
        return new(myelems, n)
    end

end

function countBits(s::myBitSet)
    cnt = 0
    for i  in  1:s.size
        if s.elems[i]
            cnt = cnt+1
        end
    end
    return cnt
end

function isEmpty(s::myBitSet)
    for i  in  1:s.size
        if s.elems[i]
            return true
        end
    end
    return false
end

function add(s::myBitSet, i)
    if i <= s.size
        s.elems[i] = true
    end
end

function remove(s::myBitSet, i)
    if i <= s.size
        s.elems[i] = false
    end
end

function isIn(s::myBitSet, i)
    if i <= s.size
        return s.elems[i]
    else
        return false
    end
end

function cup(s::myBitSet, p::myBitSet, q::myBitSet)
    s = p | q
end

function cap(s::myBitSet, p::myBitSet, q::myBitSet)
    s = p & q
end

function minus(s::myBitSet, p::myBitSet, q::myBitSet)
    for i = 1:s.size
      s.elems[i] = false
      if p.elems[i] && !q.elems[i]
          s.elems[i] = true
      end
    end
end

function compl(s::myBitSet,  p::myBitSet)
  for i = 1:s.size
    p.elems[i] = false
    if !s.elems[i]
        p.elems[i] = true
    end
  end
end

function isCapEmpty(s::myBitSet, p::myBitSet)
  for i = 1:s.size
    if p.elems[i] && q.elems[i]
        return true
    end
  end
  return false
end

function myCopy(s::myBitSet,  p::myBitSet)
  for i = 1:s.size
    p.elems[i] = s.elems[i]
  end
end

function toList(s::myBitSet)
    return [x for x in 1:s.size if (s.elems[x] == true)]
end

function printSet(s::myBitSet)
    #println("Vector com tamanho : ", s.size)
    for i in 1:s.size
        if s.elems[i]
            print("|", i, "|")
        end
    end
    println()
end
