### 省
class Local::Province < Local
  has_many :cities, class_name: "Local::City", foreign_key: :parent_id
end
