json.array! @tags.each do |t|
    json.id t.id
    json.text t.text
end
