json.array!(@posts) do |post|
  json.extract! post, :id, :title, :content
  json.url post_url(post, format: :json)
  json.category do |json|
    json.extract! post.category, :name, :description if post.category
  end
end

