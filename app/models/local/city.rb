### 市级
class Local::City < Local
  has_many :districts, class_name: "Local::District", foreign_key: :parent_id
  belongs_to :contuny, class_name:  "Local::Province", foreign_key: :parent_id
end
