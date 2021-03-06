# function eval_metric(::Val{:mse}, pred::AbstractMatrix{T}, Y::AbstractVector{T}, α=0.0) where T <: AbstractFloat
#     eval = mean((pred .- Y) .^ 2)
#     return eval
# end
function eval_metric(::Val{:mse}, pred::Vector{SVector{1,T}}, Y::AbstractVector{T}, α) where T <: AbstractFloat
    eval = zero(T)
    @inbounds for i in 1:length(pred)
        eval += (pred[i][1] - Y[i]) ^ 2
    end
    eval /= length(pred)
    return eval
end

function eval_metric(::Val{:rmse}, pred::Vector{SVector{1,T}}, Y::AbstractVector{T}, α=0.0) where T <: AbstractFloat
    eval = zero(T)
    @inbounds for i in 1:length(pred)
        eval += (pred[i][1] - Y[i]) ^ 2
    end
    eval = sqrt(eval/length(pred))
    return eval
end

function eval_metric(::Val{:mae}, pred::Vector{SVector{1,T}}, Y::AbstractVector{T}, α=0.0) where T <: AbstractFloat
    eval = zero(T)
    @inbounds for i in 1:length(pred)
        eval += abs(pred[i][1] - Y[i])
    end
    eval /= length(pred)
    return eval
end

function eval_metric(::Val{:logloss}, pred::Vector{SVector{1,T}}, Y::AbstractVector{T}, α=0.0) where T <: AbstractFloat
    eval = zero(T)
    @inbounds for i in 1:length(pred)
        eval -= Y[i] * log(max(1e-8, sigmoid(pred[i][1]))) + (1 - Y[i]) * log(max(1e-8, 1 - sigmoid(pred[i][1])))
    end
    eval /= length(pred)
    return eval
end

function eval_metric(::Val{:mlogloss}, pred::Vector{SVector{L,T}}, Y::Vector{S}, α=0.0) where {T <: AbstractFloat, L, S <: Integer}
    eval = zero(T)
    # pred = pred - maximum.(pred)
    @inbounds for i in 1:length(pred)
        pred[i] = pred[i] .- maximum(pred[i])
        soft_pred = exp.(pred[i]) / sum(exp.(pred[i]))
        eval -= log(soft_pred[Y[i]])
    end
    eval /= length(Y)
    return eval
end

function eval_metric(::Val{:poisson}, pred::Vector{SVector{1,T}}, Y::AbstractVector{T}, α=0.0) where T <: AbstractFloat
    eval = zero(T)
    @inbounds for i in 1:length(pred)
        eval += exp(pred[i][1]) * (1 - Y[i]) + log(factorial(Y[i]))
    end
    eval /= length(pred)
    return eval
end

# gaussian
# pred[i][1] = μ
# pred[i][2] = log(σ²)
function eval_metric(::Val{:gaussian}, pred::Vector{SVector{L,T}}, Y::AbstractVector{T}, α=0.0) where {L, T <: AbstractFloat}
    eval = zero(T)
    @inbounds for i in 1:length(pred)
        eval += pred[i][2]/2 + (Y[i] - pred[i][1])^2 / (2*max(1e-8, exp(pred[i][2])))
    end
    eval /= length(Y)
    return eval
end

function eval_metric(::Val{:quantile}, pred::Vector{SVector{1,T}}, Y::AbstractVector{T}, α=0.0) where T <: AbstractFloat
    eval = zero(T)
    for i in 1:length(pred)
        eval += α * max(Y[i] - pred[i][1], zero(T)) + (1-α) * max(pred[i][1] - Y[i], zero(T))
    end
    eval /= length(pred)
    return eval
end
