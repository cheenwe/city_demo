### 街道
class Local::Street < Local

  belongs_to :district, class_name: "Local::District", foreign_key: :parent_id
end
