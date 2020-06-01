class PostRecommender
    include Predictor::Base
    input_matrix :users, weight: 3.0
    input_matrix :tags, weight: 2.0
    input_matrix :search, weight: 3.0
    input_matrix :location, weight: 2.0
end