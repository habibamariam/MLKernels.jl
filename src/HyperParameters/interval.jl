#== Interval Type ==#

immutable Interval{T<:Real}
    left::Nullable{Bound{T}}
    right::Nullable{Bound{T}}
    function Interval(left::Nullable{Bound{T}}, right::Nullable{Bound{T}})
        if !isnull(left) && !isnull(right)
            rbound = get(right)
            lbound = get(left)
            if lbound.isopen || rbound.isopen
                lbound.value <  rbound.value || error("Invalid bounds")
            else
                lbound.value <= rbound.value || error("Invalid bounds")
            end
        end
        new(left, right)
    end
end
Interval{T<:Real}(left::Nullable{Bound{T}}, right::Nullable{Bound{T}}) = Interval{T}(left, right)
Interval{T<:Real}(left::Bound{T}, right::Bound{T}) = Interval(Nullable(left), Nullable(right))

eltype{T}(::Interval{T}) = T

function leftbounded{T<:Real}(value::T, boundtype::Symbol)
    if boundtype == :open
        Interval(Nullable(Bound(value, true)),  Nullable{Bound{T}}())
    elseif boundtype == :closed
        Interval(Nullable(Bound(value, false)), Nullable{Bound{T}}())
    else
        error("Bound type $boundtype not recognized")
    end
end
leftbounded{T<:Real}(left::Bound{T}) = Interval(Nullable(left), Nullable{Bound{T}}())

function rightbounded{T<:Real}(value::T, boundtype::Symbol)
    if boundtype == :open
        Interval(Nullable{Bound{T}}(), Nullable(Bound(value, true)))
    elseif boundtype == :closed
        Interval(Nullable{Bound{T}}(), Nullable(Bound(value, false)))
    else
        error("Bound type $boundtype not recognized")
    end
end
rightbounded{T<:Real}(right::Bound{T}) = Interval(Nullable{Bound{T}}(), Nullable(right))


unbounded{T<:Real}(::Type{T}) = Interval(Nullable{Bound{T}}(), Nullable{Bound{T}}())

function convert{T<:Real}(::Type{Interval{T}}, I::Interval)
    if isnull(I.left)
        isnull(I.right) ? unbounded(T) : rightbounded(convert(Bound{T}, get(I.right)))
    else
        if isnull(I.right)
            leftbounded(convert(Bound{T}, get(I.left)))
        else
            Interval(convert(Bound{T}, get(I.left)), convert(Bound{T}, get(I.right)))
        end
    end
end


function description_string{T}(I::Interval{T})
    interval =  string("Interval{", T, "}")
    if isnull(I.left)
        if isnull(I.right)
            string(interval, "(-∞,∞)")
        else
            string(interval, "(-∞,", get(I.right).value, get(I.right).isopen ? ")" : "]")
        end
    else
        left = string(get(I.left).isopen ? "(" : "[",  get(I.left).value, ",")
        if isnull(I.right)
            string(interval, left, "∞)")
        else
            string(interval, left, get(I.right).value, get(I.right).isopen ? ")" : "]")
        end
    end
end
function show{T}(io::IO, I::Interval{T})
    print(io, description_string(I))
end


function checkbounds{T<:Real}(I::Interval{T}, x::T)
    if isnull(I.left)
        if isnull(I.right)
            true
        else
            ub = get(I.right)
            ub.isopen ? (x < ub.value) : (x <= ub.value)
        end
    else
        lb = get(I.left)
        if isnull(I.right)
            lb.isopen ? (lb.value < x) : (lb.value <= x)
        else
            ub = get(I.right)
            if ub.isopen
                lb.isopen ? (lb.value < x < ub.value) : (lb.value <= x < ub.value)
            else
                lb.isopen ? (lb.value < x <= ub.value) : (lb.value <= x <= ub.value)
            end
        end
    end
end
